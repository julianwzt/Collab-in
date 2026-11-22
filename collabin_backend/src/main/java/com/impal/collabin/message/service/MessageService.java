package com.impal.collabin.message.service;

import com.impal.collabin.auth.entity.User;
import com.impal.collabin.auth.respository.UserRepository;
import com.impal.collabin.collaboration.entity.Collaboration;
import com.impal.collabin.collaboration.repository.CollaborationRepository;
import com.impal.collabin.core.service.TimezoneService;
import com.impal.collabin.core.service.TokenService;
import com.impal.collabin.core.service.UrlService;
import com.impal.collabin.message.entity.ProjectMessage;
import com.impal.collabin.message.entity.ProjectMessageRead;
import com.impal.collabin.message.model.response.ConversationResponse;
import com.impal.collabin.message.model.response.MessageResponse;
import com.impal.collabin.message.repository.ProjectMessageReadRepository;
import com.impal.collabin.message.repository.ProjectMessageRepository;
import com.impal.collabin.project.entity.Project;
import com.impal.collabin.project.respository.ProjectRepository;
import jakarta.transaction.Transactional;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Chat grup per project. Anggota chat = pemilik project + kolaborator berstatus ACCEPTED.
 * Identitas pengguna selalu diambil dari token (bukan dari body request).
 */
@Service
public class MessageService {

    private static final int MAX_MESSAGE_LENGTH = 2000;

    private final ProjectMessageRepository messageRepository;
    private final ProjectMessageReadRepository readRepository;
    private final ProjectRepository projectRepository;
    private final CollaborationRepository collaborationRepository;
    private final UserRepository userRepository;
    private final TokenService tokenService;
    private final TimezoneService timezoneService;
    private final UrlService urlService;

    public MessageService(
            ProjectMessageRepository messageRepository,
            ProjectMessageReadRepository readRepository,
            ProjectRepository projectRepository,
            CollaborationRepository collaborationRepository,
            UserRepository userRepository,
            TokenService tokenService,
            TimezoneService timezoneService,
            UrlService urlService
    ) {
        this.messageRepository = messageRepository;
        this.readRepository = readRepository;
        this.projectRepository = projectRepository;
        this.collaborationRepository = collaborationRepository;
        this.userRepository = userRepository;
        this.tokenService = tokenService;
        this.timezoneService = timezoneService;
        this.urlService = urlService;
    }

    public List<ConversationResponse> getConversations(String authorizationHeader) {
        Integer userId = tokenService.extractUserIdFromAuthorizationHeader(authorizationHeader);
        String viewerTz = timezoneService.getUserTimezoneOrDefault(userId);

        // Project yang diikuti pengguna: milik sendiri + kolaborasi ACCEPTED (tanpa duplikat).
        Map<Integer, Project> projects = new LinkedHashMap<>();
        for (Project p : projectRepository.findActiveByUserId(userId)) {
            projects.put(p.getProjectId(), p);
        }
        for (Collaboration c : collaborationRepository.findByIdPengguna(userId)) {
            if (!"ACCEPTED".equalsIgnoreCase(c.getStatus()) || projects.containsKey(c.getProjectId())) {
                continue;
            }
            projectRepository.findActiveById(c.getProjectId())
                    .ifPresent(p -> projects.put(p.getProjectId(), p));
        }

        List<ConversationResponse> result = new ArrayList<>();
        for (Project project : projects.values()) {
            Integer projectId = project.getProjectId();
            long lastRead = readRepository.findByProjectIdAndUserId(projectId, userId)
                    .map(ProjectMessageRead::getLastReadMessageId)
                    .orElse(0L);
            MessageResponse last = messageRepository.findTopByProjectIdOrderByMessageIdDesc(projectId)
                    .map(m -> toResponse(m, viewerTz))
                    .orElse(null);
            int members = 1 + collaborationRepository.findByProjectIdAndStatus(projectId, "ACCEPTED").size();

            result.add(ConversationResponse.builder()
                    .projectId(projectId)
                    .title(project.getTitle())
                    .projectPicture(urlService.normalizeProfilePictureUrl(project.getFileUrl()))
                    .isOwner(project.getUser() != null && userId.equals(project.getUser().getIdPengguna()))
                    .memberCount(members)
                    .lastMessage(last)
                    .unreadCount(messageRepository.countByProjectIdAndMessageIdGreaterThanAndSenderIdNot(
                            projectId, lastRead, userId))
                    .build());
        }

        // Percakapan dengan pesan terbaru di atas; yang belum punya pesan di bawah.
        result.sort((a, b) -> {
            LocalDateTime ta = a.getLastMessage() == null ? null : a.getLastMessage().getCreatedAt();
            LocalDateTime tb = b.getLastMessage() == null ? null : b.getLastMessage().getCreatedAt();
            if (ta == null && tb == null) return 0;
            if (ta == null) return 1;
            if (tb == null) return -1;
            return tb.compareTo(ta);
        });
        return result;
    }

    @Transactional
    public List<MessageResponse> getMessages(String authorizationHeader, Integer projectId) {
        Integer userId = tokenService.extractUserIdFromAuthorizationHeader(authorizationHeader);
        requireMember(userId, projectId);
        String viewerTz = timezoneService.getUserTimezoneOrDefault(userId);

        List<ProjectMessage> messages = messageRepository.findByProjectIdOrderByMessageIdAsc(projectId);
        markRead(userId, projectId, messages.isEmpty() ? 0L : messages.get(messages.size() - 1).getMessageId());

        return messages.stream().map(m -> toResponse(m, viewerTz)).toList();
    }

    @Transactional
    public MessageResponse sendMessage(String authorizationHeader, Integer projectId, String rawText) {
        Integer userId = tokenService.extractUserIdFromAuthorizationHeader(authorizationHeader);
        requireMember(userId, projectId);

        String text = rawText == null ? "" : rawText.trim();
        if (text.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Pesan tidak boleh kosong");
        }
        if (text.length() > MAX_MESSAGE_LENGTH) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Pesan maksimal " + MAX_MESSAGE_LENGTH + " karakter");
        }

        ProjectMessage saved = messageRepository.save(ProjectMessage.builder()
                .projectId(projectId)
                .senderId(userId)
                .text(text)
                .createdAt(LocalDateTime.now())
                .build());
        markRead(userId, projectId, saved.getMessageId());

        return toResponse(saved, timezoneService.getUserTimezoneOrDefault(userId));
    }

    private void requireMember(Integer userId, Integer projectId) {
        Project project = projectRepository.findActiveById(projectId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Project tidak ditemukan"));

        boolean isOwner = project.getUser() != null && userId.equals(project.getUser().getIdPengguna());
        boolean isAcceptedMember = collaborationRepository.existsByProjectIdAndIdPenggunaAndStatusIn(
                projectId, userId, List.of("ACCEPTED"));

        if (!isOwner && !isAcceptedMember) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Kamu belum menjadi anggota project ini");
        }
    }

    private void markRead(Integer userId, Integer projectId, Long lastMessageId) {
        ProjectMessageRead state = readRepository.findByProjectIdAndUserId(projectId, userId)
                .orElseGet(() -> ProjectMessageRead.builder()
                        .projectId(projectId)
                        .userId(userId)
                        .lastReadMessageId(0L)
                        .build());
        if (lastMessageId > state.getLastReadMessageId()) {
            state.setLastReadMessageId(lastMessageId);
        }
        readRepository.save(state);
    }

    private MessageResponse toResponse(ProjectMessage message, String viewerTz) {
        User sender = userRepository.findById(message.getSenderId()).orElse(null);
        return MessageResponse.builder()
                .id(message.getMessageId())
                .projectId(message.getProjectId())
                .senderId(message.getSenderId())
                .senderName(sender != null ? sender.getNamaLengkap() : "Pengguna")
                .senderPicture(sender != null ? urlService.normalizeProfilePictureUrl(sender.getProfilePicture()) : null)
                .text(message.getText())
                .createdAt(timezoneService.convertToUserZone(message.getCreatedAt(), viewerTz))
                .build();
    }
}

package com.impal.collabin.message.controller;

import com.impal.collabin.core.model.SuccessResponse;
import com.impal.collabin.message.model.request.SendMessageRequest;
import com.impal.collabin.message.model.response.ConversationResponse;
import com.impal.collabin.message.model.response.MessageResponse;
import com.impal.collabin.message.service.MessageService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class MessageController {

    private final MessageService messageService;

    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    @GetMapping(
            value = "/api/v1/messages/conversations",
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public SuccessResponse<List<ConversationResponse>> getConversations(
            @RequestHeader("Authorization") String authorizationHeader
    ) {
        return SuccessResponse.<List<ConversationResponse>>builder()
                .status(200)
                .message("Conversations found")
                .data(messageService.getConversations(authorizationHeader))
                .build();
    }

    @GetMapping(
            value = "/api/v1/messages/project/{projectId}",
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public SuccessResponse<List<MessageResponse>> getMessages(
            @RequestHeader("Authorization") String authorizationHeader,
            @PathVariable("projectId") Integer projectId
    ) {
        return SuccessResponse.<List<MessageResponse>>builder()
                .status(200)
                .message("Messages found")
                .data(messageService.getMessages(authorizationHeader, projectId))
                .build();
    }

    @PostMapping(
            value = "/api/v1/messages/project/{projectId}",
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public SuccessResponse<MessageResponse> sendMessage(
            @RequestHeader("Authorization") String authorizationHeader,
            @PathVariable("projectId") Integer projectId,
            @RequestBody SendMessageRequest request
    ) {
        return SuccessResponse.<MessageResponse>builder()
                .status(200)
                .message("Pesan terkirim")
                .data(messageService.sendMessage(authorizationHeader, projectId, request.getText()))
                .build();
    }
}

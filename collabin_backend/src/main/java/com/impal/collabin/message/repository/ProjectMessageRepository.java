package com.impal.collabin.message.repository;

import com.impal.collabin.message.entity.ProjectMessage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProjectMessageRepository extends JpaRepository<ProjectMessage, Long> {

    List<ProjectMessage> findByProjectIdOrderByMessageIdAsc(Integer projectId);

    Optional<ProjectMessage> findTopByProjectIdOrderByMessageIdDesc(Integer projectId);

    long countByProjectIdAndMessageIdGreaterThanAndSenderIdNot(
            Integer projectId,
            Long messageId,
            Integer senderId
    );
}

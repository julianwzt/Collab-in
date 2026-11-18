package com.impal.collabin.notification.repository;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.impal.collabin.notification.entity.ProjectDeadlineNotificationLog;

public interface ProjectDeadlineNotificationLogRepository
        extends JpaRepository<ProjectDeadlineNotificationLog, Long> {

    boolean existsByProjectIdAndRecipientUserIdAndReminderTypeAndDeadlineSnapshot(
            Integer projectId,
            Integer recipientUserId,
            String reminderType,
            LocalDateTime deadlineSnapshot
    );

    Optional<ProjectDeadlineNotificationLog> findTopByProjectIdAndRecipientUserIdAndReminderTypeAndDeadlineSnapshotOrderBySentAtDesc(
            Integer projectId,
            Integer recipientUserId,
            String reminderType,
            LocalDateTime deadlineSnapshot
    );
}
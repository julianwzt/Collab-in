package com.impal.collabin.message.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(
        name = "project_messages",
        indexes = @Index(name = "idx_project_messages_project", columnList = "project_id, message_id")
)
public class ProjectMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "message_id")
    private Long messageId;

    @Column(name = "project_id", nullable = false)
    private Integer projectId;

    @Column(name = "sender_id", nullable = false)
    private Integer senderId;

    @Column(name = "text", nullable = false, columnDefinition = "TEXT")
    private String text;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
}

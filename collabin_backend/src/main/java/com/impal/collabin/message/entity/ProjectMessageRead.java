package com.impal.collabin.message.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Penanda pesan terakhir yang sudah dibaca satu pengguna di satu chat project.
 * Dipakai untuk menghitung unreadCount di daftar percakapan.
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(
        name = "project_message_reads",
        uniqueConstraints = @UniqueConstraint(
                name = "uk_project_message_reads_project_user",
                columnNames = {"project_id", "user_id"}
        )
)
public class ProjectMessageRead {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "read_id")
    private Long readId;

    @Column(name = "project_id", nullable = false)
    private Integer projectId;

    @Column(name = "user_id", nullable = false)
    private Integer userId;

    @Column(name = "last_read_message_id", nullable = false)
    private Long lastReadMessageId;
}

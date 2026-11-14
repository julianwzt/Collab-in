package com.collabin.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "collaborations")
public class Collaboration {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long collaborationId;

    private Long projectId;
    private Long userId;
    private String role;
    private String status = "PENDING"; // PENDING, ACCEPTED, REJECTED
    private LocalDateTime joinDate = LocalDateTime.now();

    public Collaboration() {}

    public Long getCollaborationId() { return collaborationId; }
    public void setCollaborationId(Long collaborationId) { this.collaborationId = collaborationId; }
    public Long getProjectId() { return projectId; }
    public void setProjectId(Long projectId) { this.projectId = projectId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getJoinDate() { return joinDate; }
    public void setJoinDate(LocalDateTime joinDate) { this.joinDate = joinDate; }
}

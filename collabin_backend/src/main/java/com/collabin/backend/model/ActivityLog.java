package com.collabin.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "activity_logs")
public class ActivityLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long activityLogId;

    private Long projectId;
    private Long userId;
    private String action;
    private LocalDateTime timestamp = LocalDateTime.now();

    public ActivityLog() {}

    public Long getActivityLogId() { return activityLogId; }
    public void setActivityLogId(Long activityLogId) { this.activityLogId = activityLogId; }
    public Long getProjectId() { return projectId; }
    public void setProjectId(Long projectId) { this.projectId = projectId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}

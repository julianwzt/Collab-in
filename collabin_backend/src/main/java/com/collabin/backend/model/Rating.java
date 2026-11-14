package com.collabin.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ratings")
public class Rating {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long ratingId;

    private Long userId;        // Evaluator (Project Owner)
    private Long ratedUserId;   // Recipient (Collaborator)
    private Long projectId;
    private Integer ratingValue;

    @Column(columnDefinition = "TEXT")
    private String review;
    private LocalDateTime createdAt = LocalDateTime.now();

    public Rating() {}

    public Long getRatingId() { return ratingId; }
    public void setRatingId(Long ratingId) { this.ratingId = ratingId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getRatedUserId() { return ratedUserId; }
    public void setRatedUserId(Long ratedUserId) { this.ratedUserId = ratedUserId; }
    public Long getProjectId() { return projectId; }
    public void setProjectId(Long projectId) { this.projectId = projectId; }
    public Integer getRatingValue() { return ratingValue; }
    public void setRatingValue(Integer ratingValue) { this.ratingValue = ratingValue; }
    public String getReview() { return review; }
    public void setReview(String review) { this.review = review; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

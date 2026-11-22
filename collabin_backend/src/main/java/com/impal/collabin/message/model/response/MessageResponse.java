package com.impal.collabin.message.model.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MessageResponse {
    private Long id;
    private Integer projectId;
    private Integer senderId;
    private String senderName;
    private String senderPicture;
    private String text;
    private LocalDateTime createdAt;
}

package com.impal.collabin.message.model.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ConversationResponse {
    private Integer projectId;
    private String title;
    private String projectPicture;
    private Boolean isOwner;
    private Integer memberCount;
    private MessageResponse lastMessage;
    private Long unreadCount;
}

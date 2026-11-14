package com.impal.collabin.collaboration.model.response;

import java.util.List;

import com.impal.collabin.project.model.response.ProjectResponse;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CollaborationDashboardResponse {

    private List<CollaborationResponse> requestCollab;
    private List<ProjectResponse> ownedProjects;
}
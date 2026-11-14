package com.collabin.backend.controller;

import com.collabin.backend.model.Project;
import com.collabin.backend.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/projects")
@CrossOrigin(origins = "*")
public class ProjectController {

    @Autowired
    private ProjectService projectService;

    @GetMapping
    public List<Project> getAllProjects() {
        return projectService.getAllProjects();
    }

    @PostMapping("/create")
    public ResponseEntity<?> createProject(@RequestBody Project project) {
        if (project.getTitle() == null || project.getTitle().isEmpty() ||
            project.getDescription() == null || project.getDescription().isEmpty()) {
            return ResponseEntity.badRequest().body("Field wajib diisi");
        }
        Project saved = projectService.saveProject(project);
        return ResponseEntity.ok(saved);
    }
}

package com.impal.collabin.message.repository;

import com.impal.collabin.message.entity.ProjectMessageRead;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProjectMessageReadRepository extends JpaRepository<ProjectMessageRead, Long> {

    Optional<ProjectMessageRead> findByProjectIdAndUserId(Integer projectId, Integer userId);
}

package com.collabin.backend.repository;

import com.collabin.backend.model.Collaboration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CollaborationRepository extends JpaRepository<Collaboration, Long> {
}

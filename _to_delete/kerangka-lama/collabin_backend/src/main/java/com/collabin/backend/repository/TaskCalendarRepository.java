package com.collabin.backend.repository;

import com.collabin.backend.model.TaskCalendar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskCalendarRepository extends JpaRepository<TaskCalendar, Long> {
}

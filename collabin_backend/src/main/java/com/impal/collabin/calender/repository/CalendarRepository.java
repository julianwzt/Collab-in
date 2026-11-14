package com.impal.collabin.calender.repository;

import com.impal.collabin.calender.entity.Calendar;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface CalendarRepository extends JpaRepository<Calendar, Integer> {
    Optional<Calendar> findByProjectIdAndIdPengguna(Integer projectId, Integer idPengguna);
}
package com.impal.collabin.Activitylog.repository;

import com.impal.collabin.Activitylog.entity.ActivityLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ActivityLogRepository extends JpaRepository<ActivityLog, Integer> {
    List<ActivityLog> findByUser_IdPenggunaOrderByTimestampDesc(Integer idPengguna);
}
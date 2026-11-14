package com.impal.collabin.portofolio.repository;

import com.impal.collabin.portofolio.entity.Portfolio;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PortfolioRepository extends JpaRepository<Portfolio, Integer> {
    List<Portfolio> findAllByIdPengguna(Integer idPengguna);
}
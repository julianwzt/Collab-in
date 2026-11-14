-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Nov 12, 2026 at 03:50 AM
-- Server version: 8.0.46
-- PHP Version: 8.3.35

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Collabin`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `activity_log_id` int NOT NULL,
  `project_id` int DEFAULT NULL,
  `id_pengguna` int DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `activity_log`
--

INSERT INTO `activity_log` (`activity_log_id`, `project_id`, `id_pengguna`, `action`, `timestamp`) VALUES
(1, 1, 1, 'Created project Collab-in', '2026-10-19 21:21:32'),
(2, 1, 2, 'Joined project as Backend Developer', '2026-10-19 21:21:32'),
(3, 1, 3, 'Updated project deadline', '2026-10-19 21:21:32'),
(4, 2, 2, 'Marked project as COMPLETED', '2026-10-19 21:21:32'),
(5, 3, 1, 'Requested collaboration', '2026-10-19 21:21:32');

-- --------------------------------------------------------

--
-- Table structure for table `calendar`
--

CREATE TABLE `calendar` (
  `event_id` int NOT NULL,
  `project_id` int DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text,
  `deadline` datetime DEFAULT NULL,
  `reminder_settings` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `calendar`
--

INSERT INTO `calendar` (`event_id`, `project_id`, `title`, `description`, `deadline`, `reminder_settings`) VALUES
(1, 1, 'Sprint 1 Review', 'Review fitur autentikasi', '2026-10-25 00:00:00', '2026-10-24 00:00:00'),
(2, 1, 'UI Design Deadline', 'Selesaikan mockup Figma', '2026-11-01 00:00:00', '2026-10-31 00:00:00'),
(3, 2, 'Bug Fixing', 'Fix error payment gateway', '2026-09-30 00:00:00', '2026-09-29 00:00:00'),
(4, 3, 'Dataset Collection', 'Kumpulkan 1000 dataset x-ray', '2026-11-15 00:00:00', '2026-11-10 00:00:00'),
(5, 4, 'Deploy to Server', 'Push ke AWS Production', '2026-11-19 00:00:00', '2026-11-18 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `collaboration`
--

CREATE TABLE `collaboration` (
  `collaboration_id` int NOT NULL,
  `project_id` int DEFAULT NULL,
  `id_pengguna` int DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `join_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `collaboration`
--

INSERT INTO `collaboration` (`collaboration_id`, `project_id`, `id_pengguna`, `role`, `status`, `join_date`) VALUES
(1, 1, 2, 'Backend Developer', 'ACCEPTED', '2026-10-15 00:00:00'),
(2, 1, 3, 'UI/UX Designer', 'ACCEPTED', '2026-10-16 00:00:00'),
(3, 2, 4, 'Data Analyst', 'PENDING', NULL),
(4, 3, 1, 'Frontend Developer', 'ACCEPTED', '2026-10-20 00:00:00'),
(5, 4, 5, 'DevOps Engineer', 'REJECTED', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `id_pengguna`, `message`, `is_read`, `timestamp`, `type`) VALUES
(1, 2, 'Anda diundang ke proyek Collab-in', 0, '2026-10-19 21:21:32', 'PROJECT_INVITATION'),
(2, 1, 'Julian menerima undangan kolaborasi Anda', 0, '2026-10-19 21:21:32', 'COLLAB_ACCEPTED'),
(3, 3, 'Deadline tugas UI Design kurang dari 24 jam!', 0, '2026-10-19 21:21:32', 'REMINDER'),
(4, 4, 'Permintaan bergabung ke proyek Moneyger ditolak', 0, '2026-10-19 21:21:32', 'COLLAB_REJECTED'),
(5, 5, 'Proyek Company Profile Web telah selesai', 0, '2026-10-19 21:21:32', 'PROJECT_UPDATE');

-- --------------------------------------------------------

--
-- Table structure for table `portfolio`
--

CREATE TABLE `portfolio` (
  `portfolio_id` int NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text,
  `file_url` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `upload_date` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `portfolio`
--

INSERT INTO `portfolio` (`portfolio_id`, `id_pengguna`, `title`, `description`, `file_url`, `image_url`, `upload_date`) VALUES
(1, 1, 'Clone Gojek App', 'Membuat UI Clone aplikasi Gojek', 'link/gojek-clone', NULL, '2026-10-19 21:21:32'),
(2, 2, 'REST API Golang', 'API untuk sistem perpustakaan', 'link/lib-api', NULL, '2026-10-19 21:21:32'),
(3, 3, 'Redesign Spotify', 'UI/UX Case Study Spotify', 'link/spotify-ui', NULL, '2026-10-19 21:21:32'),
(4, 4, 'Data Sales Analysis', 'Dashboard Tableau Sales 2025', 'link/tableau-sales', NULL, '2026-10-19 21:21:32'),
(5, 5, 'CI/CD Pipeline Setup', 'Setup Jenkins & Docker', 'link/cicd-docs', NULL, '2026-10-19 21:21:32');

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

CREATE TABLE `project` (
  `project_id` int NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `description` text,
  `category` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'ACTIVE',
  `repository_link` varchar(255) DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`project_id`, `id_pengguna`, `title`, `description`, `category`, `status`, `repository_link`, `file_url`, `deadline`, `created_at`) VALUES
(1, 1, 'Aplikasi Collab-in', 'Platform kolaborasi open source', 'Mobile App', 'ACTIVE', 'github.com/nathan/collab-in', NULL, '2026-12-31 00:00:00', '2026-10-19 21:21:32'),
(2, 2, 'Moneyger Application', 'Aplikasi manajemen keuangan', 'Web App', 'COMPLETED', 'github.com/julian/moneyger', NULL, '2026-10-01 00:00:00', '2026-10-19 21:21:32'),
(3, 3, 'Sistem Pakar AI', 'Sistem pakar diagnosa penyakit', 'AI/ML', 'ACTIVE', 'github.com/kanaka/sp-ai', NULL, '2027-01-15 00:00:00', '2026-10-19 21:21:32'),
(4, 4, 'E-Commerce API', 'Backend service untuk e-commerce', 'Backend', 'ACTIVE', 'github.com/satria/ecommerce-api', NULL, '2026-11-20 00:00:00', '2026-10-19 21:21:32'),
(5, 5, 'Company Profile Web', 'Website portofolio perusahaan', 'Web', 'COMPLETED', 'github.com/mustofa/compro', NULL, '2026-09-10 00:00:00', '2026-10-19 21:21:32');

-- --------------------------------------------------------

--
-- Table structure for table `project_skill`
--

CREATE TABLE `project_skill` (
  `project_id` int NOT NULL,
  `skill_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `project_skill`
--

INSERT INTO `project_skill` (`project_id`, `skill_id`) VALUES
(1, 1),
(1, 2),
(3, 2),
(2, 4),
(4, 5);

-- --------------------------------------------------------

--
-- Table structure for table `rating`
--

CREATE TABLE `rating` (
  `rating_id` int NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `rated_user_id` int DEFAULT NULL,
  `project_id` int DEFAULT NULL,
  `rating_value` int DEFAULT NULL,
  `review` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `rating`
--

INSERT INTO `rating` (`rating_id`, `id_pengguna`, `rated_user_id`, `project_id`, `rating_value`, `review`, `created_at`) VALUES
(1, 2, 4, 2, 5, 'Kerja sangat bagus dan cepat!', '2026-10-19 21:21:32'),
(2, 2, 3, 2, 4, 'Desain rapi, tapi agak telat sedikit.', '2026-10-19 21:21:32'),
(3, 5, 1, 5, 5, 'Sangat kooperatif sebagai tim.', '2026-10-19 21:21:32'),
(4, 5, 2, 5, 4, 'Backend stabil, minim bug.', '2026-10-19 21:21:32'),
(5, 1, 2, 1, 5, 'Awesome teammate!', '2026-10-19 21:21:32');

-- --------------------------------------------------------

--
-- Table structure for table `recommendation`
--

CREATE TABLE `recommendation` (
  `recommendation_id` int NOT NULL,
  `rec_user` int DEFAULT NULL,
  `to_user` int DEFAULT NULL,
  `project_id` int DEFAULT NULL,
  `message` text,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `recommendation`
--

INSERT INTO `recommendation` (`recommendation_id`, `rec_user`, `to_user`, `project_id`, `message`, `timestamp`) VALUES
(1, 1, 4, 1, 'Saya merekomendasikan Satria untuk Data Analyst di project ini.', '2026-10-19 21:21:32'),
(2, 2, 5, 2, 'Mustofa jago DevOps, cocok untuk manage server.', '2026-10-19 21:21:32'),
(3, 3, 1, 3, 'Nathan bisa bantu slicing UI dengan cepat.', '2026-10-19 21:21:32'),
(4, 4, 2, 4, 'Julian adalah backend dev terbaik yang saya kenal.', '2026-10-19 21:21:32'),
(5, 5, 3, 5, 'Desain Kanaka sangat modern dan clean.', '2026-10-19 21:21:32');

-- --------------------------------------------------------

--
-- Table structure for table `skill`
--

CREATE TABLE `skill` (
  `skill_id` int NOT NULL,
  `skill_name` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `level` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `skill`
--

INSERT INTO `skill` (`skill_id`, `skill_name`, `category`, `level`) VALUES
(1, 'Flutter', 'Mobile Dev', 'Intermediate'),
(2, 'Spring Boot', 'Backend Dev', 'Advanced'),
(3, 'Figma', 'UI/UX', 'Advanced'),
(4, 'MySQL', 'Database', 'Intermediate'),
(5, 'Docker', 'DevOps', 'Beginner');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_pengguna` int NOT NULL,
  `nama_lengkap` varchar(100) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `profile_picture` varchar(255) DEFAULT NULL,
  `bio` text,
  `institusi` varchar(100) DEFAULT NULL,
  `posisi_saat_ini` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_pengguna`, `nama_lengkap`, `username`, `email`, `password`, `created_at`, `profile_picture`, `bio`, `institusi`, `posisi_saat_ini`) VALUES
(1, 'Nathaniel Christ', 'nathan_c', 'nathan@email.com', 'hash123', '2026-10-19 21:21:32', NULL, 'Frontend Dev', 'Telkom University', 'Mahasiswa'),
(2, 'Julian Wimanjaya', 'julian_w', 'julian@email.com', 'hash123', '2026-10-19 21:21:32', NULL, 'Backend Dev', 'Telkom University', 'Mahasiswa'),
(3, 'Kanaka Pradipta', 'kanaka_p', 'kanaka@email.com', 'hash123', '2026-10-19 21:21:32', NULL, 'UI/UX Designer', 'Telkom University', 'Mahasiswa'),
(4, 'Satria Dinata', 'satria_d', 'satria@email.com', 'hash123', '2026-10-19 21:21:32', NULL, 'Data Scientist', 'Telkom University', 'Mahasiswa'),
(5, 'Mustofa Fathir', 'mustofa_f', 'mustofa@email.com', 'hash123', '2026-10-19 21:21:32', NULL, 'DevOps', 'Telkom University', 'Mahasiswa');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`activity_log_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indexes for table `calendar`
--
ALTER TABLE `calendar`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `collaboration`
--
ALTER TABLE `collaboration`
  ADD PRIMARY KEY (`collaboration_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indexes for table `portfolio`
--
ALTER TABLE `portfolio`
  ADD PRIMARY KEY (`portfolio_id`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indexes for table `project`
--
ALTER TABLE `project`
  ADD PRIMARY KEY (`project_id`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indexes for table `project_skill`
--
ALTER TABLE `project_skill`
  ADD PRIMARY KEY (`project_id`,`skill_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- Indexes for table `rating`
--
ALTER TABLE `rating`
  ADD PRIMARY KEY (`rating_id`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `rated_user_id` (`rated_user_id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `recommendation`
--
ALTER TABLE `recommendation`
  ADD PRIMARY KEY (`recommendation_id`),
  ADD KEY `rec_user` (`rec_user`),
  ADD KEY `to_user` (`to_user`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `skill`
--
ALTER TABLE `skill`
  ADD PRIMARY KEY (`skill_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `activity_log_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `calendar`
--
ALTER TABLE `calendar`
  MODIFY `event_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `collaboration`
--
ALTER TABLE `collaboration`
  MODIFY `collaboration_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `portfolio`
--
ALTER TABLE `portfolio`
  MODIFY `portfolio_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `project`
--
ALTER TABLE `project`
  MODIFY `project_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rating`
--
ALTER TABLE `rating`
  MODIFY `rating_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recommendation`
--
ALTER TABLE `recommendation`
  MODIFY `recommendation_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `skill_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD CONSTRAINT `activity_log_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `activity_log_ibfk_2` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE;

--
-- Constraints for table `calendar`
--
ALTER TABLE `calendar`
  ADD CONSTRAINT `calendar_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE;

--
-- Constraints for table `collaboration`
--
ALTER TABLE `collaboration`
  ADD CONSTRAINT `collaboration_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `collaboration_ibfk_2` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE;

--
-- Constraints for table `portfolio`
--
ALTER TABLE `portfolio`
  ADD CONSTRAINT `portfolio_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE;

--
-- Constraints for table `project`
--
ALTER TABLE `project`
  ADD CONSTRAINT `project_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE;

--
-- Constraints for table `project_skill`
--
ALTER TABLE `project_skill`
  ADD CONSTRAINT `project_skill_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `project_skill_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`skill_id`) ON DELETE CASCADE;

--
-- Constraints for table `rating`
--
ALTER TABLE `rating`
  ADD CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE,
  ADD CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`rated_user_id`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE,
  ADD CONSTRAINT `rating_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE;

--
-- Constraints for table `recommendation`
--
ALTER TABLE `recommendation`
  ADD CONSTRAINT `recommendation_ibfk_1` FOREIGN KEY (`rec_user`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE,
  ADD CONSTRAINT `recommendation_ibfk_2` FOREIGN KEY (`to_user`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE,
  ADD CONSTRAINT `recommendation_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Nov 19, 2026 at 06:41 AM
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
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_read` bit(1) NOT NULL,
  `message` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `activity_log`
--

INSERT INTO `activity_log` (`activity_log_id`, `project_id`, `id_pengguna`, `action`, `timestamp`, `is_read`, `message`) VALUES
(1, 1, 1, 'Created project Collab-in', '2026-10-19 21:21:32', b'0', ''),
(3, 1, 3, 'Updated project deadline', '2026-10-19 21:21:32', b'0', ''),
(5, 3, 1, 'Requested collaboration', '2026-10-19 21:21:32', b'0', ''),
(6, 6, 7, NULL, '2026-11-19 04:50:05', b'0', 'Created project: gali pasir'),
(7, 7, 9, NULL, '2026-11-07 04:59:00', b'0', 'Created project: Aplikasi Bank Sampah Digital'),
(8, 8, 9, NULL, '2026-11-10 04:59:00', b'0', 'Created project: Dashboard Monitoring IoT Kebun'),
(9, 9, 9, NULL, '2026-11-11 04:59:00', b'0', 'Requested collaboration: Mobile Development'),
(10, 7, 9, NULL, '2026-11-13 04:59:00', b'0', 'ACCEPT collaboration on project: Aplikasi Bank Sampah Digital'),
(11, 7, 9, NULL, '2026-11-16 04:59:00', b'0', 'Updated project: Aplikasi Bank Sampah Digital'),
(12, 10, 9, NULL, '2026-11-18 04:59:00', b'0', 'Requested collaboration: Mobile Development'),
(13, 9, 10, NULL, '2026-11-09 04:59:00', b'0', 'Created project: Redesign Website Himpunan'),
(14, 10, 11, NULL, '2026-11-08 04:59:00', b'0', 'Created project: API Marketplace UMKM');

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
  `reminder_settings` datetime DEFAULT NULL,
  `id_pengguna` int DEFAULT NULL,
  `is_done` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `calendar`
--

INSERT INTO `calendar` (`event_id`, `project_id`, `title`, `description`, `deadline`, `reminder_settings`, `id_pengguna`, `is_done`) VALUES
(1, 1, 'Sprint 1 Review', 'Review fitur autentikasi', '2026-10-25 00:00:00', '2026-10-24 00:00:00', NULL, NULL),
(2, 1, 'UI Design Deadline', 'Selesaikan mockup Figma', '2026-11-01 00:00:00', '2026-10-31 00:00:00', NULL, NULL),
(4, 3, 'Dataset Collection', 'Kumpulkan 1000 dataset x-ray', '2026-11-15 00:00:00', '2026-11-10 00:00:00', NULL, NULL),
(5, 4, 'Deploy to Server', 'Push ke AWS Production', '2026-11-19 00:00:00', '2026-11-18 00:00:00', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `collaboration`
--

CREATE TABLE `collaboration` (
  `collaboration_id` int NOT NULL,
  `project_id` int DEFAULT NULL,
  `id_pengguna` int DEFAULT NULL,
  `role` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `join_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `collaboration`
--

INSERT INTO `collaboration` (`collaboration_id`, `project_id`, `id_pengguna`, `role`, `status`, `join_date`) VALUES
(2, 1, 3, 'UI/UX Designer', 'ACCEPTED', '2026-10-16 00:00:00'),
(4, 3, 1, 'Frontend Developer', 'ACCEPTED', '2026-10-20 00:00:00'),
(5, 4, 5, 'DevOps Engineer', 'REJECTED', NULL),
(6, 7, 10, 'UI/UX Design', 'PENDING', '2026-11-18 04:55:59'),
(7, 7, 11, 'Backend Development', 'PENDING', '2026-11-17 04:55:59'),
(8, 7, 13, 'Fullstack Development', 'ACCEPTED', '2026-11-13 04:55:59'),
(9, 8, 12, 'Data Science', 'PENDING', '2026-11-18 04:55:59'),
(10, 9, 9, 'Mobile Development', 'ACCEPTED', '2026-11-11 04:55:59'),
(11, 10, 9, 'Mobile Development', 'PENDING', '2026-11-18 04:55:59'),
(12, 9, 12, 'Data Science', 'ACCEPTED', '2026-11-12 04:55:59'),
(13, 11, 11, 'Backend Development', 'ACCEPTED', '2026-11-15 04:55:59');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` bigint NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `message` text,
  `is_read` tinyint(1) DEFAULT '0',
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(100) NOT NULL,
  `actor_user_id` int DEFAULT NULL,
  `collaboration_id` int DEFAULT NULL,
  `project_id` int DEFAULT NULL,
  `read_at` datetime(6) DEFAULT NULL,
  `recipient_user_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `id_pengguna`, `message`, `is_read`, `timestamp`, `type`, `actor_user_id`, `collaboration_id`, `project_id`, `read_at`, `recipient_user_id`, `title`, `created_at`) VALUES
(2, 1, 'Julian menerima undangan kolaborasi Anda', 0, '2026-10-19 21:21:32', 'COLLAB_ACCEPTED', NULL, NULL, NULL, NULL, 0, '', NULL),
(3, 3, 'Deadline tugas UI Design kurang dari 24 jam!', 0, '2026-10-19 21:21:32', 'REMINDER', NULL, NULL, NULL, NULL, 0, '', NULL),
(4, 4, 'Permintaan bergabung ke proyek Moneyger ditolak', 0, '2026-10-19 21:21:32', 'COLLAB_REJECTED', NULL, NULL, NULL, NULL, 0, '', NULL),
(5, 5, 'Proyek Company Profile Web telah selesai', 0, '2026-10-19 21:21:32', 'PROJECT_UPDATE', NULL, NULL, NULL, NULL, 0, '', NULL),
(6, NULL, 'Rina Aulia ingin bergabung ke project \"Aplikasi Bank Sampah Digital\".', 0, '2026-11-19 04:59:00', 'COLLABORATION_REQUEST', 10, 6, 7, NULL, 9, 'Permintaan Kolaborasi Baru', '2026-11-18 04:59:00'),
(7, NULL, 'Bagas Saputra ingin bergabung ke project \"Aplikasi Bank Sampah Digital\".', 0, '2026-11-19 04:59:00', 'COLLABORATION_REQUEST', 11, 7, 7, NULL, 9, 'Permintaan Kolaborasi Baru', '2026-11-17 04:59:00'),
(8, NULL, 'Permintaan kamu untuk bergabung ke \"Redesign Website Himpunan\" telah diterima.', 1, '2026-11-19 04:59:00', 'COLLABORATION_ACCEPTED', 10, 10, 9, '2026-11-12 04:59:00.000000', 9, 'Permintaan Diterima', '2026-11-12 04:59:00'),
(9, NULL, 'Dimas Pratama ingin bergabung ke project \"API Marketplace UMKM\".', 0, '2026-11-19 04:59:00', 'COLLABORATION_REQUEST', 9, 11, 10, NULL, 11, 'Permintaan Kolaborasi Baru', '2026-11-18 04:59:00');

-- --------------------------------------------------------

--
-- Table structure for table `portfolio`
--

CREATE TABLE `portfolio` (
  `portfolio_id` int NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `upload_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `portfolio`
--

INSERT INTO `portfolio` (`portfolio_id`, `id_pengguna`, `title`, `description`, `file_url`, `image_url`, `upload_date`, `image`) VALUES
(1, 1, 'Clone Gojek App', 'Membuat UI Clone aplikasi Gojek', 'link/gojek-clone', NULL, '2026-10-19 21:21:32', NULL),
(3, 3, 'Redesign Spotify', 'UI/UX Case Study Spotify', 'link/spotify-ui', NULL, '2026-10-19 21:21:32', NULL),
(4, 4, 'Data Sales Analysis', 'Dashboard Tableau Sales 2025', 'link/tableau-sales', NULL, '2026-10-19 21:21:32', NULL),
(5, 5, 'CI/CD Pipeline Setup', 'Setup Jenkins & Docker', 'link/cicd-docs', NULL, '2026-10-19 21:21:32', NULL),
(6, 9, 'Aplikasi Kasir UMKM', 'Aplikasi kasir offline-first berbasis Flutter.', 'https://github.com/collabin-demo/kasir', NULL, '2026-10-10 04:59:00', 'https://picsum.photos/seed/porto1/800/500'),
(7, 9, 'Hijau Kita', 'Platform aksi lingkungan untuk mendukung program SDGs: info kegiatan, donasi, dan komunitas.', 'https://github.com/collabin-demo/hijau-kita', NULL, '2026-10-30 04:59:00', 'https://picsum.photos/seed/porto2/800/500'),
(8, 9, 'Moneyger', 'Aplikasi pengelola keuangan pribadi dengan pencatatan otomatis dan laporan bulanan.', 'https://github.com/collabin-demo/moneyger', NULL, '2026-11-09 04:59:00', 'https://picsum.photos/seed/porto3/800/500');

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

CREATE TABLE `project` (
  `project_id` int NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
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
(3, 3, 'Sistem Pakar AI', 'Sistem pakar diagnosa penyakit', 'AI/ML', 'ACTIVE', 'github.com/kanaka/sp-ai', NULL, '2027-01-15 00:00:00', '2026-10-19 21:21:32'),
(4, 4, 'E-Commerce API', 'Backend service untuk e-commerce', 'Backend', 'ACTIVE', 'github.com/satria/ecommerce-api', NULL, '2026-11-20 00:00:00', '2026-10-19 21:21:32'),
(5, 5, 'Company Profile Web', 'Website portofolio perusahaan', 'Web', 'COMPLETED', 'github.com/mustofa/compro', NULL, '2026-09-10 00:00:00', '2026-10-19 21:21:32'),
(6, 7, 'gali pasir', 'gali gali pasir', NULL, 'NOT OPEN', '', NULL, '2026-11-28 17:00:00', '2026-11-19 04:50:05'),
(7, 9, 'Aplikasi Bank Sampah Digital', 'Aplikasi mobile untuk mencatat setoran bank sampah warga, konversi poin, dan penukaran saldo. Butuh designer & backend.', NULL, 'OPEN', 'https://github.com/collabin-demo/project-1', 'https://picsum.photos/seed/collabin1/800/500', '2026-12-10 04:55:59', '2026-10-21 04:55:59'),
(8, 9, 'Dashboard Monitoring IoT Kebun', 'Dashboard web untuk memantau sensor kelembapan tanah dan suhu pada kebun hidroponik kampus.', NULL, 'NOT OPEN', 'https://github.com/collabin-demo/project-2', 'https://picsum.photos/seed/collabin2/800/500', '2027-01-03 04:55:59', '2026-10-22 04:55:59'),
(9, 10, 'Redesign Website Himpunan', 'Redesign total website himpunan mahasiswa: riset pengguna, wireframe, hingga prototipe high-fidelity.', NULL, 'OPEN', 'https://github.com/collabin-demo/project-3', 'https://picsum.photos/seed/collabin3/800/500', '2026-12-03 04:55:59', '2026-10-23 04:55:59'),
(10, 11, 'API Marketplace UMKM', 'REST API untuk marketplace UMKM lokal (produk, keranjang, pembayaran). Butuh mobile dev untuk aplikasi kliennya.', NULL, 'OPEN', 'https://github.com/collabin-demo/project-4', 'https://picsum.photos/seed/collabin4/800/500', '2026-12-19 04:55:59', '2026-10-24 04:55:59'),
(11, 12, 'Deteksi Penyakit Daun Padi', 'Model computer vision untuk mendeteksi penyakit daun padi dari foto, lalu di-deploy ke aplikasi mobile.', NULL, 'OPEN', 'https://github.com/collabin-demo/project-5', 'https://picsum.photos/seed/collabin5/800/500', '2027-01-18 04:55:59', '2026-10-25 04:55:59'),
(12, 13, 'Sistem Antrian Klinik', 'Sistem antrian online klinik kampus dengan notifikasi real-time ke pasien.', NULL, 'HOLD', 'https://github.com/collabin-demo/project-6', 'https://picsum.photos/seed/collabin6/800/500', '2026-11-29 04:55:59', '2026-10-26 04:55:59'),
(13, 10, 'Design System Aplikasi Kampus', 'Membangun design system (komponen, warna, tipografi) untuk seluruh aplikasi kampus. Project sudah selesai.', NULL, 'DONE', 'https://github.com/collabin-demo/project-7', 'https://picsum.photos/seed/collabin7/800/500', '2026-11-14 04:55:59', '2026-10-27 04:55:59'),
(14, 11, 'Chatbot Layanan Akademik', 'Chatbot berbasis NLP untuk menjawab pertanyaan seputar layanan akademik. Belum dimulai, sedang mencari anggota tim.', NULL, 'NOT OPEN', 'https://github.com/collabin-demo/project-8', 'https://picsum.photos/seed/collabin8/800/500', '2027-01-08 04:55:59', '2026-10-28 04:55:59');

-- --------------------------------------------------------

--
-- Table structure for table `project_category`
--

CREATE TABLE `project_category` (
  `project_id` int NOT NULL,
  `category` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `project_category`
--

INSERT INTO `project_category` (`project_id`, `category`) VALUES
(6, 'Web Development'),
(7, 'Mobile Development'),
(7, 'UI/UX Design'),
(8, 'Internet of Things (IoT)'),
(8, 'Web Development'),
(9, 'UI/UX Design'),
(9, 'Web Design'),
(10, 'Backend Development'),
(10, 'Mobile Development'),
(11, 'Machine Learning'),
(11, 'Computer Vision'),
(12, 'Fullstack Development'),
(13, 'UI/UX Design'),
(14, 'Artificial Intelligence'),
(14, 'Backend Development');

-- --------------------------------------------------------

--
-- Table structure for table `project_deadline_notification_logs`
--

CREATE TABLE `project_deadline_notification_logs` (
  `deadline_log_id` bigint NOT NULL,
  `deadline_snapshot` datetime(6) NOT NULL,
  `project_id` int NOT NULL,
  `recipient_user_id` int NOT NULL,
  `reminder_type` varchar(50) NOT NULL,
  `sent_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_messages`
--

CREATE TABLE `project_messages` (
  `message_id` bigint NOT NULL,
  `project_id` int NOT NULL,
  `sender_id` int NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `project_messages`
--

INSERT INTO `project_messages` (`message_id`, `project_id`, `sender_id`, `text`, `created_at`) VALUES
(1, 7, 9, 'Halo tim! Selamat bergabung di project Bank Sampah Digital!', '2026-11-14 03:59:00'),
(2, 7, 13, 'Siap kak, aku mulai setup repo backend hari ini ya.', '2026-11-14 04:14:00'),
(3, 7, 9, 'Mantap. Nanti kita sync di daily jam 8 malam.', '2026-11-17 04:29:00'),
(4, 7, 13, 'Endpoint setoran sampah udah bisa dites di staging.', '2026-11-19 04:09:00'),
(5, 9, 10, 'Wireframe halaman beranda sudah aku upload di Figma.', '2026-11-16 04:39:00'),
(6, 9, 9, 'Oke kak, aku mulai slicing ke Flutter besok.', '2026-11-16 04:49:00'),
(7, 9, 12, 'Aku bantu bikin analitik pengunjung ya.', '2026-11-18 04:54:00'),
(8, 11, 12, 'Dataset daun padi sudah dibersihkan, siap training.', '2026-11-18 03:29:00'),
(9, 11, 11, 'Sip, API inferensinya aku siapkan.', '2026-11-19 04:44:00');

-- --------------------------------------------------------

--
-- Table structure for table `project_message_reads`
--

CREATE TABLE `project_message_reads` (
  `read_id` bigint NOT NULL,
  `project_id` int NOT NULL,
  `user_id` int NOT NULL,
  `last_read_message_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_ratings`
--

CREATE TABLE `project_ratings` (
  `rating_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `owner_user_id` int NOT NULL,
  `project_id` int NOT NULL,
  `rated_user_id` int NOT NULL,
  `rating_value` int NOT NULL,
  `review` text,
  `updated_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `project_ratings`
--

INSERT INTO `project_ratings` (`rating_id`, `created_at`, `owner_user_id`, `project_id`, `rated_user_id`, `rating_value`, `review`, `updated_at`) VALUES
(1, '2026-11-17 04:59:00.000000', 10, 9, 9, 5, 'Dimas cepat tanggap dan hasil implementasinya rapi.', NULL),
(2, '2026-11-16 04:59:00.000000', 9, 7, 13, 4, 'Komunikasi bagus, deliver tepat waktu.', NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `rating`
--

INSERT INTO `rating` (`rating_id`, `id_pengguna`, `rated_user_id`, `project_id`, `rating_value`, `review`, `created_at`) VALUES
(3, 5, 1, 5, 5, 'Sangat kooperatif sebagai tim.', '2026-10-19 21:21:32');

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
(3, 3, 1, 3, 'Nathan bisa bantu slicing UI dengan cepat.', '2026-10-19 21:21:32'),
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
  `nama_lengkap` varchar(255) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `profile_picture` varchar(255) DEFAULT NULL,
  `bio` varchar(255) DEFAULT NULL,
  `institusi` varchar(255) DEFAULT NULL,
  `posisi_saat_ini` varchar(100) DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `firebase_uid` varchar(255) DEFAULT NULL,
  `instagram` varchar(255) DEFAULT NULL,
  `keahlian` varchar(255) DEFAULT NULL,
  `linkedin` varchar(255) DEFAULT NULL,
  `lokasi` varchar(255) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `whatsapp` varchar(255) DEFAULT NULL,
  `timezone` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_pengguna`, `nama_lengkap`, `username`, `email`, `password`, `created_at`, `profile_picture`, `bio`, `institusi`, `posisi_saat_ini`, `facebook`, `firebase_uid`, `instagram`, `keahlian`, `linkedin`, `lokasi`, `provider`, `whatsapp`, `timezone`) VALUES
(1, 'Nathaniel Christ', 'nathan_c', 'nathan@email.com', 'demo1234\r\n', '2026-10-19 21:21:32', NULL, 'Frontend Dev', 'Telkom University', 'Mahasiswa', NULL, 'nKCcBOLWRTa1OthjibY9H97vddw1', NULL, NULL, NULL, NULL, 'google', NULL, NULL),
(3, 'Kanaka Pradipta', 'kanaka_p', 'kanaka@email.com', 'demo1234', '2026-10-19 21:21:32', NULL, 'UI/UX Designer', 'Telkom University', 'Mahasiswa', NULL, 'L2eVKUkKT1Nn10K97wvINGYmp512', NULL, NULL, NULL, NULL, 'google', NULL, NULL),
(4, 'Satria Dinata', 'satria_d', 'satria@gmail.com', 'demoaja123', '2026-10-19 21:21:32', NULL, 'Data Scientist', 'Telkom University', 'Mahasiswa', NULL, 'xK3nG7sKQPbuxIwEB6pV9sl0irz2', NULL, NULL, NULL, NULL, 'google', NULL, NULL),
(5, 'Mustofa Fathir', 'mustofa_f', 'mustofa@email.com', 'demo1234', '2026-10-19 21:21:32', NULL, 'DevOps', 'Telkom University', 'Mahasiswa', NULL, 'GjmDDSUU0fbTv8ZSLVOAnlb7QlC2', NULL, NULL, NULL, NULL, 'google', NULL, NULL),
(6, 'Nabil', 'nabil', 'nabil@email.com', 'demo1234', '2026-10-19 21:21:32', NULL, 'Frontend Dev', 'Telkom University', 'Mahasiswa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, 'Julian Wimanjaya', NULL, 'julianwimanjaya4639@gmail.com', '$2a$10$9JC2EgB5dGr/q.fAcwIOoO/JiKOJeQssIHSNn5wuDttgz2vSodyB.', '2026-11-17 21:22:27', 'https://lh3.googleusercontent.com/a/ACg8ocLGA2wnMaSrzGHE4ggzZb4qUwmXj-AEzuZ4xk2qtZgjy6x5jxqT=s96-c', 'yahahaha', 'telkom', NULL, NULL, 'X2vabuRbyOeW2ziOefOZgPUD5Ok2', NULL, NULL, NULL, NULL, 'google', NULL, NULL),
(9, 'Dimas Pratama', NULL, 'dimas@collabin.dev', 'demo1234', '2026-11-19 04:55:59', 'https://ui-avatars.com/api/?name=Dimas%20Pratama&background=random&size=256', 'Mobile developer yang suka membangun produk kolaboratif.', 'Telkom University', NULL, '', 'SvkmXB9RpaPB7RsUGooRQWg0GQB3', 'collabin.demo1', 'Mobile Development,Flutter', 'collabin-demo-1', 'Bandung', 'google', '081234567891', NULL),
(10, 'Rina Aulia', NULL, 'rina@collabin.dev', 'demo1234', '2026-11-19 04:55:59', 'https://ui-avatars.com/api/?name=Rina%20Aulia&background=random&size=256', 'UI/UX designer, fokus di riset pengguna & design system.', 'Telkom University', NULL, '', 'zPRH9iMNAwasG1n8WpnNCQNL76E2', 'collabin.demo2', 'UI/UX Design', 'collabin-demo-2', 'Bandung', 'google', '081234567892', NULL),
(11, 'Bagas Saputra', NULL, 'bagas@collabin.dev', 'demo1234', '2026-11-19 04:55:59', 'https://ui-avatars.com/api/?name=Bagas%20Saputra&background=random&size=256', 'Backend engineer (Java Spring & Go).', 'Institut Teknologi Bandung', NULL, '', NULL, 'collabin.demo3', 'Backend Development', 'collabin-demo-3', 'Jakarta', 'seed', '081234567893', NULL),
(12, 'Salsa Nabila', NULL, 'salsa@collabin.dev', 'demo1234', '2026-11-19 04:55:59', 'https://ui-avatars.com/api/?name=Salsa%20Nabila&background=random&size=256', 'Data scientist, tertarik di NLP & computer vision.', 'Universitas Indonesia', NULL, '', NULL, 'collabin.demo4', 'Data Science,Machine Learning', 'collabin-demo-4', 'Depok', 'seed', '081234567894', NULL),
(13, 'Fajar Hidayat', NULL, 'fajar@collabin.dev', 'demo1234', '2026-11-19 04:55:59', 'https://ui-avatars.com/api/?name=Fajar%20Hidayat&background=random&size=256', 'Fullstack developer, suka ngoprek DevOps.', 'Universitas Gadjah Mada', NULL, '', NULL, 'collabin.demo5', 'Fullstack Development,DevOps', 'collabin-demo-5', 'Yogyakarta', 'seed', '081234567895', NULL),
(15, 'udin', NULL, 'tesombak@email.com', '$2a$10$c79RxasAO9z88eiNOLc1EunD/0Z274f3RpAmPjc5SvGUetIBTpkaC', '2026-11-19 06:03:11', NULL, NULL, NULL, NULL, NULL, '5wrza2vfb9QxMTiO1YF42feEAyY2', NULL, NULL, NULL, NULL, 'google', NULL, NULL);

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
-- Indexes for table `project_category`
--
ALTER TABLE `project_category`
  ADD KEY `FKbnvmdi87q78pcs6n81apdokn9` (`project_id`);

--
-- Indexes for table `project_deadline_notification_logs`
--
ALTER TABLE `project_deadline_notification_logs`
  ADD PRIMARY KEY (`deadline_log_id`);

--
-- Indexes for table `project_messages`
--
ALTER TABLE `project_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_project_messages_project` (`project_id`,`message_id`),
  ADD KEY `fk_project_messages_sender` (`sender_id`);

--
-- Indexes for table `project_message_reads`
--
ALTER TABLE `project_message_reads`
  ADD PRIMARY KEY (`read_id`),
  ADD UNIQUE KEY `uk_project_message_reads_project_user` (`project_id`,`user_id`),
  ADD KEY `fk_project_message_reads_user` (`user_id`);

--
-- Indexes for table `project_ratings`
--
ALTER TABLE `project_ratings`
  ADD PRIMARY KEY (`rating_id`);

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
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `UK4yiq7pdiwjw8inhg1xy83nabx` (`firebase_uid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `activity_log_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `calendar`
--
ALTER TABLE `calendar`
  MODIFY `event_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `collaboration`
--
ALTER TABLE `collaboration`
  MODIFY `collaboration_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `portfolio`
--
ALTER TABLE `portfolio`
  MODIFY `portfolio_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `project`
--
ALTER TABLE `project`
  MODIFY `project_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `project_deadline_notification_logs`
--
ALTER TABLE `project_deadline_notification_logs`
  MODIFY `deadline_log_id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_messages`
--
ALTER TABLE `project_messages`
  MODIFY `message_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `project_message_reads`
--
ALTER TABLE `project_message_reads`
  MODIFY `read_id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_ratings`
--
ALTER TABLE `project_ratings`
  MODIFY `rating_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `rating`
--
ALTER TABLE `rating`
  MODIFY `rating_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  MODIFY `id_pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

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
-- Constraints for table `project_category`
--
ALTER TABLE `project_category`
  ADD CONSTRAINT `FKbnvmdi87q78pcs6n81apdokn9` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`);

--
-- Constraints for table `project_messages`
--
ALTER TABLE `project_messages`
  ADD CONSTRAINT `fk_project_messages_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_project_messages_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE;

--
-- Constraints for table `project_message_reads`
--
ALTER TABLE `project_message_reads`
  ADD CONSTRAINT `fk_project_message_reads_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_project_message_reads_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id_pengguna`) ON DELETE CASCADE;

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

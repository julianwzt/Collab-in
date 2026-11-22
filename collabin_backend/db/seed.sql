-- =============================================================================
--  Collab-in — data awal (seed) setara data dummy di aplikasi Flutter lama
--
--  * Idempotent: tiap baris dicek dulu (WHERE NOT EXISTS), jadi aman dijalankan
--    berulang kali tanpa membuat duplikat dan tanpa menimpa data yang sudah diubah.
--  * Tidak bergantung pada nilai AUTO_INCREMENT (relasi dicari lewat email/judul),
--    jadi aman dijalankan juga di database yang sudah berisi data pengguna asli.
--  * Tidak ada DELETE / TRUNCATE / DROP.
--  * Tanggal dibuat relatif terhadap NOW() seperti pada data dummy.
--
--  Jalankan SETELAH tabel ada (db/schema.sql atau setelah backend pernah start
--  dengan ddl-auto=update):   mysql -u <user> -p <nama_db> < db/seed.sql
--
--  Akun seed memakai email @collabin.dev dan TANPA password (login email/password
--  ditolak). Untuk memakai salah satu akun seed dengan akun Google kamu:
--    UPDATE users SET email = 'akungoogle@gmail.com' WHERE email = 'dimas@collabin.dev';
--  Saat login Google pertama kali, backend menautkan firebase_uid ke baris itu.
-- =============================================================================

SET NAMES utf8mb4;

-- ── Pengguna ─────────────────────────────────────────────────────────────
INSERT INTO users (nama_lengkap, email, provider, profile_picture, institusi, bio, keahlian, lokasi, whatsapp, instagram, facebook, linkedin)
SELECT 'Dimas Pratama', 'dimas@collabin.dev', 'seed', 'https://ui-avatars.com/api/?name=Dimas%20Pratama&background=random&size=256', 'Telkom University', 'Mobile developer yang suka membangun produk kolaboratif.', 'Mobile Development,Flutter', 'Bandung', '081234567891', 'collabin.demo1', '', 'collabin-demo-1'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM users WHERE LOWER(email) = 'dimas@collabin.dev');
INSERT INTO users (nama_lengkap, email, provider, profile_picture, institusi, bio, keahlian, lokasi, whatsapp, instagram, facebook, linkedin)
SELECT 'Rina Aulia', 'rina@collabin.dev', 'seed', 'https://ui-avatars.com/api/?name=Rina%20Aulia&background=random&size=256', 'Telkom University', 'UI/UX designer, fokus di riset pengguna & design system.', 'UI/UX Design', 'Bandung', '081234567892', 'collabin.demo2', '', 'collabin-demo-2'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM users WHERE LOWER(email) = 'rina@collabin.dev');
INSERT INTO users (nama_lengkap, email, provider, profile_picture, institusi, bio, keahlian, lokasi, whatsapp, instagram, facebook, linkedin)
SELECT 'Bagas Saputra', 'bagas@collabin.dev', 'seed', 'https://ui-avatars.com/api/?name=Bagas%20Saputra&background=random&size=256', 'Institut Teknologi Bandung', 'Backend engineer (Java Spring & Go).', 'Backend Development', 'Jakarta', '081234567893', 'collabin.demo3', '', 'collabin-demo-3'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM users WHERE LOWER(email) = 'bagas@collabin.dev');
INSERT INTO users (nama_lengkap, email, provider, profile_picture, institusi, bio, keahlian, lokasi, whatsapp, instagram, facebook, linkedin)
SELECT 'Salsa Nabila', 'salsa@collabin.dev', 'seed', 'https://ui-avatars.com/api/?name=Salsa%20Nabila&background=random&size=256', 'Universitas Indonesia', 'Data scientist, tertarik di NLP & computer vision.', 'Data Science,Machine Learning', 'Depok', '081234567894', 'collabin.demo4', '', 'collabin-demo-4'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM users WHERE LOWER(email) = 'salsa@collabin.dev');
INSERT INTO users (nama_lengkap, email, provider, profile_picture, institusi, bio, keahlian, lokasi, whatsapp, instagram, facebook, linkedin)
SELECT 'Fajar Hidayat', 'fajar@collabin.dev', 'seed', 'https://ui-avatars.com/api/?name=Fajar%20Hidayat&background=random&size=256', 'Universitas Gadjah Mada', 'Fullstack developer, suka ngoprek DevOps.', 'Fullstack Development,DevOps', 'Yogyakarta', '081234567895', 'collabin.demo5', '', 'collabin-demo-5'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM users WHERE LOWER(email) = 'fajar@collabin.dev');
SET @u1 = (SELECT id_pengguna FROM users WHERE LOWER(email) = 'dimas@collabin.dev' LIMIT 1);
SET @u2 = (SELECT id_pengguna FROM users WHERE LOWER(email) = 'rina@collabin.dev' LIMIT 1);
SET @u3 = (SELECT id_pengguna FROM users WHERE LOWER(email) = 'bagas@collabin.dev' LIMIT 1);
SET @u4 = (SELECT id_pengguna FROM users WHERE LOWER(email) = 'salsa@collabin.dev' LIMIT 1);
SET @u5 = (SELECT id_pengguna FROM users WHERE LOWER(email) = 'fajar@collabin.dev' LIMIT 1);

-- ── Project ──────────────────────────────────────────────────────────────
INSERT INTO project (id_pengguna, title, description, status, repository_link, file_url, created_at, deadline)
SELECT @u1, 'Aplikasi Bank Sampah Digital', 'Aplikasi mobile untuk mencatat setoran bank sampah warga, konversi poin, dan penukaran saldo. Butuh designer & backend.', 'OPEN', 'https://github.com/collabin-demo/project-1', 'https://picsum.photos/seed/collabin1/800/500', NOW() - INTERVAL 29 DAY, NOW() + INTERVAL 21 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE id_pengguna = @u1 AND title = 'Aplikasi Bank Sampah Digital');
INSERT INTO project (id_pengguna, title, description, status, repository_link, file_url, created_at, deadline)
SELECT @u1, 'Dashboard Monitoring IoT Kebun', 'Dashboard web untuk memantau sensor kelembapan tanah dan suhu pada kebun hidroponik kampus.', 'NOT OPEN', 'https://github.com/collabin-demo/project-2', 'https://picsum.photos/seed/collabin2/800/500', NOW() - INTERVAL 28 DAY, NOW() + INTERVAL 45 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE id_pengguna = @u1 AND title = 'Dashboard Monitoring IoT Kebun');
INSERT INTO project (id_pengguna, title, description, status, repository_link, file_url, created_at, deadline)
SELECT @u2, 'Redesign Website Himpunan', 'Redesign total website himpunan mahasiswa: riset pengguna, wireframe, hingga prototipe high-fidelity.', 'OPEN', 'https://github.com/collabin-demo/project-3', 'https://picsum.photos/seed/collabin3/800/500', NOW() - INTERVAL 27 DAY, NOW() + INTERVAL 14 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE id_pengguna = @u2 AND title = 'Redesign Website Himpunan');
INSERT INTO project (id_pengguna, title, description, status, repository_link, file_url, created_at, deadline)
SELECT @u3, 'API Marketplace UMKM', 'REST API untuk marketplace UMKM lokal (produk, keranjang, pembayaran). Butuh mobile dev untuk aplikasi kliennya.', 'OPEN', 'https://github.com/collabin-demo/project-4', 'https://picsum.photos/seed/collabin4/800/500', NOW() - INTERVAL 26 DAY, NOW() + INTERVAL 30 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE id_pengguna = @u3 AND title = 'API Marketplace UMKM');
INSERT INTO project (id_pengguna, title, description, status, repository_link, file_url, created_at, deadline)
SELECT @u4, 'Deteksi Penyakit Daun Padi', 'Model computer vision untuk mendeteksi penyakit daun padi dari foto, lalu di-deploy ke aplikasi mobile.', 'OPEN', 'https://github.com/collabin-demo/project-5', 'https://picsum.photos/seed/collabin5/800/500', NOW() - INTERVAL 25 DAY, NOW() + INTERVAL 60 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE id_pengguna = @u4 AND title = 'Deteksi Penyakit Daun Padi');
INSERT INTO project (id_pengguna, title, description, status, repository_link, file_url, created_at, deadline)
SELECT @u5, 'Sistem Antrian Klinik', 'Sistem antrian online klinik kampus dengan notifikasi real-time ke pasien.', 'HOLD', 'https://github.com/collabin-demo/project-6', 'https://picsum.photos/seed/collabin6/800/500', NOW() - INTERVAL 24 DAY, NOW() + INTERVAL 10 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE id_pengguna = @u5 AND title = 'Sistem Antrian Klinik');
INSERT INTO project (id_pengguna, title, description, status, repository_link, file_url, created_at, deadline)
SELECT @u2, 'Design System Aplikasi Kampus', 'Membangun design system (komponen, warna, tipografi) untuk seluruh aplikasi kampus. Project sudah selesai.', 'DONE', 'https://github.com/collabin-demo/project-7', 'https://picsum.photos/seed/collabin7/800/500', NOW() - INTERVAL 23 DAY, NOW() - INTERVAL 5 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE id_pengguna = @u2 AND title = 'Design System Aplikasi Kampus');
INSERT INTO project (id_pengguna, title, description, status, repository_link, file_url, created_at, deadline)
SELECT @u3, 'Chatbot Layanan Akademik', 'Chatbot berbasis NLP untuk menjawab pertanyaan seputar layanan akademik. Belum dimulai, sedang mencari anggota tim.', 'NOT OPEN', 'https://github.com/collabin-demo/project-8', 'https://picsum.photos/seed/collabin8/800/500', NOW() - INTERVAL 22 DAY, NOW() + INTERVAL 50 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE id_pengguna = @u3 AND title = 'Chatbot Layanan Akademik');
SET @p1 = (SELECT project_id FROM project WHERE id_pengguna = @u1 AND title = 'Aplikasi Bank Sampah Digital' LIMIT 1);
SET @p2 = (SELECT project_id FROM project WHERE id_pengguna = @u1 AND title = 'Dashboard Monitoring IoT Kebun' LIMIT 1);
SET @p3 = (SELECT project_id FROM project WHERE id_pengguna = @u2 AND title = 'Redesign Website Himpunan' LIMIT 1);
SET @p4 = (SELECT project_id FROM project WHERE id_pengguna = @u3 AND title = 'API Marketplace UMKM' LIMIT 1);
SET @p5 = (SELECT project_id FROM project WHERE id_pengguna = @u4 AND title = 'Deteksi Penyakit Daun Padi' LIMIT 1);
SET @p6 = (SELECT project_id FROM project WHERE id_pengguna = @u5 AND title = 'Sistem Antrian Klinik' LIMIT 1);
SET @p7 = (SELECT project_id FROM project WHERE id_pengguna = @u2 AND title = 'Design System Aplikasi Kampus' LIMIT 1);
SET @p8 = (SELECT project_id FROM project WHERE id_pengguna = @u3 AND title = 'Chatbot Layanan Akademik' LIMIT 1);

-- Kategori project
INSERT INTO project_category (project_id, category)
SELECT @p1, 'Mobile Development' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p1 AND category = 'Mobile Development');
INSERT INTO project_category (project_id, category)
SELECT @p1, 'UI/UX Design' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p1 AND category = 'UI/UX Design');
INSERT INTO project_category (project_id, category)
SELECT @p2, 'Internet of Things (IoT)' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p2 AND category = 'Internet of Things (IoT)');
INSERT INTO project_category (project_id, category)
SELECT @p2, 'Web Development' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p2 AND category = 'Web Development');
INSERT INTO project_category (project_id, category)
SELECT @p3, 'UI/UX Design' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p3 AND category = 'UI/UX Design');
INSERT INTO project_category (project_id, category)
SELECT @p3, 'Web Design' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p3 AND category = 'Web Design');
INSERT INTO project_category (project_id, category)
SELECT @p4, 'Backend Development' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p4 AND category = 'Backend Development');
INSERT INTO project_category (project_id, category)
SELECT @p4, 'Mobile Development' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p4 AND category = 'Mobile Development');
INSERT INTO project_category (project_id, category)
SELECT @p5, 'Machine Learning' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p5 AND category = 'Machine Learning');
INSERT INTO project_category (project_id, category)
SELECT @p5, 'Computer Vision' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p5 AND category = 'Computer Vision');
INSERT INTO project_category (project_id, category)
SELECT @p6, 'Fullstack Development' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p6 AND category = 'Fullstack Development');
INSERT INTO project_category (project_id, category)
SELECT @p7, 'UI/UX Design' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p7 AND category = 'UI/UX Design');
INSERT INTO project_category (project_id, category)
SELECT @p8, 'Artificial Intelligence' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p8 AND category = 'Artificial Intelligence');
INSERT INTO project_category (project_id, category)
SELECT @p8, 'Backend Development' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_category WHERE project_id = @p8 AND category = 'Backend Development');

-- ── Kolaborasi ───────────────────────────────────────────────────────────
INSERT INTO collaboration (project_id, id_pengguna, role, status, join_date)
SELECT @p1, @u2, 'UI/UX Design', 'PENDING', NOW() - INTERVAL 1 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM collaboration WHERE project_id = @p1 AND id_pengguna = @u2);
INSERT INTO collaboration (project_id, id_pengguna, role, status, join_date)
SELECT @p1, @u3, 'Backend Development', 'PENDING', NOW() - INTERVAL 2 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM collaboration WHERE project_id = @p1 AND id_pengguna = @u3);
INSERT INTO collaboration (project_id, id_pengguna, role, status, join_date)
SELECT @p1, @u5, 'Fullstack Development', 'ACCEPTED', NOW() - INTERVAL 6 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM collaboration WHERE project_id = @p1 AND id_pengguna = @u5);
INSERT INTO collaboration (project_id, id_pengguna, role, status, join_date)
SELECT @p2, @u4, 'Data Science', 'PENDING', NOW() - INTERVAL 1 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM collaboration WHERE project_id = @p2 AND id_pengguna = @u4);
INSERT INTO collaboration (project_id, id_pengguna, role, status, join_date)
SELECT @p3, @u1, 'Mobile Development', 'ACCEPTED', NOW() - INTERVAL 8 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM collaboration WHERE project_id = @p3 AND id_pengguna = @u1);
INSERT INTO collaboration (project_id, id_pengguna, role, status, join_date)
SELECT @p4, @u1, 'Mobile Development', 'PENDING', NOW() - INTERVAL 1 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM collaboration WHERE project_id = @p4 AND id_pengguna = @u1);
INSERT INTO collaboration (project_id, id_pengguna, role, status, join_date)
SELECT @p3, @u4, 'Data Science', 'ACCEPTED', NOW() - INTERVAL 7 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM collaboration WHERE project_id = @p3 AND id_pengguna = @u4);
INSERT INTO collaboration (project_id, id_pengguna, role, status, join_date)
SELECT @p5, @u3, 'Backend Development', 'ACCEPTED', NOW() - INTERVAL 4 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM collaboration WHERE project_id = @p5 AND id_pengguna = @u3);

-- ── Notifikasi ───────────────────────────────────────────────────────────
INSERT INTO notifications (recipient_user_id, actor_user_id, project_id, collaboration_id, type, title, message, is_read, created_at, read_at)
SELECT @u1, @u2, @p1, (SELECT collaboration_id FROM collaboration WHERE project_id = @p1 AND id_pengguna = @u2 LIMIT 1), 'COLLABORATION_REQUEST', 'Permintaan Kolaborasi Baru', 'Rina Aulia ingin bergabung ke project "Aplikasi Bank Sampah Digital".', 0, NOW() - INTERVAL 1 DAY, NULL
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM notifications WHERE recipient_user_id = @u1 AND actor_user_id = @u2 AND project_id = @p1 AND type = 'COLLABORATION_REQUEST' AND message = 'Rina Aulia ingin bergabung ke project "Aplikasi Bank Sampah Digital".');
INSERT INTO notifications (recipient_user_id, actor_user_id, project_id, collaboration_id, type, title, message, is_read, created_at, read_at)
SELECT @u1, @u3, @p1, (SELECT collaboration_id FROM collaboration WHERE project_id = @p1 AND id_pengguna = @u3 LIMIT 1), 'COLLABORATION_REQUEST', 'Permintaan Kolaborasi Baru', 'Bagas Saputra ingin bergabung ke project "Aplikasi Bank Sampah Digital".', 0, NOW() - INTERVAL 2 DAY, NULL
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM notifications WHERE recipient_user_id = @u1 AND actor_user_id = @u3 AND project_id = @p1 AND type = 'COLLABORATION_REQUEST' AND message = 'Bagas Saputra ingin bergabung ke project "Aplikasi Bank Sampah Digital".');
INSERT INTO notifications (recipient_user_id, actor_user_id, project_id, collaboration_id, type, title, message, is_read, created_at, read_at)
SELECT @u1, @u2, @p3, (SELECT collaboration_id FROM collaboration WHERE project_id = @p3 AND id_pengguna = @u1 LIMIT 1), 'COLLABORATION_ACCEPTED', 'Permintaan Diterima', 'Permintaan kamu untuk bergabung ke "Redesign Website Himpunan" telah diterima.', 1, NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 7 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM notifications WHERE recipient_user_id = @u1 AND actor_user_id = @u2 AND project_id = @p3 AND type = 'COLLABORATION_ACCEPTED' AND message = 'Permintaan kamu untuk bergabung ke "Redesign Website Himpunan" telah diterima.');
INSERT INTO notifications (recipient_user_id, actor_user_id, project_id, collaboration_id, type, title, message, is_read, created_at, read_at)
SELECT @u3, @u1, @p4, (SELECT collaboration_id FROM collaboration WHERE project_id = @p4 AND id_pengguna = @u1 LIMIT 1), 'COLLABORATION_REQUEST', 'Permintaan Kolaborasi Baru', 'Dimas Pratama ingin bergabung ke project "API Marketplace UMKM".', 0, NOW() - INTERVAL 1 DAY, NULL
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM notifications WHERE recipient_user_id = @u3 AND actor_user_id = @u1 AND project_id = @p4 AND type = 'COLLABORATION_REQUEST' AND message = 'Dimas Pratama ingin bergabung ke project "API Marketplace UMKM".');

-- ── Activity log ─────────────────────────────────────────────────────────
INSERT INTO activity_log (id_pengguna, project_id, message, is_read, timestamp)
SELECT @u1, @p1, 'Created project: Aplikasi Bank Sampah Digital', 0, NOW() - INTERVAL 12 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM activity_log WHERE id_pengguna = @u1 AND project_id = @p1 AND message = 'Created project: Aplikasi Bank Sampah Digital');
INSERT INTO activity_log (id_pengguna, project_id, message, is_read, timestamp)
SELECT @u1, @p2, 'Created project: Dashboard Monitoring IoT Kebun', 0, NOW() - INTERVAL 9 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM activity_log WHERE id_pengguna = @u1 AND project_id = @p2 AND message = 'Created project: Dashboard Monitoring IoT Kebun');
INSERT INTO activity_log (id_pengguna, project_id, message, is_read, timestamp)
SELECT @u1, @p3, 'Requested collaboration: Mobile Development', 0, NOW() - INTERVAL 8 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM activity_log WHERE id_pengguna = @u1 AND project_id = @p3 AND message = 'Requested collaboration: Mobile Development');
INSERT INTO activity_log (id_pengguna, project_id, message, is_read, timestamp)
SELECT @u1, @p1, 'ACCEPT collaboration on project: Aplikasi Bank Sampah Digital', 0, NOW() - INTERVAL 6 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM activity_log WHERE id_pengguna = @u1 AND project_id = @p1 AND message = 'ACCEPT collaboration on project: Aplikasi Bank Sampah Digital');
INSERT INTO activity_log (id_pengguna, project_id, message, is_read, timestamp)
SELECT @u1, @p1, 'Updated project: Aplikasi Bank Sampah Digital', 0, NOW() - INTERVAL 3 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM activity_log WHERE id_pengguna = @u1 AND project_id = @p1 AND message = 'Updated project: Aplikasi Bank Sampah Digital');
INSERT INTO activity_log (id_pengguna, project_id, message, is_read, timestamp)
SELECT @u1, @p4, 'Requested collaboration: Mobile Development', 0, NOW() - INTERVAL 1 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM activity_log WHERE id_pengguna = @u1 AND project_id = @p4 AND message = 'Requested collaboration: Mobile Development');
INSERT INTO activity_log (id_pengguna, project_id, message, is_read, timestamp)
SELECT @u2, @p3, 'Created project: Redesign Website Himpunan', 0, NOW() - INTERVAL 10 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM activity_log WHERE id_pengguna = @u2 AND project_id = @p3 AND message = 'Created project: Redesign Website Himpunan');
INSERT INTO activity_log (id_pengguna, project_id, message, is_read, timestamp)
SELECT @u3, @p4, 'Created project: API Marketplace UMKM', 0, NOW() - INTERVAL 11 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM activity_log WHERE id_pengguna = @u3 AND project_id = @p4 AND message = 'Created project: API Marketplace UMKM');

-- ── Rating & review ──────────────────────────────────────────────────────
INSERT INTO project_ratings (project_id, rated_user_id, owner_user_id, rating_value, review, created_at, updated_at)
SELECT @p3, @u1, @u2, 5, 'Dimas cepat tanggap dan hasil implementasinya rapi.', NOW() - INTERVAL 2 DAY, NULL
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_ratings WHERE project_id = @p3 AND rated_user_id = @u1 AND owner_user_id = @u2);
INSERT INTO project_ratings (project_id, rated_user_id, owner_user_id, rating_value, review, created_at, updated_at)
SELECT @p1, @u5, @u1, 4, 'Komunikasi bagus, deliver tepat waktu.', NOW() - INTERVAL 3 DAY, NULL
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_ratings WHERE project_id = @p1 AND rated_user_id = @u5 AND owner_user_id = @u1);

-- ── Portfolio (milik Dimas) ──────────────────────────────────────────────
INSERT INTO portfolio (id_pengguna, title, description, file_url, image, upload_date)
SELECT @u1, 'Aplikasi Kasir UMKM', 'Aplikasi kasir offline-first berbasis Flutter.', 'https://github.com/collabin-demo/kasir', 'https://picsum.photos/seed/porto1/800/500', NOW() - INTERVAL 40 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM portfolio WHERE id_pengguna = @u1 AND title = 'Aplikasi Kasir UMKM');
INSERT INTO portfolio (id_pengguna, title, description, file_url, image, upload_date)
SELECT @u1, 'Hijau Kita', 'Platform aksi lingkungan untuk mendukung program SDGs: info kegiatan, donasi, dan komunitas.', 'https://github.com/collabin-demo/hijau-kita', 'https://picsum.photos/seed/porto2/800/500', NOW() - INTERVAL 20 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM portfolio WHERE id_pengguna = @u1 AND title = 'Hijau Kita');
INSERT INTO portfolio (id_pengguna, title, description, file_url, image, upload_date)
SELECT @u1, 'Moneyger', 'Aplikasi pengelola keuangan pribadi dengan pencatatan otomatis dan laporan bulanan.', 'https://github.com/collabin-demo/moneyger', 'https://picsum.photos/seed/porto3/800/500', NOW() - INTERVAL 10 DAY
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM portfolio WHERE id_pengguna = @u1 AND title = 'Moneyger');

-- ── Chat project (Messages) ──────────────────────────────────────────────
INSERT INTO project_messages (project_id, sender_id, text, created_at)
SELECT @p1, @u1, 'Halo tim! Selamat bergabung di project Bank Sampah Digital!', NOW() - INTERVAL 7260 MINUTE
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_messages WHERE project_id = @p1 AND sender_id = @u1 AND text = 'Halo tim! Selamat bergabung di project Bank Sampah Digital!');
INSERT INTO project_messages (project_id, sender_id, text, created_at)
SELECT @p1, @u5, 'Siap kak, aku mulai setup repo backend hari ini ya.', NOW() - INTERVAL 7245 MINUTE
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_messages WHERE project_id = @p1 AND sender_id = @u5 AND text = 'Siap kak, aku mulai setup repo backend hari ini ya.');
INSERT INTO project_messages (project_id, sender_id, text, created_at)
SELECT @p1, @u1, 'Mantap. Nanti kita sync di daily jam 8 malam.', NOW() - INTERVAL 2910 MINUTE
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_messages WHERE project_id = @p1 AND sender_id = @u1 AND text = 'Mantap. Nanti kita sync di daily jam 8 malam.');
INSERT INTO project_messages (project_id, sender_id, text, created_at)
SELECT @p1, @u5, 'Endpoint setoran sampah udah bisa dites di staging.', NOW() - INTERVAL 50 MINUTE
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_messages WHERE project_id = @p1 AND sender_id = @u5 AND text = 'Endpoint setoran sampah udah bisa dites di staging.');
INSERT INTO project_messages (project_id, sender_id, text, created_at)
SELECT @p3, @u2, 'Wireframe halaman beranda sudah aku upload di Figma.', NOW() - INTERVAL 4340 MINUTE
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_messages WHERE project_id = @p3 AND sender_id = @u2 AND text = 'Wireframe halaman beranda sudah aku upload di Figma.');
INSERT INTO project_messages (project_id, sender_id, text, created_at)
SELECT @p3, @u1, 'Oke kak, aku mulai slicing ke Flutter besok.', NOW() - INTERVAL 4330 MINUTE
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_messages WHERE project_id = @p3 AND sender_id = @u1 AND text = 'Oke kak, aku mulai slicing ke Flutter besok.');
INSERT INTO project_messages (project_id, sender_id, text, created_at)
SELECT @p3, @u4, 'Aku bantu bikin analitik pengunjung ya.', NOW() - INTERVAL 1445 MINUTE
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_messages WHERE project_id = @p3 AND sender_id = @u4 AND text = 'Aku bantu bikin analitik pengunjung ya.');
INSERT INTO project_messages (project_id, sender_id, text, created_at)
SELECT @p5, @u4, 'Dataset daun padi sudah dibersihkan, siap training.', NOW() - INTERVAL 1530 MINUTE
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_messages WHERE project_id = @p5 AND sender_id = @u4 AND text = 'Dataset daun padi sudah dibersihkan, siap training.');
INSERT INTO project_messages (project_id, sender_id, text, created_at)
SELECT @p5, @u3, 'Sip, API inferensinya aku siapkan.', NOW() - INTERVAL 15 MINUTE
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project_messages WHERE project_id = @p5 AND sender_id = @u3 AND text = 'Sip, API inferensinya aku siapkan.');

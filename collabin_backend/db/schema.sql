-- =============================================================================
--  Collab-in — skema MySQL (selaras dengan JPA entity di src/main/java)
--
--  Untuk DATABASE BARU/KOSONG. Aman dijalankan berulang (CREATE TABLE IF NOT EXISTS),
--  tapi TIDAK mengubah tabel lama: kalau tabel sudah ada dari database.sql versi lama
--  (kolom berbeda), skrip ini melewatinya. Untuk database lama, pakai
--  spring.jpa.hibernate.ddl-auto=update (lihat application.properties.example).
--
--  Dijalankan lewat:  mysql -u <user> -p <nama_db> < db/schema.sql
--  Tidak ada DROP / TRUNCATE di file ini.
-- =============================================================================

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS users (
  id_pengguna     INT          NOT NULL AUTO_INCREMENT,
  nama_lengkap    VARCHAR(255) NOT NULL,
  email           VARCHAR(255) NOT NULL,
  password        VARCHAR(255) NULL,
  firebase_uid    VARCHAR(255) NULL,
  provider        VARCHAR(255) NULL,
  profile_picture VARCHAR(255) NULL,
  institusi       VARCHAR(255) NULL,
  bio             TEXT         NULL,
  keahlian        VARCHAR(255) NULL,
  lokasi          VARCHAR(255) NULL,
  whatsapp        VARCHAR(255) NULL,
  instagram       VARCHAR(255) NULL,
  facebook        VARCHAR(255) NULL,
  linkedin        VARCHAR(255) NULL,
  timezone        VARCHAR(255) NULL,
  PRIMARY KEY (id_pengguna),
  UNIQUE KEY uk_users_email (email),
  UNIQUE KEY uk_users_firebase_uid (firebase_uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS project (
  project_id      INT          NOT NULL AUTO_INCREMENT,
  id_pengguna     INT          NULL,
  title           VARCHAR(255) NOT NULL,
  description     TEXT         NULL,
  status          VARCHAR(255) NULL,
  repository_link VARCHAR(255) NULL,
  file_url        VARCHAR(255) NULL,
  created_at      DATETIME     NULL,
  deadline        DATETIME     NULL,
  PRIMARY KEY (project_id),
  KEY idx_project_owner (id_pengguna),
  CONSTRAINT fk_project_owner FOREIGN KEY (id_pengguna) REFERENCES users (id_pengguna) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS project_category (
  project_id INT          NOT NULL,
  category   VARCHAR(255) NULL,
  KEY idx_project_category_project (project_id),
  CONSTRAINT fk_project_category_project FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS collaboration (
  collaboration_id INT          NOT NULL AUTO_INCREMENT,
  project_id       INT          NOT NULL,
  id_pengguna      INT          NOT NULL,
  role             VARCHAR(255) NOT NULL,
  status           VARCHAR(255) NOT NULL,
  join_date        DATETIME     NOT NULL,
  PRIMARY KEY (collaboration_id),
  KEY idx_collaboration_project (project_id),
  KEY idx_collaboration_user (id_pengguna),
  CONSTRAINT fk_collaboration_project FOREIGN KEY (project_id)  REFERENCES project (project_id)  ON DELETE CASCADE,
  CONSTRAINT fk_collaboration_user    FOREIGN KEY (id_pengguna) REFERENCES users (id_pengguna) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS notifications (
  notification_id   BIGINT       NOT NULL AUTO_INCREMENT,
  recipient_user_id INT          NOT NULL,
  actor_user_id     INT          NULL,
  project_id        INT          NULL,
  collaboration_id  INT          NULL,
  type              VARCHAR(100) NOT NULL,
  title             VARCHAR(255) NOT NULL,
  message           TEXT         NOT NULL,
  is_read           TINYINT(1)   NOT NULL DEFAULT 0,
  created_at        DATETIME     NOT NULL,
  read_at           DATETIME     NULL,
  PRIMARY KEY (notification_id),
  KEY idx_notifications_recipient (recipient_user_id),
  CONSTRAINT fk_notifications_recipient FOREIGN KEY (recipient_user_id) REFERENCES users (id_pengguna) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS project_deadline_notification_logs (
  deadline_log_id    BIGINT      NOT NULL AUTO_INCREMENT,
  project_id         INT         NOT NULL,
  recipient_user_id  INT         NOT NULL,
  reminder_type      VARCHAR(50) NOT NULL,
  deadline_snapshot  DATETIME    NOT NULL,
  sent_at            DATETIME    NOT NULL,
  PRIMARY KEY (deadline_log_id),
  KEY idx_deadline_logs_project (project_id, recipient_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS activity_log (
  activity_log_id INT          NOT NULL AUTO_INCREMENT,
  id_pengguna     INT          NOT NULL,
  project_id      INT          NOT NULL,
  message         VARCHAR(255) NOT NULL,
  is_read         TINYINT(1)   NOT NULL DEFAULT 0,
  timestamp       DATETIME     NOT NULL,
  PRIMARY KEY (activity_log_id),
  KEY idx_activity_log_user (id_pengguna),
  KEY idx_activity_log_project (project_id),
  CONSTRAINT fk_activity_log_user    FOREIGN KEY (id_pengguna) REFERENCES users (id_pengguna) ON DELETE CASCADE,
  CONSTRAINT fk_activity_log_project FOREIGN KEY (project_id)  REFERENCES project (project_id)  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS project_ratings (
  rating_id      BIGINT   NOT NULL AUTO_INCREMENT,
  project_id     INT      NOT NULL,
  rated_user_id  INT      NOT NULL,
  owner_user_id  INT      NOT NULL,
  rating_value   INT      NOT NULL,
  review         TEXT     NULL,
  created_at     DATETIME NOT NULL,
  updated_at     DATETIME NULL,
  PRIMARY KEY (rating_id),
  KEY idx_project_ratings_project (project_id),
  KEY idx_project_ratings_rated (rated_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS portfolio (
  portfolio_id INT          NOT NULL AUTO_INCREMENT,
  id_pengguna  INT          NOT NULL,
  title        VARCHAR(255) NOT NULL,
  description  TEXT         NULL,
  file_url     VARCHAR(255) NULL,
  image        VARCHAR(255) NULL,
  upload_date  DATETIME     NULL,
  PRIMARY KEY (portfolio_id),
  KEY idx_portfolio_user (id_pengguna),
  CONSTRAINT fk_portfolio_user FOREIGN KEY (id_pengguna) REFERENCES users (id_pengguna) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS calendar (
  event_id    INT        NOT NULL AUTO_INCREMENT,
  project_id  INT        NULL,
  id_pengguna INT        NULL,
  is_done     TINYINT(1) NULL,
  PRIMARY KEY (event_id),
  KEY idx_calendar_project_user (project_id, id_pengguna)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Chat grup per project (fitur Messages)
CREATE TABLE IF NOT EXISTS project_messages (
  message_id  BIGINT   NOT NULL AUTO_INCREMENT,
  project_id  INT      NOT NULL,
  sender_id   INT      NOT NULL,
  text        TEXT     NOT NULL,
  created_at  DATETIME NOT NULL,
  PRIMARY KEY (message_id),
  KEY idx_project_messages_project (project_id, message_id),
  CONSTRAINT fk_project_messages_project FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE,
  CONSTRAINT fk_project_messages_sender  FOREIGN KEY (sender_id)  REFERENCES users (id_pengguna)  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS project_message_reads (
  read_id              BIGINT NOT NULL AUTO_INCREMENT,
  project_id           INT    NOT NULL,
  user_id              INT    NOT NULL,
  last_read_message_id BIGINT NOT NULL,
  PRIMARY KEY (read_id),
  UNIQUE KEY uk_project_message_reads_project_user (project_id, user_id),
  CONSTRAINT fk_project_message_reads_project FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE,
  CONSTRAINT fk_project_message_reads_user    FOREIGN KEY (user_id)    REFERENCES users (id_pengguna)  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

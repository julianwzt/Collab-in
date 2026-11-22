# Collab-in

Aplikasi kolaborasi project mahasiswa.

```
Flutter (collabin_frontend)  ──REST/JSON──▶  Spring Boot (collabin_backend)  ──JPA──▶  MySQL
        │                                              ▲
        └── Firebase Auth (Google / email) ── ID token ┘  diverifikasi Firebase Admin SDK
```

Frontend tidak pernah terhubung langsung ke MySQL. Semua data aplikasi berasal dari
backend. Mode data dummy (`DummyBackend`, `DemoAccountSwitcher`, `kUseDummyData`)
**sudah dihapus** dari frontend.

## 1. MySQL

Butuh MySQL 8 (atau MariaDB 10.5+).

```bash
mysql -u root -p -e "CREATE DATABASE collabin CHARACTER SET utf8mb4;"

# Database BARU: buat tabel, lalu isi data awal
mysql -u root -p collabin < collabin_backend/db/schema.sql
mysql -u root -p collabin < collabin_backend/db/seed.sql     # opsional, aman diulang
```

* `db/schema.sql` — `CREATE TABLE IF NOT EXISTS`, selaras dengan JPA entity. Tidak ada DROP/TRUNCATE.
* `db/seed.sql` — data awal setara data dummy lama (5 pengguna, 8 project, kolaborasi,
  notifikasi, activity log, rating, portfolio, chat). Idempotent: tiap baris dicek dulu,
  jadi tidak membuat duplikat dan tidak menimpa data yang sudah kamu ubah.
* `database.sql` (lama) adalah dump versi lama dan **tidak lagi selaras** dengan entity
  (mis. `users` tanpa `firebase_uid`, tabel `rating` vs `project_ratings`). Jangan dipakai
  untuk database baru.
* **Database lama** yang sudah dibuat dari `database.sql`: biarkan
  `spring.jpa.hibernate.ddl-auto=update` agar Hibernate menambah kolom/tabel yang kurang
  (tidak menghapus apa pun). Backup dulu sebelum menjalankan.
* Akun seed memakai email `@collabin.dev` dan tanpa password. Untuk mencoba data seed
  dengan akun Google kamu sendiri:
  `UPDATE users SET email='akunmu@gmail.com' WHERE email='dimas@collabin.dev';`
  Saat login Google pertama, backend menautkan `firebase_uid` ke baris itu.

## 2. Backend (Spring Boot, Java 17+)

```bash
cd collabin_backend
cp src/main/resources/application.properties.example src/main/resources/application.properties
cp .env.example .env        # isi nilai asli, lalu:
set -a; . ./.env; set +a
./mvnw spring-boot:run      # default port 8082
```

Environment variable:

| Variable | Fungsi |
|---|---|
| `DB_URL`, `DB_USERNAME`, `DB_PASSWORD` | koneksi MySQL |
| `FIREBASE_SERVICE_ACCOUNT_PATH` | path file service-account JSON (di luar repo) |
| `APP_AUTH_TOKEN_SECRET` | **wajib**, string acak ≥ 32 karakter (token login internal). Backend menolak start jika kosong |
| `APP_BASE_URL` | URL publik backend untuk URL gambar upload |
| `CORS_ALLOWED_ORIGINS` | origin Flutter Web, dipisah koma |
| `JPA_DDL_AUTO` | `update` (default) atau `none` bila skema dikelola lewat `db/schema.sql` |

Firebase: unduh service-account di Firebase Console → Project settings → Service accounts,
simpan **di luar repository**, arahkan lewat `FIREBASE_SERVICE_ACCOUNT_PATH`.

## 3. Frontend (Flutter)

Alamat backend diatur lewat `--dart-define=API_BASE_URL`:

```bash
cd collabin_frontend
flutter pub get
flutter run                                                        # emulator Android: otomatis 10.0.2.2:8082
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8082    # HP fisik (IP laptop di Wi-Fi yang sama)
flutter run -d chrome                                              # Web: otomatis http://localhost:8082
flutter build apk --dart-define=API_BASE_URL=https://api.contoh.com
```

iOS simulator memakai `http://127.0.0.1:8082`. HP fisik **wajib** memakai `API_BASE_URL`.

Ikon aplikasi: `dart run flutter_launcher_icons` (sumber: `assets/image/png/collabin_icon.png`).

## 4. Alur autentikasi

1. Pengguna login (Google atau email/password) lewat Firebase Authentication di Flutter.
2. Flutter mengirim Firebase ID token: `Authorization: Bearer <token>`.
3. Backend memverifikasi token dengan Firebase Admin SDK (signature, issuer, audience, expiry; pencabutan token tidak dicek per request demi performa).
4. Backend mencari pengguna di MySQL lewat `firebase_uid` (lalu email). Jika belum ada,
   baris `users` dibuat otomatis; jika ada, dipakai ulang. Identitas selalu diambil dari
   token, bukan dari body request.

## 5. API

Semua endpoint di bawah `/api/v1`, respons `{ "status", "message", "data" }`.

| Method | Path | Fitur |
|---|---|---|
| POST | `/users/register`, `/users/login`, `/users/login/google` | akun |
| GET | `/users/{id}` · `/profile` | profil |
| PATCH | `/update/users/current` | ubah profil (JSON/multipart) |
| DELETE | `/delete/users/current` | hapus akun |
| POST | `/create/projects` | buat project |
| GET | `/projects` · `/users/projects` · `/projects/{id}/view` | daftar/detail project |
| PATCH | `/projects/{id}` | ubah project (multipart) |
| DELETE | `/delete/projects` | hapus project (soft delete) |
| POST | `/collaboration/request/{projectId}` | minta bergabung |
| GET | `/collaboration/{id}` · `/collaboration/dashboard` · `/collaboration/project/{id}/pending` · `/collaboration/detail/project/{id}/` | lihat kolaborasi |
| POST | `/collaboration/action` | ACCEPT / DECLINE |
| GET | `/search` | cari project & pengguna |
| GET | `/portfolio` · `/portfolio/{userId}` | portfolio |
| POST/PUT/DELETE | `/create/portfolio` · `/edit/portfolio/{id}` · `/delete/portfolio` | kelola portfolio |
| POST | `/ratings` | beri rating |
| GET | `/ratings/users/{id}` · `/ratings/users/{id}/average` · `/ratings/projects/{id}` | rating |
| GET | `/notifications` · `/notifications/unread` | notifikasi |
| PATCH | `/notifications/{id}/read` · `/notifications/read-all` | tandai dibaca |
| GET | `/calendar` · `/calendar/filter` | kalender (deadline project) |
| PATCH | `/calendar/done` | tandai selesai |
| GET | `/activity-logs` · `/activity-logs/recap` | activity log & recap |
| GET | `/messages/conversations` | daftar chat project **(baru)** |
| GET/POST | `/messages/project/{projectId}` | riwayat / kirim pesan **(baru)** |

Chat hanya bisa dibaca/ditulis oleh pemilik project dan kolaborator berstatus ACCEPTED.

## 6. Test

```bash
cd collabin_backend && ./mvnw clean test
cd collabin_frontend && flutter pub get && flutter analyze && flutter test
```

## 7. Keamanan

* Service-account Firebase **jangan** di-commit. `.gitignore` sudah menolak
  `src/main/resources/*firebase-adminsdk*.json`. Jika file itu pernah ter-commit,
  jalankan `git rm --cached` dan **rotasi key** di Firebase Console (key lama dianggap bocor).
* Jangan memakai `ddl-auto=create` / `create-drop` (menghapus data).

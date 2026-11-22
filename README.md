# Collab-in

Aplikasi kolaborasi project mahasiswa.

```
Flutter (collabin_frontend)  ──REST/JSON──▶  Spring Boot (collabin_backend)  ──JPA──▶  MySQL
        │                                              ▲
        └── Firebase Auth (Google / email) ── ID token ┘  diverifikasi Firebase Admin SDK
```

Frontend tidak pernah terhubung langsung ke MySQL. Semua data aplikasi berasal dari
backend.

## Backend (Spring Boot, Java 17+)

```bash
cd collabin_backend
cp src/main/resources/application.properties.example src/main/resources/application.properties
cp .env.example .env        # isi nilai asli, lalu:
set -a; . ./.env; set +a
./mvnw spring-boot:run      # default port 8082
```

## Frontend (Flutter)

```bash
cd collabin_frontend
flutter pub get
flutter run                                                        # emulator Android: otomatis 10.0.2.2:8082
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8082    # HP fisik (IP laptop di Wi-Fi yang sama)
flutter run -d chrome                                              # Web: otomatis http://localhost:8082
flutter build apk --dart-define=API_BASE_URL=https://api.contoh.com
```

iOS simulator memakai `http://127.0.0.1:8082`. HP fisik **wajib** memakai `API_BASE_URL`.

## Alur autentikasi

1. Pengguna login (Google atau email/password) lewat Firebase Authentication di Flutter.
2. Flutter mengirim Firebase ID token: `Authorization: Bearer <token>`.
3. Backend memverifikasi token dengan Firebase Admin SDK (signature, issuer, audience, expiry; pencabutan token tidak dicek per request demi performa).
4. Backend mencari pengguna di MySQL lewat `firebase_uid` (lalu email). Jika belum ada,
   baris `users` dibuat otomatis; jika ada, dipakai ulang. Identitas selalu diambil dari
   token, bukan dari body request.

## Test

```bash
cd collabin_backend && ./mvnw clean test
cd collabin_frontend && flutter pub get && flutter analyze && flutter test
```

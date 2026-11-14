class ApiConfig {
  ApiConfig._();

  // Backend lokal (XAMPP). 10.0.2.2 = localhost laptop dilihat dari emulator Android.
  // Kalau pakai HP fisik, ganti dengan IP laptop di Wi-Fi yang sama (mis. http://192.168.1.5:8080).
  // Server lama GabungYuk: http://103.247.11.178:8080
  static const String baseUrl = 'http://10.0.2.2:8080';
}

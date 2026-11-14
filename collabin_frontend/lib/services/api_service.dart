import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 for Android Emulator, or localhost for Web/Desktop
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  static Future<http.Response> register(String name, String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'namaLengkap': name, 'email': email, 'password': password}),
    );
  }

  static Future<http.Response> createProject(Map<String, dynamic> projectData) async {
    return await http.post(
      Uri.parse('$baseUrl/projects/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(projectData),
    );
  }

  static Future<http.Response> getProjects() async {
    return await http.get(Uri.parse('$baseUrl/projects'));
  }
}

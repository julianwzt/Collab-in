import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  void _doLogin() async {
    setState(() => _isLoading = true);
    final res = await ApiService.login(_emailCtrl.text, _passCtrl.text);
    setState(() => _isLoading = false);

    if (res.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/marketplace');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Gagal: ${res.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collab-in - Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _doLogin,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Masuk'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Belum punya akun? Daftar'),
            )
          ],
        ),
      ),
    );
  }
}

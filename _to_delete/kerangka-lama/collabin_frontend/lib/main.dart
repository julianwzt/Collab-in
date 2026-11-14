import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/marketplace_page.dart';
import 'views/create_project_page.dart';

void main() {
  runApp(const CollabInApp());
}

class CollabInApp extends StatelessWidget {
  const CollabInApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collab-in Mobile',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/marketplace': (context) => const MarketplacePage(),
        '/create-project': (context) => const CreateProjectPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

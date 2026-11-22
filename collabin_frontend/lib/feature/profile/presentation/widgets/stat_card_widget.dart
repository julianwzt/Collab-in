import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // Pindahkan dekorasi Shadow ke Container luar agar tidak terpotong
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent, // Supaya warna Container tetap terlihat
          child: InkWell(
            onTap: onTap, // Aksi klik
            borderRadius: BorderRadius.circular(
              12,
            ), // Harus sama dengan Container
            splashColor: const Color(0xFFF7941D).withOpacity(
              0.1,
            ), // Warna efek saat ditekan
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: const Color(0xFFE07F0E), size: 30),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:collabin/core/common/color_value.dart';

/// Logo Collab-in (redesign): heksagon kuning berbentuk "C" yang tersusun
/// dari 3 bagian. Digambar sebagai vektor agar tajam di semua ukuran.
class CollabinLogo extends StatelessWidget {
  const CollabinLogo({super.key, this.size = 96, this.showText = false, this.textSize});

  /// Tinggi ikon.
  final double size;

  /// Tampilkan tulisan "Collab-in" di bawah ikon.
  final bool showText;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    final icon = SizedBox(
      width: size * _CollabinLogoPainter.aspect,
      height: size,
      child: const CustomPaint(painter: _CollabinLogoPainter()),
    );
    if (!showText) return icon;

    final fs = textSize ?? size * 0.42;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(height: size * 0.18),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fs,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
              letterSpacing: -0.3,
              height: 1,
            ),
            children: const [
              TextSpan(text: 'Collab'),
              TextSpan(text: '-', style: TextStyle(color: ColorValue.logoYellow)),
              TextSpan(text: 'in'),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollabinLogoPainter extends CustomPainter {
  const _CollabinLogoPainter();

  // Koordinat dalam kanvas 284 x 340 (diukur dari logo asli).
  static const double _w = 284, _h = 340;
  static const double aspect = _w / _h;
  static const double _ox = 58, _oy = 48;

  static const _top = [
    Offset(128, 98), Offset(200, 58), Offset(332, 133),
    Offset(332, 178), Offset(240, 178), Offset(132, 116),
  ];
  static const _left = [
    Offset(68, 152), Offset(102, 126), Offset(140, 150),
    Offset(140, 286), Offset(102, 310), Offset(68, 284),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.height / _h;
    final paint = Paint()
      ..color = ColorValue.logoYellow
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final stroke = Paint()
      ..color = ColorValue.logoYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18 * s
      ..strokeJoin = StrokeJoin.round;

    final bottom = _top.map((o) => Offset(o.dx, 436 - o.dy)).toList();
    for (final pts in [_top, bottom, _left]) {
      final path = Path()..moveTo((pts.first.dx - _ox) * s, (pts.first.dy - _oy) * s);
      for (final p in pts.skip(1)) {
        path.lineTo((p.dx - _ox) * s, (p.dy - _oy) * s);
      }
      path.close();
      canvas.drawPath(path, paint);
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

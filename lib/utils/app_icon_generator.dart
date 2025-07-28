import 'package:flutter/material.dart';

class AppIconGenerator {
  static Widget generateAppIcon({double size = 1024}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A1A1A),
            Color(0xFF0A0A0A),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _IconBackgroundPainter(),
            ),
          ),
          
          // Main Q logo
          Center(
            child: Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFACF500),
                    Color(0xFF8BC34A),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFACF500).withOpacity(0.5),
                    blurRadius: size * 0.1,
                    spreadRadius: size * 0.02,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Q',
                  style: TextStyle(
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0A0A0A),
                  ),
                ),
              ),
            ),
          ),
          
          // Decorative rings
          Center(
            child: Container(
              width: size * 0.8,
              height: size * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFACF500).withOpacity(0.3),
                  width: size * 0.01,
                ),
              ),
            ),
          ),
          
          Center(
            child: Container(
              width: size * 0.9,
              height: size * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFACF500).withOpacity(0.2),
                  width: size * 0.005,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFACF500).withOpacity(0.1)
      ..strokeWidth = 2;

    // Draw diagonal lines
    for (int i = 0; i < size.width + size.height; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(0, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 
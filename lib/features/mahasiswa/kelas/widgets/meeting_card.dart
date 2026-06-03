// Widget Komponen Kartu Pertemuan
import 'package:flutter/material.dart';

class MeetingCard extends StatelessWidget {
  final String status;
  final String date;
  final String title;
  final String time;
  final bool isStarted;

  const MeetingCard({
    super.key,
    required this.status,
    required this.date,
    required this.title,
    required this.time,
    required this.isStarted,
  });

  @override
  Widget build(BuildContext context) {
    // Pengaturan warna berdasarkan status badge
    Color badgeBgColor;
    Color badgeTextColor;

    switch (status) {
      case 'HADIR':
        badgeBgColor = const Color(0xFFE6F4EA);
        badgeTextColor = const Color(0xFF137333);
        break;
      case 'ALPA':
        badgeBgColor = const Color(0xFFFCE8E6);
        badgeTextColor = const Color(0xFFC5221F);
        break;
      case 'IZIN':
        badgeBgColor = const Color(0xFFFEF7E0);
        badgeTextColor = const Color(0xFFB06000);
        break;
      default: // BELUM DIMULAI
        badgeBgColor = const Color(0xFFE8EAED);
        badgeTextColor = const Color(0xFF5F6368);
    }

    Widget cardContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Status Badge & Tanggal
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                date,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      isStarted
                          ? const Color(0xFF667085)
                          : const Color(0xFF98A2B3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Judul Pertemuan
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  isStarted ? const Color(0xFF1D2939) : const Color(0xFF98A2B3),
            ),
          ),
          const SizedBox(height: 12),
          // Jam Pelaksanaan
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color:
                    isStarted
                        ? const Color(0xFF667085)
                        : const Color(0xFF98A2B3),
              ),
              const SizedBox(width: 6),
              Text(
                time,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      isStarted
                          ? const Color(0xFF667085)
                          : const Color(0xFF98A2B3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Jika belum dimulai, gunakan efek bingkai putus-putus (Dashed Border)
    if (!isStarted) {
      return CustomPaint(
        painter: DashedRectPainter(color: const Color(0xFFD0D5DD), radius: 14),
        child: cardContent,
      );
    }

    // Jika sudah selesai, gunakan Container putih solid standar dengan bayangan tipis
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: cardContent,
    );
  }
}

// Custom Painter untuk membuat border putus-putus halaman kelas mendatang
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.gap = 4.0,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);

    // Menggambar garis putus-putus secara manual pada path kurva
    final Path dashPath = Path();
    double distance = 0.0;
    for (var metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

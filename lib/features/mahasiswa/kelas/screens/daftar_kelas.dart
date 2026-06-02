import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detail Kelas Akademik',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2575FC)),
        useMaterial3: true,
      ),
      home: const DetailKelasScreen(),
    );
  }
}

class DetailKelasScreen extends StatefulWidget {
  const DetailKelasScreen({super.key});

  @override
  State<DetailKelasScreen> createState() => _DetailKelasScreenState();
}

class _DetailKelasScreenState extends State<DetailKelasScreen> {
  int _bottomNavIndex = 1; // Default aktif di menu 'Kelas'

  // Data Dummy sesuai dengan gambar yang diunggah
  final List<Map<String, dynamic>> pertemuanList = [
    {
      'status': 'HADIR',
      'date': '12 Feb 2024',
      'title': 'Pertemuan 1: Limit & Kontinuitas',
      'time': '08:00 - 10:00',
      'isStarted': true,
    },
    {
      'status': 'HADIR',
      'date': '19 Feb 2024',
      'title': 'Pertemuan 2: Turunan Fungsi',
      'time': '08:00 - 10:00',
      'isStarted': true,
    },
    {
      'status': 'ALPA',
      'date': '26 Feb 2024',
      'title': 'Pertemuan 3: Aplikasi Turunan',
      'time': '08:00 - 10:00',
      'isStarted': true,
    },
    {
      'status': 'IZIN',
      'date': '04 Mar 2024',
      'title': 'Pertemuan 4: Integral Tak Tentu',
      'time': '08:00 - 10:00',
      'isStarted': true,
    },
    {
      'status': 'BELUM DIMULAI',
      'date': '11 Mar 2024',
      'title': 'Pertemuan 5: Integral Tentu',
      'time': '08:00 - 10:00',
      'isStarted': false,
    },
    {
      'status': 'BELUM DIMULAI',
      'date': '18 Mar 2024',
      'title': 'Pertemuan 6: Teknik Integrasi Lanjut',
      'time': '08:00 - 10:00',
      'isStarted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D2939)),
          onPressed: () {},
        ),
        title: Row(
          children: [
            // Icon Berwarna Biru di samping Judul
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.class_outlined,
                color: Color(0xFF2575FC),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Judul & Subtitle Matakuliah
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Kalkulus II',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                  ),
                ),
                Text(
                  'IF1234 • TEKNIK INFORMATIKA',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF98A2B3),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE4E7EC), height: 1.0),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pertemuanList.length + 1, // +1 untuk footer text
        itemBuilder: (context, index) {
          if (index == pertemuanList.length) {
            // Footer text paling bawah
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'Pertemuan 7 - 16 akan segera tersedia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF98A2B3),
                  fontSize: 14,
                ),
              ),
            );
          }

          final item = pertemuanList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: MeetingCard(
              status: item['status'],
              date: item['date'],
              title: item['title'],
              time: item['time'],
              isStarted: item['isStarted'],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE4E7EC), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2575FC),
          unselectedItemColor: const Color(0xFF98A2B3),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Kelas'),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

// Widget Komponen Kartu Pertemuan
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

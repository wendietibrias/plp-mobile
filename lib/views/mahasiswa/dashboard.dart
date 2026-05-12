import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Dashboard Siswa',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2575FC)),
        fontFamily: 'Poppins', // Pastikan font ini terdaftar di pubspec.yaml
        useMaterial3: true,
      ),
      home: const StudentDashboard(),
    );
  }
}

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/men/32.jpg',
                        ), // Ganti dengan aset lokal
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Halo, Ahmad!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D2939),
                            ),
                          ),
                          Text(
                            'Siswa Kelas 12-A',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF667085),
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Kartu Kehadiran
              const AttendanceCard(),
              const SizedBox(height: 30),

              // Bagian Kelas Selanjutnya
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kelas Selanjutnya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2939),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Semua Jadwal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2575FC),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const ClassCard(),
              const SizedBox(height: 30),

              // Bagian Statistik Cepat
              const Text(
                'Statistik Cepat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2939),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: const [
                  Expanded(
                    child: StatCard(
                      icon: Icons.check_circle_rounded,
                      iconColor: Color(0xFF2E7D32),
                      status: 'HADIR',
                      count: '24',
                      subtitle: 'Sesi selesai',
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: StatCard(
                      icon: Icons.error_rounded,
                      iconColor: Color(0xFFD32F2F),
                      status: 'TERLAMBAT',
                      count: '2',
                      subtitle: 'Sesi bulan ini',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Memberi ruang untuk BottomBar
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF2575FC),
        shape: const CircleBorder(),
        elevation: 8,
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Bagian kiri BottomAppBar
              Row(
                children: [
                  buildBottomNavItem(Icons.home_rounded, 'Beranda', 0),
                  buildBottomNavItem(Icons.calendar_today_rounded, 'Jadwal', 1),
                ],
              ),
              // Bagian kanan BottomAppBar
              Row(
                children: [
                  buildBottomNavItem(Icons.history_rounded, 'Riwayat', 2),
                  buildBottomNavItem(Icons.person_outline_rounded, 'Profil', 3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return MaterialButton(
      minWidth: 70,
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color:
                isSelected ? const Color(0xFF2575FC) : const Color(0xFF98A2B3),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color:
                  isSelected
                      ? const Color(0xFF2575FC)
                      : const Color(0xFF98A2B3),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Kustom untuk Kartu Kehadiran
class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2575FC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2575FC).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'TOTAL KEHADIRAN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '92%',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          'Bulan ini',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.check_circle,
                color: Colors.blueAccent.shade100.withOpacity(0.7),
                size: 60,
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: 0.92,
            backgroundColor: Colors.white.withOpacity(0.2),
            color: Colors.white,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 10),
          // Gradient Line at the bottom
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white24, Colors.white, Colors.white24],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Kustom untuk Kartu Kelas Selanjutnya
class ClassCard extends StatelessWidget {
  const ClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFF667085),
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Ruang Laboratorium 302',
                      style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fisika Dasar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(
                      Icons.access_time_filled_rounded,
                      color: Color(0xFF667085),
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '13:00 - 14:40',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1D2939),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2575FC).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Lihat Detail',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2575FC),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://via.placeholder.com/130x130.png?text=Aset+Lab',
                ), // Ganti dengan aset lokal
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Kustom untuk Kartu Statistik
class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String status;
  final String count;
  final String subtitle;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.status,
    required this.count,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D2939),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }
}

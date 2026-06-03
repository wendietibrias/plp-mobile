import 'package:flutter/material.dart';

// Halaman
import '../../beranda/screens/mahasiswa_beranda_screen.dart';
import '../../kelas/screens/daftar_kelas_screen.dart';
import '../../riwayat/screens/riwayat_screen.dart';
import '../../profil/screens/profil_screen.dart';

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
      home: const MahasiswaDashboardScreen(),
    );
  }
}

class MahasiswaDashboardScreen extends StatefulWidget {
  const MahasiswaDashboardScreen({super.key});

  @override
  State<MahasiswaDashboardScreen> createState() =>
      _MahasiswaDashboardScreenState();
}

class _MahasiswaDashboardScreenState extends State<MahasiswaDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _halamanTab = [
    const MahasiswaBerandaScreen(),
    const DaftarKelasScreen(),
    const RiwayatScreen(),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _halamanTab),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/mahasiswa/scan-qr'),
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

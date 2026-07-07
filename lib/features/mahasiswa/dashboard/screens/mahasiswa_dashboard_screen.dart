import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/providers/auth_provider.dart';
import '../../beranda/screens/mahasiswa_beranda_screen.dart';
import '../../kelas/providers/kelas_provider.dart';
import '../../kelas/screens/daftar_kelas_screen.dart';
import '../../profil/screens/profil_screen.dart';
import '../../riwayat/providers/riwayat_provider.dart';
import '../../riwayat/screens/riwayat_screen.dart';

class MahasiswaDashboardScreen extends StatefulWidget {
  const MahasiswaDashboardScreen({super.key});

  @override
  State<MahasiswaDashboardScreen> createState() =>
      _MahasiswaDashboardScreenState();
}

class _MahasiswaDashboardScreenState extends State<MahasiswaDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _halamanTab = const [
    MahasiswaBerandaScreen(),
    DaftarKelasScreen(),
    RiwayatScreen(),
    ProfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Muat data awal sekali setelah frame pertama (butuh context provider).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final student = context.read<AuthProvider>().student;
      context.read<KelasProvider>().fetchJadwal(student?.classId);
      context.read<RiwayatProvider>().fetch();
    });
  }

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
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  buildBottomNavItem(Icons.home_rounded, 'Beranda', 0),
                  buildBottomNavItem(Icons.calendar_today_rounded, 'Jadwal', 1),
                ],
              ),
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
    final bool isSelected = _currentIndex == index;
    return MaterialButton(
      minWidth: 70,
      onPressed: () => setState(() => _currentIndex = index),
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
              color: isSelected
                  ? const Color(0xFF2575FC)
                  : const Color(0xFF98A2B3),
            ),
          ),
        ],
      ),
    );
  }
}

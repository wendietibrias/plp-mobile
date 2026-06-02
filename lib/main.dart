import 'package:flutter/material.dart';
import 'package:uts_flutter/features/mahasiswa/dashboard/screens/mahasiswa_dashboard_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/mahasiswa/kelas/screens/detail_kelas_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Akademik App',

      // 1. Mengatur Tema Global Aplikasi agar konsisten di semua halaman
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2575FC)),
        fontFamily: 'Poppins', // Font global untuk seluruh teks aplikasi
        useMaterial3: true,
      ),

      // 2. Menentukan halaman pertama yang akan muncul saat aplikasi dibuka
      home: const LoginScreen(),

      // 3. (Opsional) Mendaftarkan Named Routes untuk mempermudah navigasi antar screen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/mahasiswa/dashboard': (context) => const MahasiswaDashboardScreen(),
        '/mahasiswa/detail-kelas': (context) => const DetailKelasScreen(),
        // '/dosen/dashboard': (context) => const DosenDashboardScreen(), // Jika nanti ditambahkan
      },
    );
  }
}

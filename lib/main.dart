import 'package:flutter/material.dart';
import 'package:uts_flutter/features/auth/screens/login.dart';
import 'package:uts_flutter/features/mahasiswa/kelas/screens/daftar_kelas.dart';
import 'package:uts_flutter/features/mahasiswa/dashaboard/screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dokterian',
      theme: ThemeData(useMaterial3: true),
      // home: const LoginScreen(),
      home: const DetailKelasScreen(),
    );
  }
}

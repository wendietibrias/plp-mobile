import 'package:flutter/material.dart';
import 'package:uts_flutter/views/login.dart';
import 'package:uts_flutter/views/mahasiswa/daftar_kelas.dart';
import 'package:uts_flutter/views/mahasiswa/dashboard.dart';

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

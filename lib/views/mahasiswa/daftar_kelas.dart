import 'package:flutter/material.dart';

class DaftarKelas extends StatelessWidget {
  const DaftarKelas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kelas')),
      body: const SingleChildScrollView(child: Text('Daftar Kelas Mahasiswa')),
    );
  }
}

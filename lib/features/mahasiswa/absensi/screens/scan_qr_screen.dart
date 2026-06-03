import 'package:flutter/material.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Kamera Simulator / Placeholder Area Kamera
          Container(
            color: Colors.black87,
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white24,
                size: 80,
              ),
            ),
          ),

          // 2. Lapisan Pembidik Masking (Overlay)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
              child: Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF2575FC),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),

          // 3. Tombol Atas & Instruksi teks
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1D2939),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const Spacer(),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Posisikan QR Code Dosen di dalam kotak untuk melakukan presensi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // 4. Tombol Simulasi Berhasil Scan (Hapus jika sudah pakai API asli)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pindah ke screen sukses presensi
                      Navigator.pushNamed(
                        context,
                        '/mahasiswa/sukses-presensi',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2575FC),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Simulasi Berhasil Scan'),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

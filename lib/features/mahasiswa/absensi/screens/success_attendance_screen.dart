import 'package:flutter/material.dart';

class SuccessAttendanceScreen extends StatelessWidget {
  const SuccessAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Bagian Atas: Peta & Icon Sukses Besar
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://maps.googleapis.com/maps/api/staticmap?center=-6.200000,106.816666&zoom=15&size=600x400&key=',
                      ), // Ganti peta statis Anda
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(color: Colors.black.withOpacity(0.15)),
                ),
                // Efek lingkaran sukses menumpuk di atas peta
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF2E7D32),
                    child: Icon(Icons.check, color: Colors.white, size: 50),
                  ),
                ),
              ],
            ),

            // 2. Konten Informasi Kehadiran
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Text(
                    'Presensi Berhasil!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2939),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Anda tercatat hadir tepat waktu',
                    style: TextStyle(color: Color(0xFF667085), fontSize: 14),
                  ),
                  const SizedBox(height: 25),

                  // Info Jam & Tanggal Masuk
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE4E7EC)),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          '08:05 WIB',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2575FC),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Senin, 24 Mei 2026',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF667085),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Detail Informasi Mahasiswa & Kelas
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE4E7EC)),
                    ),
                    child: Column(
                      children: [
                        buildDetailRow('Nama Siswa', 'Ahmad Ridwan'),
                        const Divider(height: 24),
                        buildDetailRow('Mata Kuliah', 'Kalkulus II'),
                        const Divider(height: 24),
                        buildDetailRow('Ruangan', 'Lab Komputer 302'),
                        const Divider(height: 24),
                        buildDetailRow('Status Radius', 'Di Dalam Area (5m)'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Button Kembali ke Beranda
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        // Kembali ke halaman dashboard utama
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/mahasiswa/dashboard',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2575FC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Kembali ke Beranda',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1D2939),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

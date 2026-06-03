import 'package:flutter/material.dart';

// Widget
import '../../beranda/widgets/attendance_card.dart';
import '../../beranda/widgets/class_card.dart';
import '../../beranda/widgets/stat_card.dart';

class MahasiswaBerandaScreen extends StatelessWidget {
  const MahasiswaBerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  onPressed:
                      () => Navigator.pushNamed(context, '/mahasiswa/kelas'),
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
    );
  }
}

import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Riwayat Kehadiran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D2939),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. KARTU RINGKASAN TOTAL KEHADIRAN (ATAS)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF0F5FF,
                  ), // Biru sangat muda sesuai desain
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD1E9FF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Kehadiran',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF344054),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2575FC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '92%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.92,
                      backgroundColor: const Color(0xFFE4E7EC),
                      color: const Color(0xFF2575FC),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '24 / 26',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2575FC),
                          ),
                        ),
                        Text(
                          'Semester Ganjil 2023/2024',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF98A2B3),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sesi pertemuan selesai',
                      style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. SEARCH BAR (Cari mata pelajaran...)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari mata pelajaran...',
                    hintStyle: TextStyle(
                      color: Color(0xFF98A2B3),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF98A2B3)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. FILTER BUTTONS (Semua, Bulan Ini, Semester 1)
              Row(
                children: [
                  buildFilterChip('Semua', isSelected: true),
                  const SizedBox(width: 8),
                  buildFilterChip('Bulan Ini', hasDropdown: true),
                  const SizedBox(width: 8),
                  buildFilterChip('Semester 1', hasDropdown: true),
                ],
              ),
              const SizedBox(height: 24),

              // 4. KELOMPOK MINGGU INI
              const Text(
                'MINGGU INI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF98A2B3),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              buildRiwayatCard(
                icon: Icons.check_circle_rounded,
                iconBgColor: const Color(0xFFE6F4EA),
                iconColor: const Color(0xFF137333),
                title: 'Matematika Diskrit',
                subtitle: 'Senin, 14 Okt • 08:00 - 10:30',
                statusLabel: 'HADIR',
                statusTime: '07:55 AM',
                statusColor: const Color(0xFF137333),
                statusBgColor: const Color(0xFFE6F4EA),
              ),
              buildRiwayatCard(
                icon: Icons.access_time_filled_rounded,
                iconBgColor: const Color(0xFFFEF3EB),
                iconColor: const Color(0xFFD97706),
                title: 'Pemrograman Web',
                subtitle: 'Selasa, 15 Okt • 13:00 - 15:30',
                statusLabel: 'TERLAMBAT',
                statusTime: '13:15 PM',
                statusColor: const Color(0xFFD97706),
                statusBgColor: const Color(0xFFFEF3EB),
              ),
              const SizedBox(height: 16),

              // 5. KELOMPOK MINGGU LALU
              const Text(
                'MINGGU LALU',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF98A2B3),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              buildRiwayatCard(
                icon: Icons.description_rounded,
                iconBgColor: const Color(0xFFEFF4FF),
                iconColor: const Color(0xFF2575FC),
                title: 'Struktur Data',
                subtitle: 'Kamis, 10 Okt • 09:00 - 11:30',
                statusLabel: 'IZIN',
                statusTime: 'Sakit',
                statusColor: const Color(0xFF2575FC),
                statusBgColor: const Color(0xFFEFF4FF),
              ),
              buildRiwayatCard(
                icon: Icons.cancel_rounded,
                iconBgColor: const Color(0xFFFEE4E2),
                iconColor: const Color(0xFFD92D20),
                title: 'Bahasa Inggris',
                subtitle: 'Jumat, 11 Okt • 10:00 - 12:00',
                statusLabel: 'ALPA',
                statusTime: '-',
                statusColor: const Color(0xFFD92D20),
                statusBgColor: const Color(0xFFFEE4E2),
              ),
              buildRiwayatCard(
                icon: Icons.check_circle_rounded,
                iconBgColor: const Color(0xFFE6F4EA),
                iconColor: const Color(0xFF137333),
                title: 'Sistem Operasi',
                subtitle: 'Rabu, 09 Okt • 08:00 - 10:30',
                statusLabel: 'HADIR',
                statusTime: '07:48 AM',
                statusColor: const Color(0xFF137333),
                statusBgColor: const Color(0xFFE6F4EA),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget: Filter Chips
  Widget buildFilterChip(
    String label, {
    bool isSelected = false,
    bool hasDropdown = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2575FC) : const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF344054),
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF344054),
            ),
          ],
        ],
      ),
    );
  }

  // Helper Widget: Card Item Riwayat Kehadiran
  Widget buildRiwayatCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String statusLabel,
    required String statusTime,
    required Color statusColor,
    required Color statusBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Row(
        children: [
          // Icon Bulat Kiri
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),

          // Informasi Tengah (Nama Matkul & Waktu)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),

          // Status Kanan (Badge Status & Jam Scan)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                statusTime,
                style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

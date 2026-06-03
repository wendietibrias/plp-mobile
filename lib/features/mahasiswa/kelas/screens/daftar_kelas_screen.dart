import 'package:flutter/material.dart';

class DaftarKelasScreen extends StatelessWidget {
  const DaftarKelasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data tiruan jadwal kelas mahasiswa
    final List<Map<String, dynamic>> daftarJadwal = [
      {
        'matkul': 'Kalkulus II',
        'kode': 'IF1234',
        'prodi': 'TEKNIK INFORMATIKA',
        'ruang': 'R. Kuliah 402',
        'jam': '08:00 - 10:00',
        'hari': 'Senin',
        'isToday': true,
      },
      {
        'matkul': 'Fisika Dasar',
        'kode': 'IF1235',
        'prodi': 'TEKNIK INFORMATIKA',
        'ruang': 'Lab Komputer 302',
        'jam': '13:00 - 14:40',
        'hari': 'Senin',
        'isToday': true,
      },
      {
        'matkul': 'Struktur Data',
        'kode': 'IF1238',
        'prodi': 'TEKNIK INFORMATIKA',
        'ruang': 'R. Kuliah 201',
        'jam': '09:40 - 12:10',
        'hari': 'Selasa',
        'isToday': false,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Jadwal Kelas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D2939),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: daftarJadwal.length,
        itemBuilder: (context, index) {
          final kelas = daftarJadwal[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    kelas['isToday']
                        ? const Color(0xFF2575FC).withOpacity(0.3)
                        : const Color(0xFFE4E7EC),
                width: kelas['isToday'] ? 1.5 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                // NAVIGASI: Ke Detail Kelas yang sudah Anda buat sebelumnya
                Navigator.pushNamed(context, '/mahasiswa/detail-kelas');
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bagian Atas: Hari / Status Hari Ini
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                kelas['isToday']
                                    ? const Color(0xFF2575FC).withOpacity(0.1)
                                    : const Color(0xFFF2F4F7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            kelas['isToday'] ? 'Hari Ini' : kelas['hari'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  kelas['isToday']
                                      ? const Color(0xFF2575FC)
                                      : const Color(0xFF667085),
                            ),
                          ),
                        ),
                        Text(
                          kelas['kode'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF98A2B3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Nama Matakuliah
                    Text(
                      kelas['matkul'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2939),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kelas['prodi'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(height: 24, thickness: 1),

                    // Detail Jam dan Ruangan
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Color(0xFF667085),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          kelas['jam'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1D2939),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: Color(0xFF667085),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          kelas['ruang'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1D2939),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

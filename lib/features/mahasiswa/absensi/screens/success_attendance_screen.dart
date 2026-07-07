import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../auth/providers/auth_provider.dart';
import '../models/attendance_model.dart';

class SuccessAttendanceScreen extends StatelessWidget {
  final AttendanceModel? hasil;

  const SuccessAttendanceScreen({super.key, this.hasil});

  @override
  Widget build(BuildContext context) {
    final student = context.watch<AuthProvider>().student;
    final tanggal = hasil?.scanDate ?? DateTime.now();
    final tepatWaktu = hasil?.tepatWaktu ?? true;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2575FC), Color(0xFF6AA9FF)],
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(
                        Icons.qr_code_2_rounded,
                        size: 96,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Presensi Berhasil!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2939),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tepatWaktu
                        ? 'Anda tercatat hadir tepat waktu'
                        : 'Anda tercatat hadir (terlambat)',
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE4E7EC)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${hasil?.scanTime ?? DateFormat('HH:mm').format(tanggal)} WIB',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2575FC),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, d MMMM y', 'id_ID')
                              .format(tanggal),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF667085),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE4E7EC)),
                    ),
                    child: Column(
                      children: [
                        buildDetailRow(
                          'Nama Mahasiswa',
                          student?.name ?? '-',
                        ),
                        const Divider(height: 24),
                        buildDetailRow(
                          'Mata Kuliah',
                          hasil?.courseName ?? '-',
                        ),
                        const Divider(height: 24),
                        buildDetailRow('Ruangan', hasil?.room ?? '-'),
                        const Divider(height: 24),
                        buildDetailRow(
                          'Status',
                          tepatWaktu ? 'Tepat Waktu' : 'Terlambat',
                          valueColor: tepatWaktu
                              ? const Color(0xFF137333)
                              : const Color(0xFFD97706),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
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

  Widget buildDetailRow(String label, String value, {Color? valueColor}) {
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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor ?? const Color(0xFF1D2939),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

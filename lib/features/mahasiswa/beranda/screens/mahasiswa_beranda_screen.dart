import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/providers/auth_provider.dart';
import '../../kelas/providers/kelas_provider.dart';
import '../../riwayat/providers/riwayat_provider.dart';
import '../widgets/attendance_card.dart';
import '../widgets/class_card.dart';
import '../widgets/stat_card.dart';

class MahasiswaBerandaScreen extends StatelessWidget {
  const MahasiswaBerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final kelas = context.watch<KelasProvider>();
    final riwayat = context.watch<RiwayatProvider>();

    final student = auth.student;
    final summary = riwayat.summary;
    final kelasSelanjutnya = kelas.kelasSelanjutnya;

    final subtitleParts = <String>[
      if (student?.className != null) 'Kelas ${student!.className}',
      if (student?.studyProgramName != null) student!.studyProgramName!,
    ];

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          context
              .read<KelasProvider>()
              .fetchJadwal(student?.classId, refresh: true),
          context.read<RiwayatProvider>().fetch(refresh: true),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFFE0EAFF),
                          backgroundImage: student?.picture != null
                              ? NetworkImage(student!.picture!)
                              : null,
                          child: student?.picture == null
                              ? Text(
                                  student?.initials ?? '?',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2575FC),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, ${student?.name ?? auth.user?.displayName ?? 'Mahasiswa'}!',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D2939),
                                ),
                              ),
                              Text(
                                subtitleParts.isEmpty
                                    ? 'Selamat datang kembali'
                                    : subtitleParts.join(' • '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF667085),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF667085),
                      size: 30,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Belum ada notifikasi baru.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Kartu Kehadiran
              AttendanceCard(
                percentage: summary?.persentase,
                periodLabel: summary?.semesterLabel ?? 'Semester ini',
              ),
              const SizedBox(height: 30),

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
                    onPressed: () =>
                        Navigator.pushNamed(context, '/mahasiswa/kelas'),
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
              _buildKelasSelanjutnya(context, kelas, kelasSelanjutnya),
              const SizedBox(height: 30),

              // Statistik Cepat
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
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.check_circle_rounded,
                      iconColor: const Color(0xFF2E7D32),
                      status: 'HADIR',
                      count: summary?.hadir.toString() ?? '—',
                      subtitle: 'Sesi selesai',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: StatCard(
                      icon: Icons.error_rounded,
                      iconColor: const Color(0xFFD32F2F),
                      status: 'TERLAMBAT',
                      count: summary?.terlambat.toString() ?? '—',
                      subtitle: 'Sesi semester ini',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKelasSelanjutnya(
    BuildContext context,
    KelasProvider kelas,
    dynamic kelasSelanjutnya,
  ) {
    switch (kelas.state) {
      case ViewState.loading:
      case ViewState.initial:
        return Container(
          height: 160,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: Color(0xFF2575FC)),
        );
      case ViewState.error:
        return _infoCard(
          icon: Icons.wifi_off_rounded,
          message: kelas.errorMessage ?? 'Gagal memuat jadwal.',
        );
      case ViewState.loaded:
        if (kelasSelanjutnya == null) {
          return _infoCard(
            icon: Icons.event_available_rounded,
            message: 'Tidak ada jadwal kelas aktif. Selamat beristirahat!',
          );
        }
        return ClassCard(
          jadwal: kelasSelanjutnya,
          onDetail: () => Navigator.pushNamed(
            context,
            '/mahasiswa/detail-kelas',
            arguments: kelasSelanjutnya,
          ),
        );
    }
  }

  Widget _infoCard({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: const Color(0xFF98A2B3)),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }
}

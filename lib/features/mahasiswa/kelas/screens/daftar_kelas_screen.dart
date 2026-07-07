import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/providers/auth_provider.dart';
import '../models/class_schedule_model.dart';
import '../providers/kelas_provider.dart';

class DaftarKelasScreen extends StatelessWidget {
  const DaftarKelasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kelas = context.watch<KelasProvider>();
    final student = context.watch<AuthProvider>().student;

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
      body: RefreshIndicator(
        onRefresh: () => context
            .read<KelasProvider>()
            .fetchJadwal(student?.classId, refresh: true),
        child: _buildBody(context, kelas),
      ),
    );
  }

  Widget _buildBody(BuildContext context, KelasProvider kelas) {
    switch (kelas.state) {
      case ViewState.initial:
      case ViewState.loading:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF2575FC)),
        );
      case ViewState.error:
        return _statePlaceholder(
          icon: Icons.error_outline_rounded,
          title: 'Gagal memuat jadwal',
          message: kelas.errorMessage ?? 'Terjadi kesalahan.',
        );
      case ViewState.loaded:
        if (kelas.jadwal.isEmpty) {
          return _statePlaceholder(
            icon: Icons.event_busy_rounded,
            title: 'Belum ada jadwal',
            message: 'Jadwal kuliah untuk kelasmu belum tersedia.',
          );
        }
        // Jadwal hari ini tampil paling atas.
        final sorted = [...kelas.jadwal]..sort((a, b) {
            if (a.isToday != b.isToday) return a.isToday ? -1 : 1;
            return a.startMinutes.compareTo(b.startMinutes);
          });

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: sorted.length,
          itemBuilder: (context, index) =>
              _JadwalCard(jadwal: sorted[index]),
        );
    }
  }

  Widget _statePlaceholder({
    required IconData icon,
    required String title,
    required String message,
  }) {
    // ListView agar pull-to-refresh tetap berfungsi pada state kosong/error.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(icon, size: 56, color: const Color(0xFF98A2B3)),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D2939),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
          ),
        ),
      ],
    );
  }
}

/// Kartu satu jadwal — desain asli dipertahankan.
class _JadwalCard extends StatelessWidget {
  final ClassScheduleModel jadwal;

  const _JadwalCard({required this.jadwal});

  @override
  Widget build(BuildContext context) {
    final isToday = jadwal.isToday;
    final dibatalkan = jadwal.status == 'cancelled';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday
              ? const Color(0xFF2575FC).withOpacity(0.3)
              : const Color(0xFFE4E7EC),
          width: isToday ? 1.5 : 1,
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
        onTap: () => Navigator.pushNamed(
          context,
          '/mahasiswa/detail-kelas',
          arguments: jadwal,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Atas: Hari / Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isToday
                              ? const Color(0xFF2575FC).withOpacity(0.1)
                              : const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isToday ? 'Hari Ini' : jadwal.hariIndonesia,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isToday
                                ? const Color(0xFF2575FC)
                                : const Color(0xFF667085),
                          ),
                        ),
                      ),
                      if (dibatalkan) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE8E6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Dibatalkan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC5221F),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    jadwal.course.code,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF98A2B3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                jadwal.course.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2939),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${jadwal.course.credit} SKS'
                '${jadwal.semesterName != null ? ' • ${jadwal.semesterName}' : ''}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF667085),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(height: 24, thickness: 1),

              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: Color(0xFF667085),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    jadwal.jamRingkas,
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
                  Expanded(
                    child: Text(
                      jadwal.room,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1D2939),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

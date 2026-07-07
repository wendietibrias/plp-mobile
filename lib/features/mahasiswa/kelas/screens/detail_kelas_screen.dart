import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/class_schedule_model.dart';
import '../providers/kelas_provider.dart';
import '../widgets/meeting_card.dart';

class DetailKelasScreen extends StatefulWidget {
  final ClassScheduleModel jadwal;

  const DetailKelasScreen({super.key, required this.jadwal});

  @override
  State<DetailKelasScreen> createState() => _DetailKelasScreenState();
}

class _DetailKelasScreenState extends State<DetailKelasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KelasProvider>().fetchPertemuan(widget.jadwal.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final jadwal = widget.jadwal;
    final kelas = context.watch<KelasProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.class_outlined,
                color: Color(0xFF2575FC),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    jadwal.course.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2939),
                    ),
                  ),
                  Text(
                    '${jadwal.course.code} • ${jadwal.hariIndonesia.toUpperCase()}, '
                    '${jadwal.jamRingkas} • ${jadwal.room}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF98A2B3),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE4E7EC), height: 1.0),
        ),
      ),
      body: _buildBody(kelas),
    );
  }

  Widget _buildBody(KelasProvider kelas) {
    switch (kelas.pertemuanState) {
      case ViewState.initial:
      case ViewState.loading:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF2575FC)),
        );
      case ViewState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.hourglass_empty_rounded,
                  size: 56,
                  color: Color(0xFF98A2B3),
                ),
                const SizedBox(height: 16),
                Text(
                  kelas.pertemuanError ?? 'Gagal memuat data pertemuan.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF667085),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => context
                      .read<KelasProvider>()
                      .fetchPertemuan(widget.jadwal.id, refresh: true),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        );
      case ViewState.loaded:
        final pertemuan = kelas.pertemuan;
        if (pertemuan.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada pertemuan yang dijadwalkan.',
              style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
            ),
          );
        }

        final totalMeetings = widget.jadwal.totalMeetings;
        final nextMeeting = pertemuan.length + 1;

        return RefreshIndicator(
          onRefresh: () => context
              .read<KelasProvider>()
              .fetchPertemuan(widget.jadwal.id, refresh: true),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: pertemuan.length + 1, // +1 footer
            itemBuilder: (context, index) {
              if (index == pertemuan.length) {
                if (nextMeeting > totalMeetings) {
                  return const SizedBox(height: 24);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    'Pertemuan $nextMeeting - $totalMeetings akan segera tersedia',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF98A2B3),
                      fontSize: 14,
                    ),
                  ),
                );
              }

              final item = pertemuan[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: MeetingCard(
                  status: item.status,
                  date: item.date,
                  title: item.title,
                  time: item.time,
                  isStarted: item.isStarted,
                ),
              );
            },
          ),
        );
    }
  }
}

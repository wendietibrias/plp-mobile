import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../absensi/models/attendance_model.dart';
import '../providers/riwayat_provider.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  String _search = '';
  int _filterIndex = 0;

  static const List<String> _filters = [
    'Semua',
    'Bulan Ini',
    'Tepat Waktu',
    'Terlambat',
  ];

  @override
  Widget build(BuildContext context) {
    final riwayat = context.watch<RiwayatProvider>();

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
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<RiwayatProvider>().fetch(refresh: true),
        child: _buildBody(riwayat),
      ),
    );
  }

  Widget _buildBody(RiwayatProvider riwayat) {
    if (riwayat.state == RiwayatState.loading ||
        riwayat.state == RiwayatState.initial) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2575FC)),
      );
    }

    if (riwayat.state == RiwayatState.error) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Icon(
            riwayat.endpointMissing
                ? Icons.construction_rounded
                : Icons.error_outline_rounded,
            size: 56,
            color: const Color(0xFF98A2B3),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              riwayat.errorMessage ?? 'Gagal memuat riwayat.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
            ),
          ),
        ],
      );
    }

    final summary = riwayat.summary;
    final filtered = _applyFilter(riwayat.items);
    final grouped = _groupByWeek(filtered);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KARTU RINGKASAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5FF),
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
                        child: Text(
                          summary?.persentaseLabel ?? '—',
                          style: const TextStyle(
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
                    value: summary?.persentase ?? 0,
                    backgroundColor: const Color(0xFFE4E7EC),
                    color: const Color(0xFF2575FC),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${summary?.hadir ?? 0} / ${summary?.totalSesi ?? 0}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2575FC),
                        ),
                      ),
                      if (summary?.semesterLabel != null)
                        Text(
                          summary!.semesterLabel!,
                          style: const TextStyle(
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

            // 2. SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: const InputDecoration(
                  hintText: 'Cari mata kuliah...',
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

            // 3. FILTER CHIPS (fungsional)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < _filters.length; i++) ...[
                    buildFilterChip(
                      _filters[i],
                      isSelected: _filterIndex == i,
                      onTap: () => setState(() => _filterIndex = i),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. DAFTAR RIWAYAT (dikelompokkan per minggu)
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Text(
                    'Tidak ada riwayat yang cocok.',
                    style:
                        TextStyle(fontSize: 13, color: Color(0xFF667085)),
                  ),
                ),
              )
            else
              for (final group in grouped.entries) ...[
                Text(
                  group.key,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF98A2B3),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                for (final item in group.value) buildRiwayatCard(item),
                const SizedBox(height: 16),
              ],
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // ── Logika filter & grouping ─────────────────────────────────────

  List<AttendanceModel> _applyFilter(List<AttendanceModel> items) {
    final now = DateTime.now();
    return items.where((item) {
      if (_search.isNotEmpty &&
          !item.courseName.toLowerCase().contains(_search.toLowerCase())) {
        return false;
      }
      switch (_filterIndex) {
        case 1: // Bulan Ini
          final d = item.scanDate;
          return d != null && d.year == now.year && d.month == now.month;
        case 2: // Tepat Waktu
          return item.tepatWaktu;
        case 3: // Terlambat
          return !item.tepatWaktu;
        default:
          return true;
      }
    }).toList()
      ..sort((a, b) {
        final da = a.scanDate, db = b.scanDate;
        if (da == null || db == null) return 0;
        return db.compareTo(da); // terbaru dulu
      });
  }

  Map<String, List<AttendanceModel>> _groupByWeek(
    List<AttendanceModel> items,
  ) {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));

    final grouped = <String, List<AttendanceModel>>{};
    for (final item in items) {
      final d = item.scanDate;
      final String key;
      if (d == null) {
        key = 'LEBIH LAMA';
      } else if (!d.isBefore(startOfWeek)) {
        key = 'MINGGU INI';
      } else if (!d.isBefore(startOfLastWeek)) {
        key = 'MINGGU LALU';
      } else {
        key = 'LEBIH LAMA';
      }
      grouped.putIfAbsent(key, () => []).add(item);
    }
    return grouped;
  }

  // ── Helper widget (desain asli dipertahankan) ────────────────────

  Widget buildFilterChip(
    String label, {
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? const Color(0xFF2575FC) : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF344054),
          ),
        ),
      ),
    );
  }

  Widget buildRiwayatCard(AttendanceModel item) {
    final tepat = item.tepatWaktu;
    final iconColor =
        tepat ? const Color(0xFF137333) : const Color(0xFFD97706);
    final iconBgColor =
        tepat ? const Color(0xFFE6F4EA) : const Color(0xFFFEF3EB);

    final tanggal = item.scanDate == null
        ? '-'
        : DateFormat('EEEE, d MMM', 'id_ID').format(item.scanDate!);
    final subtitle = item.sessionTime == '-'
        ? tanggal
        : '$tanggal • ${item.sessionTime}';

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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              tepat
                  ? Icons.check_circle_rounded
                  : Icons.access_time_filled_rounded,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.courseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tepat ? 'HADIR' : 'TERLAMBAT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.scanTime,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF98A2B3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceModel {
  final int id;
  final String status;
  final String scanTime;
  final DateTime? scanDate;
  final String courseName;
  final String courseCode;
  final String room;
  final String sessionTime;

  const AttendanceModel({
    required this.id,
    required this.status,
    required this.scanTime,
    this.scanDate,
    required this.courseName,
    required this.courseCode,
    required this.room,
    required this.sessionTime,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final session = json['courseSession'];
    final course = session is Map ? session['course'] : json['course'];

    String sessionTime = '-';
    if (session is Map) {
      final start = session['startTime'] ?? '';
      final end = session['endTime'] ?? '';
      if ('$start$end'.isNotEmpty) sessionTime = '$start - $end';
    }

    return AttendanceModel(
      id: json['id'] as int? ?? 0,
      status: (json['status'] as String? ?? 'ON TIME').toUpperCase(),
      scanTime: json['scanTime'] as String? ?? '-',
      scanDate: DateTime.tryParse(json['scanDate']?.toString() ?? ''),
      courseName:
          course is Map ? course['name'] as String? ?? '-' : '-',
      courseCode:
          course is Map ? course['code'] as String? ?? '-' : '-',
      room: json['room'] as String? ??
          (session is Map ? session['room'] as String? ?? '-' : '-'),
      sessionTime: sessionTime,
    );
  }

  bool get tepatWaktu => status == 'ON TIME';
}

class AttendanceSummary {
  final int hadir;
  final int totalSesi;
  final int terlambat;
  final int izin;
  final int alpa;
  final String? semesterLabel;

  const AttendanceSummary({
    required this.hadir,
    required this.totalSesi,
    required this.terlambat,
    required this.izin,
    required this.alpa,
    this.semesterLabel,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      hadir: json['hadir'] as int? ?? json['totalHadir'] as int? ?? 0,
      totalSesi: json['totalSesi'] as int? ?? json['total'] as int? ?? 0,
      terlambat: json['terlambat'] as int? ?? 0,
      izin: json['izin'] as int? ?? 0,
      alpa: json['alpa'] as int? ?? 0,
      semesterLabel: json['semester'] as String?,
    );
  }

  double get persentase => totalSesi == 0 ? 0 : hadir / totalSesi;

  String get persentaseLabel => '${(persentase * 100).round()}%';
}

class ClassScheduleModel {
  final int id;
  final String day; // monday..sunday (enum backend)
  final String startTime; // "08:00" / "08:00:00"
  final String endTime;
  final String room;
  final int totalMeetings;
  final String status; // active | cancelled | completed
  final String? notes;
  final CourseModel course;
  final String? semesterName;

  const ClassScheduleModel({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.totalMeetings,
    required this.status,
    this.notes,
    required this.course,
    this.semesterName,
  });

  factory ClassScheduleModel.fromJson(Map<String, dynamic> json) {
    final semester = json['semester'];
    return ClassScheduleModel(
      id: json['id'] as int,
      day: (json['day'] as String? ?? '').toLowerCase(),
      startTime: json['startTime'] as String? ?? '-',
      endTime: json['endTime'] as String? ?? '-',
      room: json['room'] as String? ?? '-',
      totalMeetings: json['totalMeetings'] as int? ?? 16,
      status: json['status'] as String? ?? 'active',
      notes: json['notes'] as String?,
      course: json['course'] is Map
          ? CourseModel.fromJson(json['course'] as Map<String, dynamic>)
          : const CourseModel.empty(),
      semesterName: semester is Map ? semester['name'] as String? : null,
    );
  }

  static const Map<String, String> _hariMap = {
    'monday': 'Senin',
    'tuesday': 'Selasa',
    'wednesday': 'Rabu',
    'thursday': 'Kamis',
    'friday': 'Jumat',
    'saturday': 'Sabtu',
    'sunday': 'Minggu',
  };

  static const Map<String, int> _weekdayMap = {
    'monday': DateTime.monday,
    'tuesday': DateTime.tuesday,
    'wednesday': DateTime.wednesday,
    'thursday': DateTime.thursday,
    'friday': DateTime.friday,
    'saturday': DateTime.saturday,
    'sunday': DateTime.sunday,
  };

  String get hariIndonesia => _hariMap[day] ?? day;

  bool get isToday => _weekdayMap[day] == DateTime.now().weekday;

  String _short(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  String get jamRingkas => '${_short(startTime)} - ${_short(endTime)}';

  int get startMinutes {
    final parts = startTime.split(':');
    if (parts.length < 2) return 0;
    return (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 0);
  }
}

class CourseModel {
  final int id;
  final String code;
  final String name;
  final int credit;
  final String type; // mandatory | elective | practicum
  final String? description;

  const CourseModel({
    required this.id,
    required this.code,
    required this.name,
    required this.credit,
    required this.type,
    this.description,
  });

  const CourseModel.empty()
      : id = 0,
        code = '-',
        name = 'Mata Kuliah',
        credit = 0,
        type = 'mandatory',
        description = null;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '-',
      name: json['name'] as String? ?? 'Mata Kuliah',
      credit: json['credit'] as int? ?? 0,
      type: json['type'] as String? ?? 'mandatory',
      description: json['description'] as String?,
    );
  }
}

class PertemuanModel {
  final int id;
  final int nomor;
  final String status; // HADIR | ALPA | IZIN | BELUM DIMULAI
  final String date;
  final String title;
  final String time;
  final bool isStarted;

  const PertemuanModel({
    required this.id,
    required this.nomor,
    required this.status,
    required this.date,
    required this.title,
    required this.time,
    required this.isStarted,
  });

  factory PertemuanModel.fromJson(Map<String, dynamic> json, int index) {
    final rawStatus =
        (json['attendanceStatus'] ?? json['status'] ?? '') as String;
    final sessionStatus = (json['sessionStatus'] ?? '') as String;
    final started = sessionStatus.isNotEmpty
        ? sessionStatus.toUpperCase() != 'AKTIF'
        : rawStatus.toUpperCase() != 'BELUM DIMULAI';

    return PertemuanModel(
      id: json['id'] as int? ?? index,
      nomor: json['meetingNumber'] as int? ?? index + 1,
      status: rawStatus.isEmpty
          ? 'BELUM DIMULAI'
          : rawStatus.toUpperCase(),
      date: json['date'] as String? ?? '-',
      title: json['title'] as String? ??
          'Pertemuan ${json['meetingNumber'] ?? index + 1}',
      time: json['time'] as String? ??
          '${json['startTime'] ?? ''} - ${json['endTime'] ?? ''}',
      isStarted: started,
    );
  }
}

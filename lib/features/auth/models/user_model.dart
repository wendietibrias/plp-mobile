class UserModel {
  final int id;
  final String username;
  final String? name;
  final String? roleName;

  const UserModel({
    required this.id,
    required this.username,
    this.name,
    this.roleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      name: json['name'] as String?,
      roleName:
          json['role'] is Map ? json['role']['name'] as String? : null,
    );
  }

  String get displayName =>
      (name != null && name!.isNotEmpty) ? name! : username;
}

class StudentModel {
  final int id;
  final String nim;
  final String name;
  final String email;
  final String? phone;
  final String status;
  final int? angkatan;
  final String? picture;
  final int? classId;
  final String? className;
  final String? studyProgramName;

  const StudentModel({
    required this.id,
    required this.nim,
    required this.name,
    required this.email,
    this.phone,
    required this.status,
    this.angkatan,
    this.picture,
    this.classId,
    this.className,
    this.studyProgramName,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final kelas = json['class'];
    final prodi = json['studyProgram'];
    return StudentModel(
      id: json['id'] as int,
      nim: json['nim'] as String? ?? '-',
      name: json['name'] as String? ?? '-',
      email: json['email'] as String? ?? '-',
      phone: json['phone'] as String?,
      status: json['status'] as String? ?? 'aktif',
      angkatan: json['angkatan'] as int?,
      picture: json['picture'] as String?,
      classId: json['classId'] as int? ??
          (kelas is Map ? kelas['id'] as int? : null),
      className: kelas is Map ? kelas['name'] as String? : null,
      studyProgramName: prodi is Map ? prodi['name'] as String? : null,
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }
}

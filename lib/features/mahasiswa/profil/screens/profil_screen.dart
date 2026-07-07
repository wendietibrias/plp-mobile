import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/providers/auth_provider.dart';
import '../../absensi/providers/absensi_provider.dart';
import '../../kelas/providers/kelas_provider.dart';
import '../../riwayat/providers/riwayat_provider.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar Sesi'),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD92D20),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child:
                const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (konfirmasi != true || !context.mounted) return;

    // Bersihkan sesi + seluruh state milik pengguna sebelumnya.
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    context.read<KelasProvider>().reset();
    context.read<RiwayatProvider>().reset();
    context.read<AbsensiProvider>().reset();

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final summary = context.watch<RiwayatProvider>().summary;

    final student = auth.student;
    final nama = student?.name ?? auth.user?.displayName ?? '-';
    final nim = student?.nim ?? auth.user?.username ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Profil Mahasiswa',
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
              // 1. FOTO PROFIL & IDENTITAS
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: const Color(0xFFE0EAFF),
                        backgroundImage: student?.picture != null
                            ? NetworkImage(student!.picture!)
                            : null,
                        child: student?.picture == null
                            ? Text(
                                student?.initials ?? '?',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2575FC),
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2939),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIM: $nim',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (student?.className != null)
                          buildProfileBadge(
                            'KELAS ${student!.className!.toUpperCase()}',
                            const Color(0xFFE0EAFF),
                            const Color(0xFF2575FC),
                          ),
                        if (student?.studyProgramName != null)
                          buildProfileBadge(
                            student!.studyProgramName!.toUpperCase(),
                            const Color(0xFFF2F4F7),
                            const Color(0xFF475467),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 2. STATISTIK KEHADIRAN
              const Text(
                'Statistik Kehadiran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2939),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: buildStatBox(
                      summary?.persentaseLabel ?? '—',
                      'HADIR',
                      const Color(0xFFE6F4EA),
                      const Color(0xFF137333),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildStatBox(
                      summary?.izin.toString() ?? '—',
                      'IZIN',
                      const Color(0xFFFEF7E0),
                      const Color(0xFFB45309),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildStatBox(
                      summary?.alpa.toString() ?? '—',
                      'ALPA',
                      const Color(0xFFFCE8E6),
                      const Color(0xFFC5221F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. MENU
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E7EC)),
                ),
                child: Column(
                  children: [
                    buildMenuTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifikasi',
                      subtitle: 'Jadwal kuliah & pengumuman',
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF98A2B3),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Pengaturan notifikasi segera hadir.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      indent: 56,
                      color: Color(0xFFF2F4F7),
                    ),
                    buildMenuTile(
                      icon: Icons.palette_outlined,
                      title: 'Tema Aplikasi',
                      subtitle: 'Terang / Gelap',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Terang',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2575FC),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      indent: 56,
                      color: Color(0xFFF2F4F7),
                    ),
                    buildMenuTile(
                      icon: Icons.logout_rounded,
                      title: 'Keluar Sesi',
                      titleColor: const Color(0xFFD92D20),
                      iconColor: const Color(0xFFD92D20),
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget buildStatBox(
    String val,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor.withOpacity(0.8),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color titleColor = const Color(0xFF1D2939),
    Color iconColor = const Color(0xFF475467),
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

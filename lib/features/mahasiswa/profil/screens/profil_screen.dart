import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1D2939)),
            onPressed: () {
              // Logika membuka pengaturan
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. AREA FOTO PROFIL & IDENTITAS
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Stack(
                      children: [
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
                          child: const CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=260&q=80',
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2575FC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ahmad',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2939),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'NIM: 1234567890',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Badges (Kelas & Jurusan)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildProfileBadge(
                          'KELAS XII-A',
                          const Color(0xFFE0EAFF),
                          const Color(0xFF2575FC),
                        ),
                        const SizedBox(width: 8),
                        buildProfileBadge(
                          'IPA',
                          const Color(0xFFF2F4F7),
                          const Color(0xFF475467),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 2. BAGIAN STATISTIK KEHADIRAN (HORIZONTAL CARDS)
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
                      '95%',
                      'HADIR',
                      const Color(0xFFE6F4EA),
                      const Color(0xFF137333),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildStatBox(
                      '3',
                      'IZIN',
                      const Color(0xFFFEF7E0),
                      const Color(0xFFB45309),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildStatBox(
                      '1',
                      'ALPA',
                      const Color(0xFFFCE8E6),
                      const Color(0xFFC5221F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. MENU LIST OPTIONS
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
                      onTap: () {
                        // Logika logout balik ke halaman login awal
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
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

  // Helper: Membuat Badge Profil Atas
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

  // Helper: Membuat Box Statistik (Hadir, Izin, Alpa)
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

  // Helper: Membuat Baris Menu List Item
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
      subtitle:
          subtitle != null
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

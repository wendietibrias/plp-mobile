import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isMahasiswa = true;
  bool isPasswordObscured = true;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _prosesLogin() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final auth = context.read<AuthProvider>();
    final sukses = await auth.login(
      username: _idController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login gagal. Coba lagi.'),
          backgroundColor: const Color(0xFFD92D20),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!isMahasiswa) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dashboard dosen belum tersedia pada versi ini.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (auth.student == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login berhasil, namun akun ini belum tertaut ke data mahasiswa.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    Navigator.pushReplacementNamed(context, '/mahasiswa/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.watch<AuthProvider>().status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Akademik',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: const Color(0xFFE0EAFF),
                child: const Icon(
                  Icons.school_rounded,
                  size: 64,
                  color: Color(0xFF2575FC),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Selamat Datang',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk ke akun Akademik Anda untuk mulai\npresensi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF667085),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildRoleTab(label: 'Mahasiswa', selected: true),
                          _buildRoleTab(label: 'Dosen', selected: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Username / NIM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF344054),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _idController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username atau NIM tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: _inputDecoration(
                        hint: 'Masukkan username atau NIM',
                        prefix: Icons.person,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF344054),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: isPasswordObscured,
                      onFieldSubmitted: (_) =>
                          isLoading ? null : _prosesLogin(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                      decoration: _inputDecoration(
                        hint: '••••••••',
                        prefix: Icons.lock,
                        suffix: IconButton(
                          icon: Icon(
                            isPasswordObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF98A2B3),
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordObscured = !isPasswordObscured;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Silakan hubungi admin akademik untuk reset password.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                            color: Color(0xFF2575FC),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: isLoading ? null : _prosesLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E60E6),
                        disabledBackgroundColor:
                            const Color(0xFF1E60E6).withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.login,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Butuh bantuan teknis?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF667085), fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Hubungi admin akademik di kampus untuk bantuan.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.support_agent,
                        color: Color(0xFF344054),
                      ),
                      label: const Text(
                        'Hubungi Bantuan',
                        style: TextStyle(
                          color: Color(0xFF344054),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFE4E7EC)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleTab({required String label, required bool selected}) {
    final isActive = selected ? isMahasiswa : !isMahasiswa;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isMahasiswa = selected),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isActive
                  ? const Color(0xFF2575FC)
                  : const Color(0xFF475467),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefix,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
      prefixIcon: Icon(prefix, color: const Color(0xFF98A2B3)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: border(const Color(0xFFE4E7EC)),
      focusedBorder: border(const Color(0xFF2575FC)),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red),
    );
  }
}

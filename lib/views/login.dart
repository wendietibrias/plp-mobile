import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Akademik Login UI',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2575FC)),
        fontFamily:
            'Roboto', // Ganti dengan font yang sesuai jika ada (misal: Poppins)
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Tambahkan Key untuk Form dan Controller untuk input
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isMahasiswa = true;
  bool isPasswordObscured = true;
  bool isLoading = false; // Status untuk efek loading saat tombol ditekan

  // 2. Jangan lupa dispose controller untuk mencegah memory leak
  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. Fungsi logika utama untuk memproses login
  void _prosesLogin() async {
    // Validasi form sebelum memproses data
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Ambil nilai dari controller
      String idInput = _idController.text;
      String passwordInput = _passwordController.text;
      String role = isMahasiswa ? "Mahasiswa" : "Dosen";

      // Simulasi proses API / Jaringan (delay 2 detik)
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        isLoading = false;
      });

      // Tampilkan hasil (Bisa diganti dengan logika navigasi ke halaman Home)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Berhasil!\nRole: $role\nID: $idInput'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
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
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey, // 4. Bungkus dengan widget Form dan masukkan Key
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

                    // Tab Toggle (Mahasiswa / Dosen)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isMahasiswa = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isMahasiswa
                                          ? Colors.white
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow:
                                      isMahasiswa
                                          ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                          : [],
                                ),
                                child: Text(
                                  'Mahasiswa',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isMahasiswa
                                            ? const Color(0xFF2575FC)
                                            : const Color(0xFF475467),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isMahasiswa = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      !isMahasiswa
                                          ? Colors.white
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow:
                                      !isMahasiswa
                                          ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                          : [],
                                ),
                                child: Text(
                                  'Dosen',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        !isMahasiswa
                                            ? const Color(0xFF2575FC)
                                            : const Color(0xFF475467),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form ID / Email
                    const Text(
                      'ID / Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF344054),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 5. Ubah TextField menjadi TextFormField
                    TextFormField(
                      controller: _idController, // Sambungkan ke controller
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ID atau Email tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Masukkan ID atau Email',
                        hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF98A2B3),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE4E7EC),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF2575FC),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Form Password
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF344054),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 6. Ubah TextField menjadi TextFormField
                    TextFormField(
                      controller:
                          _passwordController, // Sambungkan ke controller
                      obscureText: isPasswordObscured,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF98A2B3),
                        ),
                        suffixIcon: IconButton(
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
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE4E7EC),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF2575FC),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
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

                    // 7. Modifikasi Tombol Masuk untuk Trigger Validasi & Loading
                    ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : _prosesLogin, // Disable tombol saat loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E60E6),
                        disabledBackgroundColor: const Color(
                          0xFF1E60E6,
                        ).withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child:
                          isLoading
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
                      onPressed: () {},
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
}

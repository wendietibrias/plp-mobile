import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/mahasiswa/absensi/models/attendance_model.dart';
import 'features/mahasiswa/absensi/providers/absensi_provider.dart';
import 'features/mahasiswa/absensi/screens/scan_qr_screen.dart';
import 'features/mahasiswa/absensi/screens/success_attendance_screen.dart';
import 'features/mahasiswa/dashboard/screens/mahasiswa_dashboard_screen.dart';
import 'features/mahasiswa/kelas/models/class_schedule_model.dart';
import 'features/mahasiswa/kelas/providers/kelas_provider.dart';
import 'features/mahasiswa/kelas/screens/daftar_kelas_screen.dart';
import 'features/mahasiswa/kelas/screens/detail_kelas_screen.dart';
import 'features/mahasiswa/riwayat/providers/riwayat_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Format tanggal Bahasa Indonesia (dipakai layar sukses & riwayat).
  await initializeDateFormatting('id_ID');
  runApp(const AkademikApp());
}

/// Key global agar ApiClient bisa memaksa navigasi ke login
/// ketika sesi kedaluwarsa (refresh token gagal).
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>();

class AkademikApp extends StatelessWidget {
  const AkademikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KelasProvider()),
        ChangeNotifierProvider(create: (_) => RiwayatProvider()),
        ChangeNotifierProvider(create: (_) => AbsensiProvider()),
      ],
      child: Builder(
        builder: (context) {
          // Sambungkan "sesi kedaluwarsa" dari lapisan network ke UI.
          ApiClient.instance.onSessionExpired = () {
            context.read<AuthProvider>().onSessionExpired();
            rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          };

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Akademik',
            navigatorKey: rootNavigatorKey,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFF7F8FA),
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF2575FC)),
              fontFamily: 'Poppins',
              useMaterial3: true,
            ),
            initialRoute: '/',
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/mahasiswa/dashboard':
        return MaterialPageRoute(
          builder: (_) => const MahasiswaDashboardScreen(),
        );
      case '/mahasiswa/kelas':
        return MaterialPageRoute(builder: (_) => const DaftarKelasScreen());
      case '/mahasiswa/detail-kelas':
        final jadwal = settings.arguments;
        if (jadwal is! ClassScheduleModel) return _errorRoute();
        return MaterialPageRoute(
          builder: (_) => DetailKelasScreen(jadwal: jadwal),
        );
      case '/mahasiswa/scan-qr':
        return MaterialPageRoute(builder: (_) => const ScanQrScreen());
      case '/mahasiswa/sukses-presensi':
        return MaterialPageRoute(
          builder: (_) => SuccessAttendanceScreen(
            hasil: settings.arguments is AttendanceModel
                ? settings.arguments as AttendanceModel
                : null,
          ),
        );
      default:
        return _errorRoute();
    }
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Halaman tidak ditemukan')),
      ),
    );
  }
}

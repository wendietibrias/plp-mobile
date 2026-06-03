import 'package:flutter/material.dart';

// Widget
import '../../kelas/widgets/meeting_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detail Kelas Akademik',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2575FC)),
        useMaterial3: true,
      ),
      home: const DetailKelasScreen(),
    );
  }
}

class DetailKelasScreen extends StatefulWidget {
  const DetailKelasScreen({super.key});

  @override
  State<DetailKelasScreen> createState() => _DetailKelasScreenState();
}

class _DetailKelasScreenState extends State<DetailKelasScreen> {
  final List<Map<String, dynamic>> pertemuanList = [
    {
      'status': 'HADIR',
      'date': '12 Feb 2024',
      'title': 'Pertemuan 1: Limit & Kontinuitas',
      'time': '08:00 - 10:00',
      'isStarted': true,
    },
    {
      'status': 'HADIR',
      'date': '19 Feb 2024',
      'title': 'Pertemuan 2: Turunan Fungsi',
      'time': '08:00 - 10:00',
      'isStarted': true,
    },
    {
      'status': 'ALPA',
      'date': '26 Feb 2024',
      'title': 'Pertemuan 3: Aplikasi Turunan',
      'time': '08:00 - 10:00',
      'isStarted': true,
    },
    {
      'status': 'IZIN',
      'date': '04 Mar 2024',
      'title': 'Pertemuan 4: Integral Tak Tentu',
      'time': '08:00 - 10:00',
      'isStarted': true,
    },
    {
      'status': 'BELUM DIMULAI',
      'date': '11 Mar 2024',
      'title': 'Pertemuan 5: Integral Tentu',
      'time': '08:00 - 10:00',
      'isStarted': false,
    },
    {
      'status': 'BELUM DIMULAI',
      'date': '18 Mar 2024',
      'title': 'Pertemuan 6: Teknik Integrasi Lanjut',
      'time': '08:00 - 10:00',
      'isStarted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            // Icon Berwarna Biru di samping Judul
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
            // Judul & Subtitle Matakuliah
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Kalkulus II',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                  ),
                ),
                Text(
                  'IF1234 • TEKNIK INFORMATIKA',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF98A2B3),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE4E7EC), height: 1.0),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pertemuanList.length + 1, // +1 untuk footer text
        itemBuilder: (context, index) {
          if (index == pertemuanList.length) {
            // Footer text paling bawah
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'Pertemuan 7 - 16 akan segera tersedia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF98A2B3),
                  fontSize: 14,
                ),
              ),
            );
          }

          final item = pertemuanList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: MeetingCard(
              status: item['status'],
              date: item['date'],
              title: item['title'],
              time: item['time'],
              isStarted: item['isStarted'],
            ),
          );
        },
      ),
    );
  }
}

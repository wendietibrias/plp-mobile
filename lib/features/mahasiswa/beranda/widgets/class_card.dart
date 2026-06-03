import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFF667085),
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Ruang Laboratorium 302',
                      style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fisika Dasar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(
                      Icons.access_time_filled_rounded,
                      color: Color(0xFF667085),
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '13:00 - 14:40',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1D2939),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2575FC).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Lihat Detail',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2575FC),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://via.placeholder.com/130x130.png?text=Aset+Lab',
                ), // Ganti dengan aset lokal
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

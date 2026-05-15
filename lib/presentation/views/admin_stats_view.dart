import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/core/services/book_service.dart';

class AdminStatsView extends StatelessWidget {
  const AdminStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final BookService bookService = BookService();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: bookService.getStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = snapshot.data ?? {};
          
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: GridView.count(
              crossAxisCount: 1,
              mainAxisSpacing: 16,
              childAspectRatio: 3,
              children: [
                _buildStatCard('Total Livres', stats['total_books']?.toString() ?? '0', Icons.library_books, Colors.blue),
                _buildStatCard('Livres Disponibles', stats['available_books']?.toString() ?? '0', Icons.check_circle, Colors.green),
                _buildStatCard('Livres Empruntés', stats['borrowed_books']?.toString() ?? '0', Icons.bookmark, Colors.orange),
                _buildStatCard('Total Étudiants', stats['students']?.toString() ?? '0', Icons.people, Colors.purple),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          Icon(icon, size: 48, color: color.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/presentation/views/login_view.dart';
import 'package:library_cmc/presentation/views/manage_books_view.dart';
import 'package:library_cmc/presentation/views/manage_students_view.dart';
import 'package:library_cmc/presentation/views/admin_loans_view.dart';
import 'package:library_cmc/presentation/views/admin_stats_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isAdminLoggedIn', false);
              
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue, Administrateur',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1, // Légèrement plus haut pour éviter l'overflow
                children: [
                  _buildAdminCard(
                    context,
                    'Gestion des Livres',
                    Icons.menu_book,
                    Colors.blue,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageBooksView())),
                  ),
                  _buildAdminCard(
                    context,
                    'Gestion Étudiants',
                    Icons.people,
                    Colors.green,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageStudentsView())),
                  ),
                  _buildAdminCard(
                    context,
                    'Réservations',
                    Icons.bookmark_added,
                    Colors.orange,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoansView())),
                  ),
                  _buildAdminCard(
                    context,
                    'Statistiques',
                    Icons.bar_chart,
                    Colors.purple,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminStatsView())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shadowColor: color.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12), // Réduit un peu le padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, color.withValues(alpha: 0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color), // Icône légèrement plus petite
              const SizedBox(height: 8), // Espace réduit
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


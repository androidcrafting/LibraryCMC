import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/presentation/views/login_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Mon Profil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Espace personnel (En cours)',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Se déconnecter', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

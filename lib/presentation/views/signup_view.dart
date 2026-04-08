import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/presentation/views/login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  Role _selectedRole = Role.student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Créer un compte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Official Logo Display
              Center(
                child: Hero(
                  tag: 'app_logo',
                  child: Container(
                    width: 280, // Larger width
                    height: 180, // Proportional height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover, // Fill entire space
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Header
              Text(
                'Créer un compte',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Rejoignez l\'atelier numérique\nde la connaissance.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              
              // Role Selector
              Center(
                child: SegmentedButton<Role>(
                  segments: const [
                    ButtonSegment<Role>(
                      value: Role.student,
                      label: Text('Étudiant'),
                      icon: Icon(Icons.school_outlined),
                    ),
                    ButtonSegment<Role>(
                      value: Role.admin,
                      label: Text('Administrateur'),
                      icon: Icon(Icons.admin_panel_settings_outlined),
                    ),
                  ],
                  selected: {_selectedRole},
                  onSelectionChanged: (Set<Role> newSelection) {
                    setState(() {
                      _selectedRole = newSelection.first;
                    });
                  },
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.white,
                    selectedForegroundColor: Colors.white,
                    selectedBackgroundColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Full Name field
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Nom Complet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                   SizedBox(height: 8),
                   TextField(
                    decoration: InputDecoration(
                      hintText: 'Jean Dupont',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Student ID Field (from spec AUTH 01)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                     _selectedRole == Role.admin ? 'Code Administrateur' : 'ID Étudiant', 
                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                   ),
                   const SizedBox(height: 8),
                   TextField(
                    decoration: InputDecoration(
                      hintText: _selectedRole == Role.admin ? 'ADM-XXXX' : 'CMC-2024-0000',
                      prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Email Field (Soft Fill)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                     _selectedRole == Role.admin ? 'Email Administrateur' : 'Email Académique', 
                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                   ),
                   const SizedBox(height: 8),
                   TextField(
                    decoration: InputDecoration(
                      hintText: _selectedRole == Role.admin ? 'admin@cmc.cmc' : 'nom@etudiant.cmc',
                      prefixIcon: const Icon(Icons.alternate_email, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Password Field (Soft Fill)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Mot de passe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                   SizedBox(height: 8),
                   TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              
              // Sign Up Button (Gradient)
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_selectedRole == Role.admin ? 'Compte administrateur créé !' : 'Compte étudiant créé !'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: const Text('S\'inscrire', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
              
              // Already have an account ?
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Vous avez déjà un compte ? ', style: TextStyle(color: AppColors.onSurfaceVariant)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

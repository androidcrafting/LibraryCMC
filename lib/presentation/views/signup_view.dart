import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/presentation/views/login_view.dart';
import 'package:library_cmc/core/services/auth_service.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  Role _selectedRole = Role.student;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text('Nom Complet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                   const SizedBox(height: 8),
                   TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
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
                    controller: _idController,
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: _selectedRole == Role.admin ? 'admin@cmc.cmc' : 'nom@etudiant.cmc',
                      prefixIcon: const Icon(Icons.alternate_email, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Password Field (Soft Fill)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text('Mot de passe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                   const SizedBox(height: 8),
                   TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
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
                  onPressed: _isLoading ? null : () async {
                    setState(() => _isLoading = true);
                    try {
                      await _authService.signUp(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        fullName: _nameController.text.trim(),
                        customId: _idController.text.trim(),
                        role: _selectedRole == Role.admin ? 'admin' : 'student',
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_selectedRole == Role.admin ? 'Compte administrateur créé !' : 'Compte étudiant créé !'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur: ${e.toString()}'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    } finally {
                      if (context.mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: _isLoading 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('S\'inscrire', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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

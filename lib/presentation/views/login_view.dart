import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/presentation/views/signup_view.dart';
import 'package:library_cmc/presentation/views/main_navigation_wrapper.dart';
import 'package:library_cmc/presentation/views/admin_dashboard_view.dart';
import 'package:library_cmc/core/services/auth_service.dart';
import 'package:library_cmc/core/config/admin_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Role { student, admin }

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Role _selectedRole = Role.student;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center for branding
            children: [
              const SizedBox(height: 60),
              
              // Official Logo Display
              Hero(
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
              const SizedBox(height: 32),
              
              // Welcome Header
              Text(
                'LibraryCMC',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.primary,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'L\'Atelier Numérique de la connaissance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.5,
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
                      _emailController.clear();
                      _passwordController.clear();
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
              
              // Email Field (Soft Fill)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedRole == Role.admin ? 'Email Administrateur' : 'Email Académique', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: _selectedRole == Role.admin ? 'admin@cmc.cmc' : 'nom@etudiant.cmc',
                      prefixIcon: const Icon(Icons.alternate_email, color: AppColors.primary),
                      fillColor: Colors.white, // Pure white for fields on grey surface
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Password Field (Soft Fill)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mot de passe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Mot de passe oublié ?', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 40),
              
              // Login Button (Gradient Signature)
              Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16), // Matching Material 3 Rounded Rect
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    setState(() => _isLoading = true);
                    try {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (_selectedRole == Role.admin) {
                        // Admin hardcoded login check
                        if (email == AdminConfig.adminEmail && password == AdminConfig.adminPassword) {
                          // Perform real Supabase sign-in for the admin to get a session
                          await _authService.signIn(
                            email: email,
                            password: password,
                          );

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isAdminLoggedIn', true);
                          
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminDashboardView()),
                          );
                        } else {
                          throw Exception('Identifiants admin incorrects');
                        }
                      } else {
                        // Student Supabase login
                        await _authService.signIn(
                          email: email,
                          password: password,
                        );
                        
                        if (!context.mounted) return;
                        
                        final role = _authService.getCurrentUserRole();
                        
                        if (role == 'admin') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Attention: Ce compte est un compte administrateur.'),
                            ),
                          );
                        }
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainNavigationWrapper()),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erreur de connexion : Identifiants incorrects'),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Se connecter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
              
              // Signup Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nouveau ici ? ', style: TextStyle(color: AppColors.onSurfaceVariant)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupView()),
                      );
                    },
                    child: const Text(
                      'Créer un compte',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

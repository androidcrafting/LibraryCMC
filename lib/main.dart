import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/presentation/views/onboarding_view.dart';
import 'package:library_cmc/presentation/views/main_navigation_wrapper.dart';
import 'package:library_cmc/presentation/views/admin_dashboard_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://nyqghwvzcahsbgwqqjhc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im55cWdod3Z6Y2Foc2Jnd3FxamhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5MTk3NjgsImV4cCI6MjA5MzQ5NTc2OH0.5DAAgiTfHB9ZM5K-fLe9m8A451eT6rKpgPTyJ5ncEzI',
  );
  
  runApp(const LibraryCMCApp());
}

class LibraryCMCApp extends StatelessWidget {
  const LibraryCMCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LibraryCMC',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAdminLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdminLoggedIn = prefs.getBool('isAdminLoggedIn') ?? false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isAdminLoggedIn) {
      return const AdminDashboardView();
    }

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return const MainNavigationWrapper();
    }

    return const OnboardingView();
  }
}

import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/presentation/views/onboarding_view.dart';

void main() {
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
      home: const OnboardingView(),
    );
  }
}

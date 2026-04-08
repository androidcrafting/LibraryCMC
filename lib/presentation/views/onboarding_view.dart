import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/presentation/views/login_view.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final String stepLabel;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.stepLabel,
  });
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Explore a World\nof Knowledge.',
      description: 'Access over 50,000 digital titles and physical archives from CMC\'s premium collection at your fingertips.',
      imagePath: 'assets/images/onboarding_1.png',
      stepLabel: '01 / 03',
    ),
    OnboardingItem(
      title: 'Effortless\nReservations.',
      description: 'Skip the search. Browse our vast digital catalog and reserve your physical copies with a single tap.',
      imagePath: 'assets/images/onboarding_2.png',
      stepLabel: '02 / 03',
    ),
    OnboardingItem(
      title: 'Votre ID, toujours\navec vous.',
      description: 'Oubliez votre carte physique. Scannez votre mobile pour emprunter des livres et accéder aux espaces de l\'Atelier.',
      imagePath: 'assets/images/onboarding_3.png',
      stepLabel: '03 / 03',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('CMC Library'),
        actions: [
          TextButton(
            onPressed: () => _navigateToLogin(),
            child: const Text('Passer', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Image Display (Atelier Card with lg rounding)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.onSurface.withValues(alpha: 0.06),
                                blurRadius: 32,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Bottom Controls
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STEP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      _items[_currentPage].stepLabel,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                
                // Next/Start Button
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _items.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _navigateToLogin();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004A99), // Tonal Blue fallback
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_currentPage == _items.length - 1 ? 'Commencer' : 'Next'),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }
}

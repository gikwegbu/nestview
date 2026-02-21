// lib/features/onboarding/views/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _pages = [
    _OnboardingPage(
      icon: Icons.search_rounded,
      title: AppStrings.onboarding1Title,
      subtitle: AppStrings.onboarding1Subtitle,
      primaryColor: AppColors.secondary,
      illustrationIcon: Icons.location_city_rounded,
    ),
    _OnboardingPage(
      icon: Icons.favorite_rounded,
      title: AppStrings.onboarding2Title,
      subtitle: AppStrings.onboarding2Subtitle,
      primaryColor: AppColors.accent,
      illustrationIcon: Icons.notifications_active_rounded,
    ),
    _OnboardingPage(
      icon: Icons.calculate_rounded,
      title: AppStrings.onboarding3Title,
      subtitle: AppStrings.onboarding3Subtitle,
      primaryColor: AppColors.success,
      illustrationIcon: Icons.bar_chart_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    // Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Mark onboarding complete
    await Hive.box<bool>(AppConstants.onboardingBox).put('completed', true);

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text('Skip', style: AppTextStyles.labelLarge),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPageWidget(
                    page: page,
                    isActive: _currentPage == index,
                  );
                },
              ),
            ),

            // Page indicator + buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: AppConstants.shortAnimation,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == i ? 28 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.secondary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _nextPage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage < _pages.length - 1
                                ? 'Continue'
                                : 'Get Started',
                            style: AppTextStyles.buttonLarge,
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final IconData illustrationIcon;
  final String title;
  final String subtitle;
  final Color primaryColor;

  const _OnboardingPage({
    required this.icon,
    required this.illustrationIcon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
  });
}

class _OnboardingPageWidget extends StatelessWidget {
  final _OnboardingPage page;
  final bool isActive;

  const _OnboardingPageWidget({required this.page, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      page.primaryColor.withOpacity(0.15),
                      page.primaryColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      page.illustrationIcon,
                      size: 100,
                      color: page.primaryColor.withOpacity(0.15),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: page.primaryColor.withOpacity(0.1),
                        border: Border.all(
                          color: page.primaryColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        page.icon,
                        size: 56,
                        color: page.primaryColor,
                      ),
                    ),
                  ],
                ),
              )
              .animate(target: isActive ? 1 : 0)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 48),

          Text(
                page.title,
                style: AppTextStyles.displayMedium,
                textAlign: TextAlign.center,
              )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 100.ms),

          const SizedBox(height: 16),

          Text(
                page.subtitle,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 200.ms),
        ],
      ),
    );
  }
}

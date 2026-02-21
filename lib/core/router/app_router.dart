// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/onboarding/views/splash_screen.dart';
import '../../features/onboarding/views/onboarding_screen.dart';
import '../../features/search/views/home_screen.dart';
import '../../features/search/views/search_results_screen.dart';
import '../../features/property_detail/views/property_detail_screen.dart';
import '../../features/favourites/views/favourites_screen.dart';
import '../../features/mortgage_calculator/views/mortgage_calculator_screen.dart';
import '../../features/map_search/views/map_search_screen.dart';
import '../../features/area_insights/views/area_insights_screen.dart';
import '../../features/profile/views/profile_screen.dart';
import '../widgets/main_scaffold.dart';
import '../constants/app_constants.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final onboardingDone =
          Hive.box<bool>(AppConstants.onboardingBox).get('completed') ?? false;
      final isSplash = state.matchedLocation == AppRoutes.splash;
      if (isSplash) return null;
      if (!onboardingDone && state.matchedLocation != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: OnboardingScreen()),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.searchResults,
            pageBuilder: (context, state) {
              final query = state.uri.queryParameters['q'] ?? '';
              final type = state.uri.queryParameters['type'] ?? 'buy';
              return SlideTransitionPage(
                child: SearchResultsScreen(query: query, listingType: type),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.favourites,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: FavouritesScreen()),
          ),
          GoRoute(
            path: AppRoutes.mortgageCalculator,
            pageBuilder: (context, state) {
              final price = double.tryParse(
                state.uri.queryParameters['price'] ?? '',
              );
              return SlideTransitionPage(
                child: MortgageCalculatorScreen(initialPrice: price),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '${AppRoutes.propertyDetail}/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return SlideTransitionPage(
            child: PropertyDetailScreen(propertyId: id),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.mapSearch,
        pageBuilder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          return SlideTransitionPage(
            child: MapSearchScreen(initialQuery: query),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '${AppRoutes.areaInsights}/:area',
        pageBuilder: (context, state) {
          final area = state.pathParameters['area']!;
          return SlideTransitionPage(child: AreaInsightsScreen(area: area));
        },
      ),
    ],
  );
});

abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String searchResults = '/search';
  static const String propertyDetail = '/property';
  static const String favourites = '/favourites';
  static const String mortgageCalculator = '/mortgage';
  static const String mapSearch = '/map';
  static const String areaInsights = '/area-insights';
  static const String profile = '/profile';
}

class SlideTransitionPage<T> extends CustomTransitionPage<T> {
  SlideTransitionPage({required Widget child})
    : super(
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      );
}

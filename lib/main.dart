// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/search/models/property_model.dart';
import 'features/search/models/property_preview_model.dart';
import 'features/search/models/search_filter_model.dart';
import 'features/mortgage_calculator/models/mortgage_calculation_model.dart';
import 'features/profile/models/user_preferences_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // System UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Hive initialization
  await Hive.initFlutter();

  // Register Hive adapters (guarded — safe on hot restart)
  _registerAdapter(PropertyTypeAdapter());
  _registerAdapter(ListingTypeAdapter());
  _registerAdapter(PropertyModelAdapter());
  _registerAdapter(PropertyPreviewModelAdapter());
  _registerAdapter(TransportModeAdapter());
  _registerAdapter(SearchFilterModelAdapter());
  _registerAdapter(MortgageCalculationModelAdapter());
  _registerAdapter(UserPreferencesModelAdapter());

  // Open Hive boxes (guarded — safe on hot restart)
  await Future.wait([
    _openBox<PropertyPreviewModel>(AppConstants.favouritesBox),
    _openBox<SearchFilterModel>(AppConstants.savedSearchesBox),
    _openBox<PropertyPreviewModel>(AppConstants.recentlyViewedBox),
    _openBox<MortgageCalculationModel>(AppConstants.savedCalculationsBox),
    _openBox<dynamic>(AppConstants.userPreferencesBox),
    _openBox<bool>(AppConstants.onboardingBox),
  ]);

  runApp(const ProviderScope(child: NestViewApp()));
}

class NestViewApp extends ConsumerWidget {
  const NestViewApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}

/// Registers a Hive adapter only if it hasn't been registered yet.
/// Safe to call on hot restart.
void _registerAdapter<T>(TypeAdapter<T> adapter) {
  if (!Hive.isAdapterRegistered(adapter.typeId)) {
    Hive.registerAdapter(adapter);
  }
}

/// Opens a Hive box only if it isn't already open.
/// Safe to call on hot restart.
Future<Box<T>> _openBox<T>(String name) async {
  if (Hive.isBoxOpen(name)) return Hive.box<T>(name);
  return Hive.openBox<T>(name);
}

// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'NestHaven';
  static const String appTagline = 'UK Property Search';
  static const String bundleId = 'com.gikwegbu.nest_haven';

  // Hive Box Names
  static const String favouritesBox = 'favouritesBox';
  static const String savedSearchesBox = 'savedSearchesBox';
  static const String recentlyViewedBox = 'recentlyViewedBox';
  static const String savedCalculationsBox = 'savedCalculationsBox';
  static const String userPreferencesBox = 'userPreferencesBox';
  static const String onboardingBox = 'onboardingBox';

  // Hive Type IDs
  static const int propertyModelTypeId = 0;
  static const int propertyPreviewModelTypeId = 1;
  static const int searchFilterModelTypeId = 2;
  static const int mortgageCalculationModelTypeId = 3;
  static const int userPreferencesModelTypeId = 4;
  static const int propertyTypeEnumTypeId = 5;
  static const int listingTypeEnumTypeId = 6;
  static const int transportModeTypeId = 7;

  // Mock API Base URL
  static const String baseUrl = 'https://api.NestHaven.co.uk/v1';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxRecentlyViewed = 20;
  static const int maxSavedCalculations = 50;

  // UK Property
  static const double ukStampDutyThreshold1 = 250000;
  static const double ukStampDutyThreshold2 = 925000;
  static const double ukStampDutyThreshold3 = 1500000;
  static const double ftbStampDutyThreshold1 = 425000;
  static const double ftbStampDutyThreshold2 = 625000;
  static const double mortgageAffordabilityMultiple = 4.5;

  // Stamp Duty Rates (standard)
  static const double sdRate0 = 0.0;
  static const double sdRate1 = 0.05;
  static const double sdRate2 = 0.10;
  static const double sdRate3 = 0.12;

  // Stamp Duty Rates (second home surcharge — +3%)
  static const double sdSurcharge = 0.03;

  // Map
  static const double defaultMapLatitude = 51.5074; // London
  static const double defaultMapLongitude = -0.1278;
  static const double defaultMapZoom = 11.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 700);
  static const Duration splashDuration = Duration(seconds: 3);

  // UK Cities for popular areas
  static const List<Map<String, dynamic>> popularCities = [
    {'name': 'London', 'properties': '45,230', 'image': 'london'},
    {'name': 'Manchester', 'properties': '12,840', 'image': 'manchester'},
    {'name': 'Birmingham', 'properties': '9,510', 'image': 'birmingham'},
    {'name': 'Edinburgh', 'properties': '6,720', 'image': 'edinburgh'},
    {'name': 'Bristol', 'properties': '5,380', 'image': 'bristol'},
    {'name': 'Leeds', 'properties': '7,120', 'image': 'leeds'},
    {'name': 'Liverpool', 'properties': '6,870', 'image': 'liverpool'},
    {'name': 'Cardiff', 'properties': '3,950', 'image': 'cardiff'},
    {'name': 'Glasgow', 'properties': '5,610', 'image': 'glasgow'},
    {'name': 'Sheffield', 'properties': '4,280', 'image': 'sheffield'},
  ];
}

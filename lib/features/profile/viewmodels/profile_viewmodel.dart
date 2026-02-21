// lib/features/profile/viewmodels/profile_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_preferences_model.dart';
import '../../../core/constants/app_constants.dart';

final profileProvider = NotifierProvider<ProfileNotifier, UserPreferencesModel>(
  ProfileNotifier.new,
);

class ProfileNotifier extends Notifier<UserPreferencesModel> {
  late Box<dynamic> _box;

  @override
  UserPreferencesModel build() {
    _box = Hive.box(AppConstants.userPreferencesBox);
    final raw = _box.get('prefs');
    if (raw == null) return UserPreferencesModel();
    return _fromMap(Map<String, dynamic>.from(raw as Map));
  }

  void updateName(String name) {
    state = UserPreferencesModel(
      name: name,
      email: state.email,
      maxBudget: state.maxBudget,
      minBudget: state.minBudget,
      preferredAreas: state.preferredAreas,
      preferredPropertyTypes: state.preferredPropertyTypes,
      minBedrooms: state.minBedrooms,
      preferredListingType: state.preferredListingType,
      priceDropAlerts: state.priceDropAlerts,
      newListingAlerts: state.newListingAlerts,
      savedSearchAlerts: state.savedSearchAlerts,
      isFirstTimeBuyer: state.isFirstTimeBuyer,
    );
    _persist();
  }

  void updateBudget(double min, double max) {
    state = UserPreferencesModel(
      name: state.name,
      email: state.email,
      maxBudget: max,
      minBudget: min,
      preferredAreas: state.preferredAreas,
      preferredPropertyTypes: state.preferredPropertyTypes,
      minBedrooms: state.minBedrooms,
      preferredListingType: state.preferredListingType,
      priceDropAlerts: state.priceDropAlerts,
      newListingAlerts: state.newListingAlerts,
      savedSearchAlerts: state.savedSearchAlerts,
      isFirstTimeBuyer: state.isFirstTimeBuyer,
    );
    _persist();
  }

  void togglePriceDropAlerts(bool value) {
    state = UserPreferencesModel(
      name: state.name,
      email: state.email,
      maxBudget: state.maxBudget,
      minBudget: state.minBudget,
      preferredAreas: state.preferredAreas,
      preferredPropertyTypes: state.preferredPropertyTypes,
      minBedrooms: state.minBedrooms,
      preferredListingType: state.preferredListingType,
      priceDropAlerts: value,
      newListingAlerts: state.newListingAlerts,
      savedSearchAlerts: state.savedSearchAlerts,
      isFirstTimeBuyer: state.isFirstTimeBuyer,
    );
    _persist();
  }

  void toggleNewListingAlerts(bool value) {
    state = UserPreferencesModel(
      name: state.name,
      email: state.email,
      maxBudget: state.maxBudget,
      minBudget: state.minBudget,
      preferredAreas: state.preferredAreas,
      preferredPropertyTypes: state.preferredPropertyTypes,
      minBedrooms: state.minBedrooms,
      preferredListingType: state.preferredListingType,
      priceDropAlerts: state.priceDropAlerts,
      newListingAlerts: value,
      savedSearchAlerts: state.savedSearchAlerts,
      isFirstTimeBuyer: state.isFirstTimeBuyer,
    );
    _persist();
  }

  void setFirstTimeBuyer(bool value) {
    state = UserPreferencesModel(
      name: state.name,
      email: state.email,
      maxBudget: state.maxBudget,
      minBudget: state.minBudget,
      preferredAreas: state.preferredAreas,
      preferredPropertyTypes: state.preferredPropertyTypes,
      minBedrooms: state.minBedrooms,
      preferredListingType: state.preferredListingType,
      priceDropAlerts: state.priceDropAlerts,
      newListingAlerts: state.newListingAlerts,
      savedSearchAlerts: state.savedSearchAlerts,
      isFirstTimeBuyer: value,
    );
    _persist();
  }

  void _persist() {
    _box.put('prefs', {
      'name': state.name,
      'email': state.email,
      'maxBudget': state.maxBudget,
      'minBudget': state.minBudget,
      'preferredAreas': state.preferredAreas,
      'preferredPropertyTypes': state.preferredPropertyTypes,
      'minBedrooms': state.minBedrooms,
      'preferredListingType': state.preferredListingType,
      'priceDropAlerts': state.priceDropAlerts,
      'newListingAlerts': state.newListingAlerts,
      'savedSearchAlerts': state.savedSearchAlerts,
      'isFirstTimeBuyer': state.isFirstTimeBuyer,
    });
  }

  UserPreferencesModel _fromMap(Map<String, dynamic> map) =>
      UserPreferencesModel(
        name: map['name'] as String?,
        email: map['email'] as String?,
        maxBudget: (map['maxBudget'] as num?)?.toDouble() ?? 500000,
        minBudget: (map['minBudget'] as num?)?.toDouble() ?? 0,
        preferredAreas: List<String>.from(map['preferredAreas'] ?? []),
        preferredPropertyTypes: List<String>.from(
          map['preferredPropertyTypes'] ?? [],
        ),
        minBedrooms: map['minBedrooms'] as int? ?? 1,
        preferredListingType: map['preferredListingType'] as String? ?? 'buy',
        priceDropAlerts: map['priceDropAlerts'] as bool? ?? true,
        newListingAlerts: map['newListingAlerts'] as bool? ?? true,
        savedSearchAlerts: map['savedSearchAlerts'] as bool? ?? true,
        isFirstTimeBuyer: map['isFirstTimeBuyer'] as bool? ?? false,
      );
}

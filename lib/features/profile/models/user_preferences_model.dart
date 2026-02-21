// lib/features/profile/models/user_preferences_model.dart
import 'package:hive/hive.dart';

part 'user_preferences_model.g.dart';

@HiveType(typeId: 7)
class UserPreferencesModel extends HiveObject {
  @HiveField(0)
  double maxBudget;

  @HiveField(1)
  double minBudget;

  @HiveField(2)
  List<String> preferredAreas;

  @HiveField(3)
  List<String> preferredPropertyTypes;

  @HiveField(4)
  int minBedrooms;

  @HiveField(5)
  String preferredListingType;

  @HiveField(6)
  bool priceDropAlerts;

  @HiveField(7)
  bool newListingAlerts;

  @HiveField(8)
  bool savedSearchAlerts;

  @HiveField(9)
  String? name;

  @HiveField(10)
  String? email;

  @HiveField(11)
  bool isFirstTimeBuyer;

  UserPreferencesModel({
    this.maxBudget = 500000,
    this.minBudget = 0,
    this.preferredAreas = const [],
    this.preferredPropertyTypes = const [],
    this.minBedrooms = 1,
    this.preferredListingType = 'buy',
    this.priceDropAlerts = true,
    this.newListingAlerts = true,
    this.savedSearchAlerts = true,
    this.name,
    this.email,
    this.isFirstTimeBuyer = false,
  });
}

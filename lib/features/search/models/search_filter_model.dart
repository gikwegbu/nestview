// lib/features/search/models/search_filter_model.dart
import 'package:hive/hive.dart';

part 'search_filter_model.g.dart';

@HiveType(typeId: 4)
enum TransportMode {
  @HiveField(0)
  walking,
  @HiveField(1)
  cycling,
  @HiveField(2)
  driving,
  @HiveField(3)
  transit,
}

@HiveType(typeId: 5)
class SearchFilterModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? query;

  @HiveField(2)
  String listingType; // buy, rent, commercial

  @HiveField(3)
  double minPrice;

  @HiveField(4)
  double maxPrice;

  @HiveField(5)
  int? minBedrooms;

  @HiveField(6)
  int? maxBedrooms;

  @HiveField(7)
  List<String> propertyTypes;

  @HiveField(8)
  bool mustHaveGarden;

  @HiveField(9)
  bool mustHaveParking;

  @HiveField(10)
  bool newBuildOnly;

  @HiveField(11)
  bool retirementOnly;

  @HiveField(12)
  int? maxCommuteMins;

  @HiveField(13)
  TransportMode? transportMode;

  @HiveField(14)
  String? keywords;

  @HiveField(15)
  String sortBy; // price_asc, price_desc, newest, most_relevant

  @HiveField(16)
  DateTime? addedSince;

  @HiveField(17)
  DateTime? savedAt;

  @HiveField(18)
  String? savedName;

  SearchFilterModel({
    required this.id,
    this.query,
    this.listingType = 'buy',
    this.minPrice = 0,
    this.maxPrice = 10000000,
    this.minBedrooms,
    this.maxBedrooms,
    this.propertyTypes = const [],
    this.mustHaveGarden = false,
    this.mustHaveParking = false,
    this.newBuildOnly = false,
    this.retirementOnly = false,
    this.maxCommuteMins,
    this.transportMode,
    this.keywords,
    this.sortBy = 'most_relevant',
    this.addedSince,
    this.savedAt,
    this.savedName,
  });

  bool get hasActiveFilters =>
      minPrice > 0 ||
      maxPrice < 10000000 ||
      minBedrooms != null ||
      propertyTypes.isNotEmpty ||
      mustHaveGarden ||
      mustHaveParking ||
      newBuildOnly ||
      retirementOnly ||
      maxCommuteMins != null ||
      (keywords?.isNotEmpty ?? false);

  SearchFilterModel copyWith({
    String? id,
    String? query,
    String? listingType,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    int? maxBedrooms,
    List<String>? propertyTypes,
    bool? mustHaveGarden,
    bool? mustHaveParking,
    bool? newBuildOnly,
    bool? retirementOnly,
    int? maxCommuteMins,
    TransportMode? transportMode,
    String? keywords,
    String? sortBy,
    DateTime? addedSince,
    DateTime? savedAt,
    String? savedName,
  }) {
    return SearchFilterModel(
      id: id ?? this.id,
      query: query ?? this.query,
      listingType: listingType ?? this.listingType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minBedrooms: minBedrooms ?? this.minBedrooms,
      maxBedrooms: maxBedrooms ?? this.maxBedrooms,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      mustHaveGarden: mustHaveGarden ?? this.mustHaveGarden,
      mustHaveParking: mustHaveParking ?? this.mustHaveParking,
      newBuildOnly: newBuildOnly ?? this.newBuildOnly,
      retirementOnly: retirementOnly ?? this.retirementOnly,
      maxCommuteMins: maxCommuteMins ?? this.maxCommuteMins,
      transportMode: transportMode ?? this.transportMode,
      keywords: keywords ?? this.keywords,
      sortBy: sortBy ?? this.sortBy,
      addedSince: addedSince ?? this.addedSince,
      savedAt: savedAt ?? this.savedAt,
      savedName: savedName ?? this.savedName,
    );
  }
}

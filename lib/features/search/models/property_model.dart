// lib/features/search/models/property_model.dart
import 'package:hive/hive.dart';

part 'property_model.g.dart';

@HiveType(typeId: 0)
enum PropertyType {
  @HiveField(0)
  detached,
  @HiveField(1)
  semiDetached,
  @HiveField(2)
  terraced,
  @HiveField(3)
  flat,
  @HiveField(4)
  bungalow,
  @HiveField(5)
  commercial,
  @HiveField(6)
  land,
}

@HiveType(typeId: 1)
enum ListingType {
  @HiveField(0)
  buy,
  @HiveField(1)
  rent,
  @HiveField(2)
  commercial,
}

@HiveType(typeId: 2)
class PropertyModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final bool isRental;

  @HiveField(4)
  final String address;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final String postcode;

  @HiveField(7)
  final double latitude;

  @HiveField(8)
  final double longitude;

  @HiveField(9)
  final int bedrooms;

  @HiveField(10)
  final int bathrooms;

  @HiveField(11)
  final int receptions;

  @HiveField(12)
  final double squareFeet;

  @HiveField(13)
  final String epcRating;

  @HiveField(14)
  final PropertyType propertyType;

  @HiveField(15)
  final ListingType listingType;

  @HiveField(16)
  final List<String> imageUrls;

  @HiveField(17)
  final String description;

  @HiveField(18)
  final List<String> keyFeatures;

  @HiveField(19)
  final bool hasGarden;

  @HiveField(20)
  final bool hasParking;

  @HiveField(21)
  final bool isNewBuild;

  @HiveField(22)
  final bool isRetirement;

  @HiveField(23)
  final DateTime addedDate;

  @HiveField(24)
  final String agentName;

  @HiveField(25)
  final String agentPhone;

  @HiveField(26)
  final String agentEmail;

  @HiveField(27)
  final String agentLogo;

  @HiveField(28)
  final bool isPremiumListing;

  @HiveField(29)
  final double? previousPrice;

  @HiveField(30)
  final String? floorplanUrl;

  PropertyModel({
    required this.id,
    required this.title,
    required this.price,
    required this.isRental,
    required this.address,
    required this.city,
    required this.postcode,
    required this.latitude,
    required this.longitude,
    required this.bedrooms,
    required this.bathrooms,
    required this.receptions,
    required this.squareFeet,
    required this.epcRating,
    required this.propertyType,
    required this.listingType,
    required this.imageUrls,
    required this.description,
    required this.keyFeatures,
    required this.hasGarden,
    required this.hasParking,
    required this.isNewBuild,
    required this.isRetirement,
    required this.addedDate,
    required this.agentName,
    required this.agentPhone,
    required this.agentEmail,
    required this.agentLogo,
    this.isPremiumListing = false,
    this.previousPrice,
    this.floorplanUrl,
  });

  bool get isPriceReduced => previousPrice != null && previousPrice! > price;

  double get priceReduction =>
      previousPrice != null ? previousPrice! - price : 0;

  String get propertyTypeLabel {
    switch (propertyType) {
      case PropertyType.detached:
        return 'Detached';
      case PropertyType.semiDetached:
        return 'Semi-Detached';
      case PropertyType.terraced:
        return 'Terraced';
      case PropertyType.flat:
        return 'Flat';
      case PropertyType.bungalow:
        return 'Bungalow';
      case PropertyType.commercial:
        return 'Commercial';
      case PropertyType.land:
        return 'Land';
    }
  }

  PropertyModel copyWith({
    String? id,
    String? title,
    double? price,
    bool? isRental,
    String? address,
    String? city,
    String? postcode,
    double? latitude,
    double? longitude,
    int? bedrooms,
    int? bathrooms,
    int? receptions,
    double? squareFeet,
    String? epcRating,
    PropertyType? propertyType,
    ListingType? listingType,
    List<String>? imageUrls,
    String? description,
    List<String>? keyFeatures,
    bool? hasGarden,
    bool? hasParking,
    bool? isNewBuild,
    bool? isRetirement,
    DateTime? addedDate,
    String? agentName,
    String? agentPhone,
    String? agentEmail,
    String? agentLogo,
    bool? isPremiumListing,
    double? previousPrice,
    String? floorplanUrl,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      isRental: isRental ?? this.isRental,
      address: address ?? this.address,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      receptions: receptions ?? this.receptions,
      squareFeet: squareFeet ?? this.squareFeet,
      epcRating: epcRating ?? this.epcRating,
      propertyType: propertyType ?? this.propertyType,
      listingType: listingType ?? this.listingType,
      imageUrls: imageUrls ?? this.imageUrls,
      description: description ?? this.description,
      keyFeatures: keyFeatures ?? this.keyFeatures,
      hasGarden: hasGarden ?? this.hasGarden,
      hasParking: hasParking ?? this.hasParking,
      isNewBuild: isNewBuild ?? this.isNewBuild,
      isRetirement: isRetirement ?? this.isRetirement,
      addedDate: addedDate ?? this.addedDate,
      agentName: agentName ?? this.agentName,
      agentPhone: agentPhone ?? this.agentPhone,
      agentEmail: agentEmail ?? this.agentEmail,
      agentLogo: agentLogo ?? this.agentLogo,
      isPremiumListing: isPremiumListing ?? this.isPremiumListing,
      previousPrice: previousPrice ?? this.previousPrice,
      floorplanUrl: floorplanUrl ?? this.floorplanUrl,
    );
  }
}

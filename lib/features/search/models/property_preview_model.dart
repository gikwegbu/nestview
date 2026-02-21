// lib/features/search/models/property_preview_model.dart
import 'package:hive/hive.dart';

part 'property_preview_model.g.dart';

@HiveType(typeId: 3)
class PropertyPreviewModel extends HiveObject {
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
  final String imageUrl;

  @HiveField(7)
  final int bedrooms;

  @HiveField(8)
  final int bathrooms;

  @HiveField(9)
  final String propertyType;

  @HiveField(10)
  final DateTime viewedAt;

  @HiveField(11)
  final double? previousPrice;

  PropertyPreviewModel({
    required this.id,
    required this.title,
    required this.price,
    required this.isRental,
    required this.address,
    required this.city,
    required this.imageUrl,
    required this.bedrooms,
    required this.bathrooms,
    required this.propertyType,
    required this.viewedAt,
    this.previousPrice,
  });

  bool get isPriceReduced => previousPrice != null && previousPrice! > price;
}

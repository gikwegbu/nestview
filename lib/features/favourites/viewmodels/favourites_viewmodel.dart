// lib/features/favourites/viewmodels/favourites_viewmodel.dart
// ignore_for_file: unused_field

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../search/models/property_model.dart';
import '../../search/models/property_preview_model.dart';
import '../../search/models/search_filter_model.dart';
import '../../../core/constants/app_constants.dart';

// ─── Favourites Provider (Hive-backed) ───────────────────────────────────────
final favouritesProvider =
    NotifierProvider<FavouritesNotifier, List<PropertyPreviewModel>>(
      FavouritesNotifier.new,
    );

class FavouritesNotifier extends Notifier<List<PropertyPreviewModel>> {
  late Box<dynamic> _box;

  @override
  List<PropertyPreviewModel> build() {
    _box = Hive.box(AppConstants.favouritesBox);
    final raw = _box.get('items');
    if (raw == null) return [];
    return List<Map>.from(raw).map(_fromMap).toList();
  }

  bool isFavourite(String propertyId) {
    return state.any((p) => p.id == propertyId);
  }

  void toggleFavourite(PropertyModel property) {
    if (isFavourite(property.id)) {
      removeFavourite(property.id);
    } else {
      addFavourite(property);
    }
  }

  void addFavourite(PropertyModel property) {
    final preview = PropertyPreviewModel(
      id: property.id,
      title: property.title,
      price: property.price,
      isRental: property.isRental,
      address: property.address,
      city: property.city,
      imageUrl: property.imageUrls.isNotEmpty ? property.imageUrls.first : '',
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
      propertyType: property.propertyTypeLabel,
      viewedAt: DateTime.now(),
      previousPrice: property.previousPrice,
    );
    if (!isFavourite(property.id)) {
      state = [preview, ...state];
      _persist();
    }
  }

  void removeFavourite(String propertyId) {
    state = state.where((p) => p.id != propertyId).toList();
    _persist();
  }

  void _persist() {
    _box.put('items', state.map(_toMap).toList());
  }

  Map<String, dynamic> _toMap(PropertyPreviewModel p) => {
    'id': p.id,
    'title': p.title,
    'price': p.price,
    'isRental': p.isRental,
    'address': p.address,
    'city': p.city,
    'imageUrl': p.imageUrl,
    'bedrooms': p.bedrooms,
    'bathrooms': p.bathrooms,
    'propertyType': p.propertyType,
    'viewedAt': p.viewedAt.toIso8601String(),
    'previousPrice': p.previousPrice,
  };

  PropertyPreviewModel _fromMap(Map map) => PropertyPreviewModel(
    id: map['id'] as String,
    title: map['title'] as String,
    price: (map['price'] as num).toDouble(),
    isRental: map['isRental'] as bool,
    address: map['address'] as String,
    city: map['city'] as String,
    imageUrl: map['imageUrl'] as String,
    bedrooms: map['bedrooms'] as int,
    bathrooms: map['bathrooms'] as int,
    propertyType: map['propertyType'] as String,
    viewedAt: DateTime.parse(map['viewedAt'] as String),
    previousPrice: (map['previousPrice'] as num?)?.toDouble(),
  );
}

// ─── Saved Searches Provider ──────────────────────────────────────────────────
final savedSearchesProvider =
    NotifierProvider<SavedSearchesNotifier, List<SearchFilterModel>>(
      SavedSearchesNotifier.new,
    );

class SavedSearchesNotifier extends Notifier<List<SearchFilterModel>> {
  late Box<dynamic> _box;

  @override
  List<SearchFilterModel> build() {
    _box = Hive.box(AppConstants.savedSearchesBox);
    return [];
  }

  void saveSearch(SearchFilterModel filter, String name) {
    final saved = filter.copyWith(savedAt: DateTime.now(), savedName: name);
    state = [saved, ...state];
  }

  void removeSearch(String id) {
    state = state.where((s) => s.id != id).toList();
  }
}

// ─── Recently Viewed Provider ─────────────────────────────────────────────────
final recentlyViewedProvider =
    NotifierProvider<RecentlyViewedNotifier, List<PropertyPreviewModel>>(
      RecentlyViewedNotifier.new,
    );

class RecentlyViewedNotifier extends Notifier<List<PropertyPreviewModel>> {
  late Box<dynamic> _box;

  @override
  List<PropertyPreviewModel> build() {
    _box = Hive.box(AppConstants.recentlyViewedBox);
    return [];
  }

  void addViewed(PropertyModel property) {
    final preview = PropertyPreviewModel(
      id: property.id,
      title: property.title,
      price: property.price,
      isRental: property.isRental,
      address: property.address,
      city: property.city,
      imageUrl: property.imageUrls.isNotEmpty ? property.imageUrls.first : '',
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
      propertyType: property.propertyTypeLabel,
      viewedAt: DateTime.now(),
      previousPrice: property.previousPrice,
    );
    final filtered = state.where((p) => p.id != property.id).toList();
    state = [
      preview,
      ...filtered,
    ].take(AppConstants.maxRecentlyViewed).toList();
  }

  void clear() => state = [];
}

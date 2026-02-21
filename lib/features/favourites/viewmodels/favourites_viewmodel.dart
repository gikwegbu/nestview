// lib/features/favourites/viewmodels/favourites_viewmodel.dart

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
  late Box<PropertyPreviewModel> _box;

  @override
  List<PropertyPreviewModel> build() {
    _box = Hive.box<PropertyPreviewModel>(AppConstants.favouritesBox);
    return _box.values.toList();
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
    if (isFavourite(property.id)) return;
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
    _box.put(property.id, preview);
    state = [preview, ...state];
  }

  void removeFavourite(String propertyId) {
    _box.delete(propertyId);
    state = state.where((p) => p.id != propertyId).toList();
  }
}

// ─── Saved Searches Provider ──────────────────────────────────────────────────
final savedSearchesProvider =
    NotifierProvider<SavedSearchesNotifier, List<SearchFilterModel>>(
      SavedSearchesNotifier.new,
    );

class SavedSearchesNotifier extends Notifier<List<SearchFilterModel>> {
  late Box<SearchFilterModel> _box;

  @override
  List<SearchFilterModel> build() {
    _box = Hive.box<SearchFilterModel>(AppConstants.savedSearchesBox);
    return _box.values.toList();
  }

  void saveSearch(SearchFilterModel filter, String name) {
    final saved = filter.copyWith(savedAt: DateTime.now(), savedName: name);
    _box.put(saved.id, saved);
    state = [saved, ...state];
  }

  void removeSearch(String id) {
    _box.delete(id);
    state = state.where((s) => s.id != id).toList();
  }
}

// ─── Recently Viewed Provider ─────────────────────────────────────────────────
final recentlyViewedProvider =
    NotifierProvider<RecentlyViewedNotifier, List<PropertyPreviewModel>>(
      RecentlyViewedNotifier.new,
    );

class RecentlyViewedNotifier extends Notifier<List<PropertyPreviewModel>> {
  late Box<PropertyPreviewModel> _box;

  @override
  List<PropertyPreviewModel> build() {
    _box = Hive.box<PropertyPreviewModel>(AppConstants.recentlyViewedBox);
    return _box.values.toList();
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
    _box.delete(property.id); // remove if already exists
    _box.put(property.id, preview);
    final updated = [
      preview,
      ...state.where((p) => p.id != property.id),
    ].take(AppConstants.maxRecentlyViewed).toList();
    // trim box if over limit
    if (_box.length > AppConstants.maxRecentlyViewed) {
      final keysToDelete = _box.keys
          .take(_box.length - AppConstants.maxRecentlyViewed)
          .toList();
      _box.deleteAll(keysToDelete);
    }
    state = updated;
  }

  void clear() {
    _box.clear();
    state = [];
  }
}
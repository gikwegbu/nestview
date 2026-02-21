// lib/features/search/viewmodels/search_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/property_model.dart';
import '../models/search_filter_model.dart';
import '../../../core/utils/mock_data.dart';

// ─── Search Query Provider ───────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

// ─── Listing Type Provider ────────────────────────────────────────────────────
final listingTypeProvider = StateProvider<String>((ref) => 'buy');

// ─── Search Filters Provider ──────────────────────────────────────────────────
final searchFiltersProvider =
    StateNotifierProvider<SearchFiltersNotifier, SearchFilterModel>(
      (ref) => SearchFiltersNotifier(),
    );

class SearchFiltersNotifier extends StateNotifier<SearchFilterModel> {
  SearchFiltersNotifier()
    : super(SearchFilterModel(id: 'current', listingType: 'buy'));

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updateListingType(String type) {
    state = state.copyWith(listingType: type);
  }

  void updatePriceRange(double min, double max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void updateBedrooms(int? min, int? max) {
    state = state.copyWith(minBedrooms: min, maxBedrooms: max);
  }

  void togglePropertyType(String type) {
    final current = List<String>.from(state.propertyTypes);
    if (current.contains(type)) {
      current.remove(type);
    } else {
      current.add(type);
    }
    state = state.copyWith(propertyTypes: current);
  }

  void setMustHaveGarden(bool value) =>
      state = state.copyWith(mustHaveGarden: value);
  void setMustHaveParking(bool value) =>
      state = state.copyWith(mustHaveParking: value);
  void setNewBuildOnly(bool value) =>
      state = state.copyWith(newBuildOnly: value);
  void setRetirementOnly(bool value) =>
      state = state.copyWith(retirementOnly: value);

  void updateCommute(int? mins, TransportMode? mode) {
    state = state.copyWith(maxCommuteMins: mins, transportMode: mode);
  }

  void setKeywords(String? keywords) =>
      state = state.copyWith(keywords: keywords);

  void updateSortBy(String sortBy) => state = state.copyWith(sortBy: sortBy);

  void clearAll() {
    state = SearchFilterModel(id: 'current', listingType: state.listingType);
  }
}

// ─── Search Results Provider ──────────────────────────────────────────────────
final searchResultsProvider =
    AsyncNotifierProvider<SearchResultsNotifier, List<PropertyModel>>(
      SearchResultsNotifier.new,
    );

class SearchResultsNotifier extends AsyncNotifier<List<PropertyModel>> {
  @override
  Future<List<PropertyModel>> build() async {
    final query = ref.watch(searchQueryProvider);
    final filters = ref.watch(searchFiltersProvider);
    return _fetchResults(query, filters);
  }

  Future<List<PropertyModel>> _fetchResults(
    String query,
    SearchFilterModel filters,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.search(
      query: query,
      listingType: filters.listingType,
      minPrice: filters.minPrice,
      maxPrice: filters.maxPrice,
      minBedrooms: filters.minBedrooms,
      propertyTypes: filters.propertyTypes,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final query = ref.read(searchQueryProvider);
    final filters = ref.read(searchFiltersProvider);
    state = await AsyncValue.guard(() => _fetchResults(query, filters));
  }
}

// ─── Featured Properties Provider ─────────────────────────────────────────────
final featuredPropertiesProvider =
    AsyncNotifierProvider<FeaturedPropertiesNotifier, List<PropertyModel>>(
      FeaturedPropertiesNotifier.new,
    );

class FeaturedPropertiesNotifier extends AsyncNotifier<List<PropertyModel>> {
  @override
  Future<List<PropertyModel>> build() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.properties.where((p) => p.isPremiumListing).toList();
  }
}

// ─── New to Market Provider ───────────────────────────────────────────────────
final newToMarketProvider =
    AsyncNotifierProvider<NewToMarketNotifier, List<PropertyModel>>(
      NewToMarketNotifier.new,
    );

class NewToMarketNotifier extends AsyncNotifier<List<PropertyModel>> {
  @override
  Future<List<PropertyModel>> build() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final sorted = List<PropertyModel>.from(MockData.properties)
      ..sort((a, b) => b.addedDate.compareTo(a.addedDate));
    return sorted.take(6).toList();
  }
}

// lib/features/map_search/viewmodels/map_search_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../search/models/property_model.dart';
import '../../../core/utils/mock_data.dart';
import '../../../core/constants/app_constants.dart';

class MapSearchState {
  final List<PropertyModel> properties;
  final PropertyModel? selectedProperty;
  final List<LatLng> drawnPolygon;
  final bool isDrawingMode;
  final bool isLoading;
  final CameraPosition cameraPosition;

  const MapSearchState({
    this.properties = const [],
    this.selectedProperty,
    this.drawnPolygon = const [],
    this.isDrawingMode = false,
    this.isLoading = false,
    this.cameraPosition = const CameraPosition(
      target: LatLng(
        AppConstants.defaultMapLatitude,
        AppConstants.defaultMapLongitude,
      ),
      zoom: AppConstants.defaultMapZoom,
    ),
  });

  MapSearchState copyWith({
    List<PropertyModel>? properties,
    PropertyModel? selectedProperty,
    bool clearSelected = false,
    List<LatLng>? drawnPolygon,
    bool? isDrawingMode,
    bool? isLoading,
    CameraPosition? cameraPosition,
  }) {
    return MapSearchState(
      properties: properties ?? this.properties,
      selectedProperty: clearSelected
          ? null
          : (selectedProperty ?? this.selectedProperty),
      drawnPolygon: drawnPolygon ?? this.drawnPolygon,
      isDrawingMode: isDrawingMode ?? this.isDrawingMode,
      isLoading: isLoading ?? this.isLoading,
      cameraPosition: cameraPosition ?? this.cameraPosition,
    );
  }
}

final mapSearchProvider =
    AsyncNotifierProvider<MapSearchNotifier, MapSearchState>(
      MapSearchNotifier.new,
    );

class MapSearchNotifier extends AsyncNotifier<MapSearchState> {
  @override
  Future<MapSearchState> build() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MapSearchState(properties: MockData.properties);
  }

  void selectProperty(PropertyModel? property) {
    final current = state.valueOrNull ?? const MapSearchState();
    state = AsyncValue.data(
      property == null
          ? current.copyWith(clearSelected: true)
          : current.copyWith(selectedProperty: property),
    );
  }

  void toggleDrawingMode() {
    final current = state.valueOrNull ?? const MapSearchState();
    state = AsyncValue.data(
      current.copyWith(isDrawingMode: !current.isDrawingMode, drawnPolygon: []),
    );
  }

  void addPolygonPoint(LatLng point) {
    final current = state.valueOrNull ?? const MapSearchState();
    final polygon = [...current.drawnPolygon, point];
    state = AsyncValue.data(current.copyWith(drawnPolygon: polygon));
  }

  void clearPolygon() {
    final current = state.valueOrNull ?? const MapSearchState();
    state = AsyncValue.data(current.copyWith(drawnPolygon: []));
  }

  void updateCamera(CameraPosition position) {
    final current = state.valueOrNull ?? const MapSearchState();
    state = AsyncValue.data(current.copyWith(cameraPosition: position));
  }
}

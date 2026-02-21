// lib/features/map_search/views/map_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewmodels/map_search_viewmodel.dart';
import '../../search/models/property_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_loading.dart';

class MapSearchScreen extends ConsumerStatefulWidget {
  final String initialQuery;

  const MapSearchScreen({super.key, required this.initialQuery});

  @override
  ConsumerState<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends ConsumerState<MapSearchScreen> {
  GoogleMapController? _mapController;

  Set<Marker> _buildMarkers(
    List<PropertyModel> properties,
    PropertyModel? selected,
  ) {
    return properties.map((p) {
      final isSelected = selected?.id == p.id;
      return Marker(
        markerId: MarkerId(p.id),
        position: LatLng(p.latitude, p.longitude),
        infoWindow: InfoWindow(title: CurrencyFormatter.formatCompact(p.price)),
        onTap: () {
          ref.read(mapSearchProvider.notifier).selectProperty(p);
        },
        icon: isSelected
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(mapSearchProvider);
    final notifier = ref.read(mapSearchProvider.notifier);

    return Scaffold(
      body: stateAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (mapState) {
          final markers = _buildMarkers(
            mapState.properties,
            mapState.selectedProperty,
          );

          return Stack(
            children: [
              // Full screen Google Map
              GoogleMap(
                initialCameraPosition: mapState.cameraPosition,
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (controller) => _mapController = controller,
                onCameraMove: (position) => notifier.updateCamera(position),
                onTap: mapState.isDrawingMode
                    ? (latlng) => notifier.addPolygonPoint(latlng)
                    : (_) => notifier.selectProperty(null),
                polygons: mapState.drawnPolygon.length > 2
                    ? {
                        Polygon(
                          polygonId: const PolygonId('search_area'),
                          points: mapState.drawnPolygon,
                          fillColor: AppColors.secondary.withOpacity(0.1),
                          strokeColor: AppColors.secondary,
                          strokeWidth: 2,
                        ),
                      }
                    : {},
                polylines:
                    mapState.isDrawingMode && mapState.drawnPolygon.isNotEmpty
                    ? {
                        Polyline(
                          polylineId: const PolylineId('drawing'),
                          points: mapState.drawnPolygon,
                          color: AppColors.secondary,
                          width: 3,
                        ),
                      }
                    : {},
              ),

              // Top bar
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    _MapButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.initialQuery.isEmpty
                                  ? 'Map Search'
                                  : widget.initialQuery,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Properties count badge
              Positioned(
                top: MediaQuery.of(context).padding.top + 72,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${mapState.properties.length} properties in area',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Right FABs
              Positioned(
                right: 16,
                bottom: mapState.selectedProperty != null ? 240 : 100,
                child: Column(
                  children: [
                    // Recenter
                    _MapButton(
                      icon: Icons.my_location_rounded,
                      onTap: () {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLng(
                            const LatLng(
                              AppConstants.defaultMapLatitude,
                              AppConstants.defaultMapLongitude,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    // Draw mode toggle
                    _MapButton(
                      icon: mapState.isDrawingMode
                          ? Icons.close_rounded
                          : Icons.draw_outlined,
                      backgroundColor: mapState.isDrawingMode
                          ? AppColors.secondary
                          : AppColors.surface,
                      iconColor: mapState.isDrawingMode
                          ? Colors.white
                          : AppColors.textPrimary,
                      onTap: () {
                        notifier.toggleDrawingMode();
                        if (mapState.isDrawingMode) notifier.clearPolygon();
                      },
                    ),
                    const SizedBox(height: 8),
                    // Filter FAB
                    _MapButton(icon: Icons.tune_rounded, onTap: () {}),
                  ],
                ),
              ),

              // Property preview card when marker selected
              if (mapState.selectedProperty != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _PropertyPreviewCard(
                    property: mapState.selectedProperty!,
                  ),
                ),

              // Draw mode instruction
              if (mapState.isDrawingMode)
                Positioned(
                  bottom: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Tap on the map to draw your search area',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const _MapButton({
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 22),
      ),
    );
  }
}

class _PropertyPreviewCard extends StatelessWidget {
  final PropertyModel property;

  const _PropertyPreviewCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 20)],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('${AppRoutes.propertyDetail}/${property.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: property.imageUrls.isNotEmpty
                    ? Image.network(
                        property.imageUrls.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: AppColors.background,
                        child: const Icon(Icons.home_outlined, size: 32),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CurrencyFormatter.format(property.price),
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      property.title,
                      style: AppTextStyles.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${property.bedrooms} bed · ${property.bathrooms} bath · ${property.propertyTypeLabel}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

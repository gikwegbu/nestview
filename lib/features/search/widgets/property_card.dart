// lib/features/search/widgets/property_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../models/property_model.dart';
import '../../favourites/viewmodels/favourites_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';

class PropertyCard extends ConsumerWidget {
  final PropertyModel property;
  final VoidCallback onTap;
  final int animationIndex;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favouritesProvider).any((p) => p.id == property.id);

    return GestureDetector(
      onTap: onTap,
      child:
          Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Gallery Preview
                    _PropertyImageSection(
                      property: property,
                      isFav: isFav,
                      ref: ref,
                    ),

                    // Property Info
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price + New Build badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  property.isRental
                                      ? CurrencyFormatter.formatPerMonth(
                                          property.price,
                                        )
                                      : CurrencyFormatter.format(
                                          property.price,
                                        ),
                                  style: AppTextStyles.priceDisplay.copyWith(
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              if (property.isNewBuild) _NewBadge(),
                            ],
                          ),

                          if (property.isPriceReduced) ...[
                            const SizedBox(height: 4),
                            _PriceReducedBadge(
                              reduction: property.priceReduction,
                            ),
                          ],

                          const SizedBox(height: 8),

                          // Title
                          Text(
                            property.title,
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          // Address
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${property.address}, ${property.postcode}',
                                  style: AppTextStyles.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),

                          // Stats Row
                          Row(
                            children: [
                              _StatChip(
                                icon: Icons.king_bed_outlined,
                                value: '${property.bedrooms}',
                                label: 'Beds',
                              ),
                              const SizedBox(width: 12),
                              _StatChip(
                                icon: Icons.bathtub_outlined,
                                value: '${property.bathrooms}',
                                label: 'Baths',
                              ),
                              const SizedBox(width: 12),
                              _StatChip(
                                icon: Icons.square_foot_rounded,
                                value: '${property.squareFeet.toInt()}',
                                label: 'sq ft',
                              ),
                              const Spacer(),
                              _EpcBadge(rating: property.epcRating),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (animationIndex * 80).ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
    );
  }
}

class _PropertyImageSection extends StatelessWidget {
  final PropertyModel property;
  final bool isFav;
  final WidgetRef ref;

  const _PropertyImageSection({
    required this.property,
    required this.isFav,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: property.imageUrls.isNotEmpty
                  ? property.imageUrls.first
                  : '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: const Color(0xFFE8E8E8),
                highlightColor: const Color(0xFFF5F5F5),
                child: Container(color: Colors.white),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.background,
                child: const Icon(
                  Icons.home_work_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),

        // Gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                gradient: AppColors.cardImageGradient,
              ),
            ),
          ),
        ),

        // Listing type badge
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: property.isRental ? AppColors.accent : AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              property.isRental ? 'TO RENT' : 'FOR SALE',
              style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
            ),
          ),
        ),

        // Favourite button
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                ref.read(favouritesProvider.notifier).toggleFavourite(property);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 8),
                  ],
                ),
                child: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  size: 20,
                  color: isFav ? AppColors.secondary : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),

        // Premium badge
        if (property.isPremiumListing)
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text('PREMIUM', style: AppTextStyles.badgePremium),
                ],
              ),
            ),
          ),

        // Image count
        if (property.imageUrls.length > 1)
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${property.imageUrls.length}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text('$value $label', style: AppTextStyles.labelMedium),
      ],
    );
  }
}

class _EpcBadge extends StatelessWidget {
  final String rating;

  const _EpcBadge({required this.rating});

  Color get _color {
    switch (rating) {
      case 'A':
        return const Color(0xFF008000);
      case 'B':
        return const Color(0xFF2ECC40);
      case 'C':
        return const Color(0xFF9ACD32);
      case 'D':
        return const Color(0xFFFFB347);
      case 'E':
        return const Color(0xFFFF8C00);
      case 'F':
        return const Color(0xFFFF4500);
      default:
        return const Color(0xFF8B0000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'EPC $rating',
        style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'NEW BUILD',
        style: AppTextStyles.badgePremium.copyWith(color: Colors.white),
      ),
    );
  }
}

class _PriceReducedBadge extends StatelessWidget {
  final double reduction;

  const _PriceReducedBadge({required this.reduction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.trending_down_rounded,
          size: 14,
          color: AppColors.success,
        ),
        const SizedBox(width: 4),
        Text(
          'Reduced by ${CurrencyFormatter.format(reduction)}',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

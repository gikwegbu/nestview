// lib/features/search/views/home_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/search_viewmodel.dart';
import '../widgets/property_card.dart';
import '../../favourites/viewmodels/favourites_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _HomeAppBar(),
          SliverToBoxAdapter(child: _SearchSection()),
          SliverToBoxAdapter(child: _FilterChips()),
          SliverToBoxAdapter(child: _FeaturedSection()),
          SliverToBoxAdapter(child: _RecentlyViewedSection()),
          SliverToBoxAdapter(child: _PopularAreasSection()),
          SliverToBoxAdapter(child: _NewToMarketSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/icons/app_icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(AppStrings.appName, style: AppTextStyles.headlineMedium),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.secondary.withOpacity(0.1),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 20,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find your\nperfect home',
            style: AppTextStyles.displayMedium,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 4),
          Text(
            'Search across England, Scotland & Wales',
            style: AppTextStyles.bodyMediumSecondary,
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => context.go(AppRoutes.searchResults),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.searchHint,
                    style: AppTextStyles.bodyMediumSecondary,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

class _FilterChips extends ConsumerWidget {
  static const _types = ['Buy', 'Rent', 'Commercial'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(listingTypeProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: _types.map((type) {
          final isSelected = selected == type.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => ref.read(listingTypeProvider.notifier).state =
                  type.toLowerCase(),
              child: AnimatedContainer(
                duration: AppConstants.shortAnimation,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  type,
                  style: AppTextStyles.chip.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FeaturedSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(featuredPropertiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: AppStrings.featuredProperties, showAll: true),
        async.when(
          loading: () => const SizedBox(
            height: 280,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          ),
          error: (e, _) => AppErrorWidget(message: e.toString()),
          data: (properties) => CarouselSlider(
            options: CarouselOptions(
              height: 400,
              viewportFraction: 0.88,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enlargeCenterPage: true,
              enlargeFactor: 0.1,
            ),
            items: properties.map((p) {
              return Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: PropertyCard(
                    property: p,
                    onTap: () =>
                        context.push('${AppRoutes.propertyDetail}/${p.id}'),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RecentlyViewedSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use sample data since nothing is viewed yet on first load
    final recentlyViewed = ref.watch(recentlyViewedProvider);
    if (recentlyViewed.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: AppStrings.recentlyViewed, showAll: false),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: recentlyViewed.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final property = recentlyViewed[index];
              return GestureDetector(
                onTap: () =>
                    context.push('${AppRoutes.propertyDetail}/${property.id}'),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: property.imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.isRental
                                  ? CurrencyFormatter.formatPerMonth(
                                      property.price,
                                    )
                                  : CurrencyFormatter.format(property.price),
                              style: AppTextStyles.headlineSmall.copyWith(
                                fontSize: 14,
                                color: AppColors.secondary,
                              ),
                            ),
                            Text(
                              '${property.bedrooms} bed ${property.propertyType}',
                              style: AppTextStyles.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PopularAreasSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final areas = AppConstants.popularCities.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: AppStrings.popularAreas, showAll: true),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemCount: areas.length,
          itemBuilder: (context, index) {
            final area = areas[index];
            return GestureDetector(
              onTap: () {
                context.go('${AppRoutes.searchResults}?q=${area['name']}');
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      area['name'] as String,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${area['properties']} properties',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: (index * 60).ms)
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            );
          },
        ),
      ],
    );
  }
}

class _NewToMarketSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(newToMarketProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: AppStrings.newToMarket, showAll: true),
        async.when(
          loading: () => const PropertyListShimmer(count: 3),
          error: (e, _) => AppErrorWidget(message: e.toString()),
          data: (properties) => ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: properties.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) => PropertyCard(
              property: properties[index],
              animationIndex: index,
              onTap: () => context.push(
                '${AppRoutes.propertyDetail}/${properties[index].id}',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool showAll;

  const _SectionHeader({required this.title, required this.showAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.headlineMedium),
          if (showAll)
            TextButton(onPressed: () {}, child: const Text('See all')),
        ],
      ),
    );
  }
}

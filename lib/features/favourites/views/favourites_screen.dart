// lib/features/favourites/views/favourites_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodels/favourites_viewmodel.dart';
import '../../search/models/property_preview_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_error.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favourites = ref.watch(favouritesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.navFavourites,
          style: AppTextStyles.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.list_rounded : Icons.grid_view_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          if (favourites.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.share_outlined,
                color: AppColors.textPrimary,
              ),
              onPressed: () {
                final text = favourites
                    .map(
                      (p) =>
                          '${p.title} — ${CurrencyFormatter.format(p.price)}',
                    )
                    .join('\n');
                Share.share('My saved properties:\n\n$text');
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.secondary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.secondary,
          tabs: const [
            Tab(text: 'Properties'),
            Tab(text: 'Saved Searches'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Properties Tab
          _FavouritePropertiesTab(
            favourites: favourites,
            isGridView: _isGridView,
          ),
          // Saved Searches Tab
          _SavedSearchesTab(),
        ],
      ),
    );
  }
}

class _FavouritePropertiesTab extends ConsumerWidget {
  final List<PropertyPreviewModel> favourites;
  final bool isGridView;

  const _FavouritePropertiesTab({
    required this.favourites,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (favourites.isEmpty) {
      return AppEmptyWidget(
        title: AppStrings.noFavourites,
        subtitle: AppStrings.noFavouritesSubtitle,
        icon: Icons.favorite_outline_rounded,
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('Browse Properties'),
        ),
      );
    }

    return isGridView
        ? GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: favourites.length,
            itemBuilder: (context, index) => _FavouriteGridCard(
              property: favourites[index],
              animationIndex: index,
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: favourites.length,
            itemBuilder: (context, index) => Dismissible(
              key: Key(favourites[index].id),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              onDismissed: (_) {
                ref
                    .read(favouritesProvider.notifier)
                    .removeFavourite(favourites[index].id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Property removed from saved'),
                    action: SnackBarAction(label: 'Undo', onPressed: () {}),
                  ),
                );
              },
              child: _FavouriteListCard(
                property: favourites[index],
                animationIndex: index,
              ),
            ),
          );
  }
}

class _FavouriteListCard extends StatelessWidget {
  final PropertyPreviewModel property;
  final int animationIndex;

  const _FavouriteListCard({
    required this.property,
    required this.animationIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.propertyDetail}/${property.id}'),
      child:
          Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 12),
                  ],
                ),
                child: Row(
                  children: [
                    // Thumbnail
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(16),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: property.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (property.isPriceReduced)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.trending_down_rounded,
                                    size: 14,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Price dropped!',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            Text(
                              property.isRental
                                  ? CurrencyFormatter.formatPerMonth(
                                      property.price,
                                    )
                                  : CurrencyFormatter.format(property.price),
                              style: AppTextStyles.headlineSmall.copyWith(
                                fontSize: 17,
                                color: AppColors.secondary,
                              ),
                            ),
                            Text(
                              property.title,
                              style: AppTextStyles.labelLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${property.bedrooms} bed ${property.propertyType} • ${property.city}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (animationIndex * 50).ms)
              .fadeIn(duration: 300.ms)
              .slideX(begin: 0.2),
    );
  }
}

class _FavouriteGridCard extends StatelessWidget {
  final PropertyPreviewModel property;
  final int animationIndex;

  const _FavouriteGridCard({
    required this.property,
    required this.animationIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.propertyDetail}/${property.id}'),
      child:
          Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 12),
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
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (property.isPriceReduced)
                            Text(
                              '↓ Price Drop',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          Text(
                            CurrencyFormatter.format(property.price),
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontSize: 14,
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            '${property.bedrooms}bd • ${property.propertyType}',
                            style: AppTextStyles.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (animationIndex * 60).ms)
              .fadeIn(duration: 300.ms)
              .scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

class _SavedSearchesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searches = ref.watch(savedSearchesProvider);

    if (searches.isEmpty) {
      return AppEmptyWidget(
        title: 'No saved searches',
        subtitle: 'Save your searches to get notified of new listings.',
        icon: Icons.manage_search_rounded,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: searches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final search = searches[index];
        return ListTile(
          tileColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.search_rounded, color: AppColors.secondary),
          ),
          title: Text(
            search.savedName ?? search.query ?? 'Saved Search',
            style: AppTextStyles.labelLarge,
          ),
          subtitle: Text(
            '${search.listingType.toUpperCase()} • ${search.propertyTypes.isEmpty ? "All types" : search.propertyTypes.join(", ")}',
            style: AppTextStyles.bodySmall,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.textSecondary,
            ),
            onPressed: () => ref
                .read(savedSearchesProvider.notifier)
                .removeSearch(search.id),
          ),
          onTap: () => context.go(
            '${AppRoutes.searchResults}?q=${search.query ?? ""}&type=${search.listingType}',
          ),
        );
      },
    );
  }
}

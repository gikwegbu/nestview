// lib/features/search/views/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/search_viewmodel.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String query;
  final String listingType;

  const SearchResultsScreen({
    super.key,
    required this.query,
    required this.listingType,
  });

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  bool _isMapView = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    if (widget.query.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchQueryProvider.notifier).state = widget.query;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider);
    final filters = ref.watch(searchFiltersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: _SearchBar(controller: _searchController, ref: ref),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: _FilterBar(
                onFilter: _showFilterSheet,
                onSort: _showSortSheet,
                isMapView: _isMapView,
                onToggleView: () => setState(() => _isMapView = !_isMapView),
                hasActiveFilters: filters.hasActiveFilters,
              ),
            ),
          ),
        ],
        body: resultsAsync.when(
          loading: () => const PropertyListShimmer(),
          error: (e, _) => AppErrorWidget(
            message: e.toString(),
            onRetry: () => ref.refresh(searchResultsProvider),
          ),
          data: (properties) {
            if (properties.isEmpty) {
              return AppEmptyWidget(
                title: AppStrings.noResults,
                subtitle: AppStrings.noResultsSubtitle,
                icon: Icons.search_off_rounded,
                action: FilledButton(
                  onPressed: _showFilterSheet,
                  child: const Text('Adjust Filters'),
                ),
              );
            }

            return Column(
              children: [
                // Results count header
                Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${properties.length.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} properties found',
                        style: AppTextStyles.labelLarge,
                      ),
                    ],
                  ),
                ),

                // Results list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
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
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('${AppRoutes.mapSearch}?q=${_searchController.text}'),
        child: const Icon(Icons.map_outlined),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final WidgetRef ref;

  const _SearchBar({required this.controller, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) =>
            ref.read(searchQueryProvider.notifier).state = value,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppStrings.searchHint,
          hintStyle: AppTextStyles.bodyMediumSecondary,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    controller.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final VoidCallback onFilter;
  final VoidCallback onSort;
  final bool isMapView;
  final VoidCallback onToggleView;
  final bool hasActiveFilters;

  const _FilterBar({
    required this.onFilter,
    required this.onSort,
    required this.isMapView,
    required this.onToggleView,
    required this.hasActiveFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          // Filter button
          _FilterChipButton(
            icon: Icons.tune_rounded,
            label: 'Filter',
            hasBadge: hasActiveFilters,
            onTap: onFilter,
          ),
          const SizedBox(width: 8),
          _FilterChipButton(
            icon: Icons.sort_rounded,
            label: 'Sort',
            onTap: onSort,
          ),
          const Spacer(),
          // View toggle
          GestureDetector(
            onTap: onToggleView,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    isMapView ? Icons.list_rounded : Icons.map_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isMapView ? 'List' : 'Map',
                    style: AppTextStyles.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool hasBadge;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.icon,
    required this.label,
    this.hasBadge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.textPrimary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (hasBadge)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SortBottomSheet extends ConsumerWidget {
  static const _options = [
    ('most_relevant', 'Most Relevant', Icons.star_rounded),
    ('newest', 'Newest First', Icons.calendar_today_rounded),
    ('price_asc', 'Price: Low to High', Icons.arrow_upward_rounded),
    ('price_desc', 'Price: High to Low', Icons.arrow_downward_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(searchFiltersProvider).sortBy;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Sort By', style: AppTextStyles.headlineMedium),
            ),
            const SizedBox(height: 16),
            ..._options.map((opt) {
              final isSelected = current == opt.$1;
              return ListTile(
                leading: Icon(
                  opt.$3,
                  color: isSelected
                      ? AppColors.secondary
                      : AppColors.textSecondary,
                ),
                title: Text(
                  opt.$2,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.secondary,
                      )
                    : null,
                onTap: () {
                  ref.read(searchFiltersProvider.notifier).updateSortBy(opt.$1);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

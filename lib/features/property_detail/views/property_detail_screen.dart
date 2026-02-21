// lib/features/property_detail/views/property_detail_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/property_detail_viewmodel.dart';
import '../../favourites/viewmodels/favourites_viewmodel.dart';
import '../../search/models/property_model.dart';
import '../../mortgage_calculator/viewmodels/mortgage_calculator_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';

class PropertyDetailScreen extends HookConsumerWidget {
  final String propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyDetailProvider(propertyId));

    return propertyAsync.when(
      loading: () => const Scaffold(body: AppLoadingWidget()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.refresh(propertyDetailProvider(propertyId)),
        ),
      ),
      data: (property) => _PropertyDetailContent(property: property),
    );
  }
}

class _PropertyDetailContent extends HookConsumerWidget {
  final PropertyModel property;

  const _PropertyDetailContent({required this.property});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentImage = useState(0);
    final currentTab = useState(0);
    final isDescExpanded = useState(false);
    final isFav = ref.watch(favouritesProvider).any((p) => p.id == property.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Image Gallery Hero
              SliverToBoxAdapter(
                child: _ImageGallery(
                  imageUrls: property.imageUrls,
                  currentIndex: currentImage.value,
                  onPageChanged: (i) => currentImage.value = i,
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  transform: Matrix4.translationValues(0, -24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Price
                            Text(
                              property.isRental
                                  ? CurrencyFormatter.formatPerMonth(
                                      property.price,
                                    )
                                  : CurrencyFormatter.format(property.price),
                              style: AppTextStyles.priceDisplay,
                            ),
                            if (property.isPriceReduced) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.trending_down_rounded,
                                    size: 16,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Reduced from ${CurrencyFormatter.format(property.previousPrice!)}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),

                            // Title
                            Text(
                              property.title,
                              style: AppTextStyles.headlineLarge,
                            ),
                            const SizedBox(height: 8),

                            // Address + Map link
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${property.address}, ${property.city} ${property.postcode}',
                                    style: AppTextStyles.bodyMediumSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    AppStrings.viewOnMap,
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Summary Chips
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _SummaryChip(
                                  icon: Icons.king_bed_outlined,
                                  label:
                                      '${property.bedrooms} ${AppStrings.beds}',
                                ),
                                _SummaryChip(
                                  icon: Icons.bathtub_outlined,
                                  label:
                                      '${property.bathrooms} ${AppStrings.baths}',
                                ),
                                _SummaryChip(
                                  icon: Icons.living_outlined,
                                  label: '${property.receptions} Receptions',
                                ),
                                _SummaryChip(
                                  icon: Icons.square_foot_rounded,
                                  label:
                                      '${property.squareFeet.toInt()} ${AppStrings.sqFt}',
                                ),
                                _SummaryChip(
                                  icon: Icons.eco_outlined,
                                  label: 'EPC ${property.epcRating}',
                                ),
                                _SummaryChip(
                                  icon: Icons.home_work_outlined,
                                  label: property.propertyTypeLabel,
                                ),
                                if (property.hasGarden)
                                  _SummaryChip(
                                    icon: Icons.yard_outlined,
                                    label: 'Garden',
                                  ),
                                if (property.hasParking)
                                  _SummaryChip(
                                    icon: Icons.garage_outlined,
                                    label: 'Parking',
                                  ),
                              ],
                            ),

                            const SizedBox(height: 24),
                            const Divider(),
                          ],
                        ),
                      ),

                      // Tabs
                      _PropertyTabs(
                        currentTab: currentTab.value,
                        onTabChanged: (i) => currentTab.value = i,
                      ),

                      const SizedBox(height: 16),

                      // Tab Content
                      _PropertyTabContent(
                        property: property,
                        currentTab: currentTab.value,
                        isDescExpanded: isDescExpanded.value,
                        onToggleDesc: () =>
                            isDescExpanded.value = !isDescExpanded.value,
                      ),

                      // Agent Card
                      if (currentTab.value == 0) ...[
                        const SizedBox(height: 8),
                        _AgentCard(property: property),
                      ],

                      // Bottom spacer for sticky CTA
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating back + action buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FloatingIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => context.pop(),
                ),
                Row(
                  children: [
                    _FloatingIconButton(
                      icon: Icons.share_outlined,
                      onTap: () => Share.share(
                        'Check out this property: ${property.title} — ${CurrencyFormatter.format(property.price)}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FloatingIconButton(
                      icon: isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      iconColor: isFav
                          ? AppColors.secondary
                          : AppColors.textPrimary,
                      onTap: () => ref
                          .read(favouritesProvider.notifier)
                          .toggleFavourite(property),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // Sticky bottom CTA
      bottomNavigationBar:
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: FilledButton.icon(
              onPressed: () {
                ref
                    .read(mortgageCalculatorProvider.notifier)
                    .prefillFromProperty(property.price);
                context.push(
                  '${AppRoutes.mortgageCalculator}?price=${property.price}',
                );
              },
              icon: const Icon(Icons.calculate_rounded),
              label: Text(AppStrings.calculateMortgage),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ).animate().slideY(
            begin: 1,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _FloatingIconButton({
    required this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: iconColor ?? AppColors.textPrimary),
      ),
    );
  }
}

class _ImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _ImageGallery({
    required this.imageUrls,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  void _openFullscreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenGallery(
          imageUrls: widget.imageUrls,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.45;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: widget.onPageChanged,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _openFullscreen(index),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrls[index],
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.background),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.background,
                  child: const Icon(
                    Icons.home_work_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),

          // Page indicator
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: widget.currentIndex == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: widget.currentIndex == i
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),

          // Photo counter
          Positioned(
            bottom: 36,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${widget.currentIndex + 1}/${widget.imageUrls.length}',
                style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullscreenGallery extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _FullscreenGallery({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) => PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(imageUrls[index]),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
        ),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SummaryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}

class _PropertyTabs extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onTabChanged;

  const _PropertyTabs({required this.currentTab, required this.onTabChanged});

  static const _tabs = ['Overview', 'Floorplan', 'Nearby'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final isSelected = entry.key == currentTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)]
                      : [],
                ),
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

class _PropertyTabContent extends StatelessWidget {
  final PropertyModel property;
  final int currentTab;
  final bool isDescExpanded;
  final VoidCallback onToggleDesc;

  const _PropertyTabContent({
    required this.property,
    required this.currentTab,
    required this.isDescExpanded,
    required this.onToggleDesc,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentTab) {
      case 0:
        return _OverviewTab(
          property: property,
          isExpanded: isDescExpanded,
          onToggle: onToggleDesc,
        );
      case 1:
        return _FloorplanTab(floorplanUrl: property.floorplanUrl);
      case 2:
        return _NearbyTab(property: property);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _OverviewTab extends StatelessWidget {
  final PropertyModel property;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _OverviewTab({
    required this.property,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Features
          Text(AppStrings.keyFeatures, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ...property.keyFeatures.map(
            (feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(feature, style: AppTextStyles.bodyMedium),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Text(AppStrings.description, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          AnimatedCrossFade(
            firstChild: Text(
              property.description,
              style: AppTextStyles.bodyMedium,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              property.description,
              style: AppTextStyles.bodyMedium,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          TextButton(
            onPressed: onToggle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isExpanded ? AppStrings.readLess : AppStrings.readMore),
                const SizedBox(width: 4),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloorplanTab extends StatelessWidget {
  final String? floorplanUrl;

  const _FloorplanTab({this.floorplanUrl});

  @override
  Widget build(BuildContext context) {
    if (floorplanUrl == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(
                Icons.architecture_rounded,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No floorplan available',
                style: AppTextStyles.bodyMediumSecondary,
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(imageUrl: floorplanUrl!, fit: BoxFit.contain),
      ),
    );
  }
}

class _NearbyTab extends StatelessWidget {
  final PropertyModel property;

  const _NearbyTab({required this.property});

  @override
  Widget build(BuildContext context) {
    final amenities = [
      _AmenityItem(Icons.school_outlined, 'Primary School', '0.3 mi', '4.2⭐'),
      _AmenityItem(Icons.train_outlined, 'Train Station', '0.5 mi', '2 min'),
      _AmenityItem(
        Icons.local_grocery_store_outlined,
        'Supermarket',
        '0.2 mi',
        '5 min',
      ),
      _AmenityItem(
        Icons.local_hospital_outlined,
        'Hospital',
        '1.1 mi',
        '12 min',
      ),
      _AmenityItem(Icons.park_outlined, 'Park', '0.4 mi', '7 min'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: amenities
            .map(
              (a) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(a.icon, color: AppColors.secondary, size: 20),
                ),
                title: Text(a.label, style: AppTextStyles.labelLarge),
                subtitle: Text(a.distance, style: AppTextStyles.bodySmall),
                trailing: Text(
                  a.extra,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _AmenityItem {
  final IconData icon;
  final String label;
  final String distance;
  final String extra;

  const _AmenityItem(this.icon, this.label, this.distance, this.extra);
}

class _AgentCard extends StatelessWidget {
  final PropertyModel property;

  const _AgentCard({required this.property});

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  Future<void> _email(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  Future<void> _whatsapp(String phone) async {
    final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.contactAgent, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  property.agentName.substring(0, 1),
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(property.agentName, style: AppTextStyles.labelLarge),
                    Text('Listing Agent', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ContactButton(
                  icon: Icons.phone_outlined,
                  label: 'Call',
                  color: AppColors.success,
                  onTap: () => _call(property.agentPhone),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ContactButton(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  color: AppColors.primary,
                  onTap: () => _email(property.agentEmail),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ContactButton(
                  icon: Icons.chat_outlined,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () => _whatsapp(property.agentPhone),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

// lib/features/profile/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../../favourites/viewmodels/favourites_viewmodel.dart';
import '../../mortgage_calculator/viewmodels/mortgage_calculator_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(profileProvider);
    final savedCalcs = ref.watch(savedCalculationsProvider);
    final recentlyViewed = ref.watch(recentlyViewedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.profile, style: AppTextStyles.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
            onPressed: () => _showEditNameDialog(context, ref, prefs.name),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    (prefs.name?.isNotEmpty ?? false)
                        ? prefs.name![0].toUpperCase()
                        : 'U',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prefs.name ?? 'Your Profile',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        prefs.isFirstTimeBuyer
                            ? 'First-Time Buyer'
                            : 'Property Buyer',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    prefs.preferredListingType.toUpperCase(),
                    style: AppTextStyles.badgePremium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 24),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.favorite_outline_rounded,
                  label: 'Saved',
                  value: '${ref.watch(favouritesProvider).length}',
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.calculate_outlined,
                  label: 'Calculations',
                  value: '${savedCalcs.length}',
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.history_rounded,
                  label: 'Viewed',
                  value: '${recentlyViewed.length}',
                  color: AppColors.success,
                ),
              ),
            ],
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: 24),

          // Buyer Preferences
          _ProfileSection(
            title: AppStrings.buyerPreferences,
            icon: Icons.tune_rounded,
            children: [
              _PreferenceRow(
                label: 'Budget Range',
                value: '${CurrencyFormatter.formatCompact(prefs.minBudget)} – '
                    '${CurrencyFormatter.formatCompact(prefs.maxBudget)}',
              ),
              _PreferenceRow(
                label: 'Min Bedrooms',
                value: '${prefs.minBedrooms} bedroom(s)',
              ),
              _PreferenceRow(
                label: 'Listing Type',
                value: prefs.preferredListingType.toUpperCase(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('First-Time Buyer', style: AppTextStyles.bodyMedium),
                  Switch(
                    value: prefs.isFirstTimeBuyer,
                    onChanged: (v) =>
                        ref.read(profileProvider.notifier).setFirstTimeBuyer(v),
                  ),
                ],
              ),
            ],
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Notification Settings
          _ProfileSection(
            title: AppStrings.notifications,
            icon: Icons.notifications_outlined,
            children: [
              _SwitchRow(
                label: '💰 Price Drop Alerts',
                value: prefs.priceDropAlerts,
                onChanged: (v) =>
                    ref.read(profileProvider.notifier).togglePriceDropAlerts(v),
              ),
              _SwitchRow(
                label: '🏠 New Listings',
                value: prefs.newListingAlerts,
                onChanged: (v) => ref
                    .read(profileProvider.notifier)
                    .toggleNewListingAlerts(v),
              ),
              _SwitchRow(
                label: '🔍 Saved Search Alerts',
                value: prefs.savedSearchAlerts,
                onChanged: (v) => ref
                    .read(profileProvider.notifier)
                    .toggleNewListingAlerts(v),
              ),
            ],
          ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Saved Calculations
          if (savedCalcs.isNotEmpty) ...[
            _ProfileSection(
              title: AppStrings.savedCalculations,
              icon: Icons.calculate_rounded,
              children: savedCalcs
                  .take(3)
                  .map((calc) => _CalcRow(calc: calc))
                  .toList(),
            ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 16),
          ],

          // App info
          _ProfileSection(
            title: 'About',
            icon: Icons.info_outline_rounded,
            children: [
              _InfoRow(label: 'App', value: 'NestView v1.0.0'),
              _InfoRow(label: 'Region', value: 'United Kingdom'),
              _InfoRow(
                label: 'Data',
                value: 'Properties across England, Scotland & Wales',
              ),
            ],
          ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }

  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String? current,
  ) {
    final controller = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Your Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(profileProvider.notifier).updateName(controller.text);
              Navigator.pop(
                  dialogContext); // Keep dialog open for quick edits, or remove to close after saving
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineLarge.copyWith(
              color: color,
              fontSize: 22,
            ),
          ),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ProfileSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.headlineSmall),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PreferenceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMediumSecondary),
          Text(value, style: AppTextStyles.labelLarge),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _CalcRow extends StatelessWidget {
  final dynamic calc;

  const _CalcRow({required this.calc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CurrencyFormatter.format(calc.propertyPrice),
                style: AppTextStyles.labelLarge,
              ),
              Text(
                '${calc.termYears} yr · ${calc.interestRate}% rate',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          Text(
            '${CurrencyFormatter.format(calc.monthlyPayment)}/mo',
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: 15,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: AppTextStyles.bodyMediumSecondary),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

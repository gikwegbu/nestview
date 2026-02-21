// lib/features/search/widgets/filter_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/search_viewmodel.dart';
import '../models/search_filter_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late SearchFilterModel _localFilter;

  @override
  void initState() {
    super.initState();
    _localFilter = ref.read(searchFiltersProvider);
  }

  static const _bedroomOptions = ['Studio', '1', '2', '3', '4', '5+'];
  static const _propertyTypes = [
    'Detached',
    'Semi-Detached',
    'Terraced',
    'Flat',
    'Bungalow',
  ];
  static const _transportModes = [
    (TransportMode.walking, '🚶 Walk'),
    (TransportMode.cycling, '🚴 Cycle'),
    (TransportMode.driving, '🚗 Drive'),
    (TransportMode.transit, '🚌 Transit'),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle + Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Filters', style: AppTextStyles.headlineMedium),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _localFilter = SearchFilterModel(
                                id: 'current',
                                listingType: _localFilter.listingType,
                              );
                            });
                          },
                          child: Text(
                            'Clear All',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  children: [
                    // Price Range
                    _FilterSection(
                      title: 'Price Range',
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                CurrencyFormatter.formatCompact(
                                  _localFilter.minPrice,
                                ),
                                style: AppTextStyles.labelLarge,
                              ),
                              Text(
                                _localFilter.maxPrice >= 10000000
                                    ? 'No max'
                                    : CurrencyFormatter.formatCompact(
                                        _localFilter.maxPrice,
                                      ),
                                style: AppTextStyles.labelLarge,
                              ),
                            ],
                          ),
                          RangeSlider(
                            values: RangeValues(
                              _localFilter.minPrice,
                              _localFilter.maxPrice,
                            ),
                            min: 0,
                            max: 5000000,
                            divisions: 100,
                            labels: RangeLabels(
                              CurrencyFormatter.formatCompact(
                                _localFilter.minPrice,
                              ),
                              CurrencyFormatter.formatCompact(
                                _localFilter.maxPrice,
                              ),
                            ),
                            onChanged: (values) => setState(() {
                              _localFilter = _localFilter.copyWith(
                                minPrice: values.start,
                                maxPrice: values.end,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    // Bedrooms
                    _FilterSection(
                      title: 'Bedrooms',
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _bedroomOptions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final label = entry.value;
                          final isSelected = index == 0
                              ? _localFilter.minBedrooms == null ||
                                    _localFilter.minBedrooms == 0
                              : _localFilter.minBedrooms == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _localFilter = _localFilter.copyWith(
                                  minBedrooms: index == 0 ? null : index,
                                );
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.secondary
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.secondary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                label,
                                style: AppTextStyles.chip.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Property Types
                    _FilterSection(
                      title: 'Property Type',
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _propertyTypes.map((type) {
                          final isSelected = _localFilter.propertyTypes
                              .contains(type);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                final types = List<String>.from(
                                  _localFilter.propertyTypes,
                                );
                                if (isSelected) {
                                  types.remove(type);
                                } else {
                                  types.add(type);
                                }
                                _localFilter = _localFilter.copyWith(
                                  propertyTypes: types,
                                );
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                type,
                                style: AppTextStyles.chip.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Must Haves
                    _FilterSection(
                      title: 'Must Haves',
                      child: Column(
                        children: [
                          _SwitchRow(
                            label: '🌳 Garden',
                            value: _localFilter.mustHaveGarden,
                            onChanged: (v) => setState(
                              () => _localFilter = _localFilter.copyWith(
                                mustHaveGarden: v,
                              ),
                            ),
                          ),
                          _SwitchRow(
                            label: '🚗 Parking',
                            value: _localFilter.mustHaveParking,
                            onChanged: (v) => setState(
                              () => _localFilter = _localFilter.copyWith(
                                mustHaveParking: v,
                              ),
                            ),
                          ),
                          _SwitchRow(
                            label: '🏗 New Build',
                            value: _localFilter.newBuildOnly,
                            onChanged: (v) => setState(
                              () => _localFilter = _localFilter.copyWith(
                                newBuildOnly: v,
                              ),
                            ),
                          ),
                          _SwitchRow(
                            label: '👴 Retirement',
                            value: _localFilter.retirementOnly,
                            onChanged: (v) => setState(
                              () => _localFilter = _localFilter.copyWith(
                                retirementOnly: v,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Max Commute
                    _FilterSection(
                      title: 'Max Commute',
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _localFilter.maxCommuteMins == null
                                    ? 'Any'
                                    : '${_localFilter.maxCommuteMins} mins',
                                style: AppTextStyles.labelLarge,
                              ),
                            ],
                          ),
                          Slider(
                            value: (_localFilter.maxCommuteMins ?? 0)
                                .toDouble(),
                            min: 0,
                            max: 120,
                            divisions: 12,
                            label: _localFilter.maxCommuteMins == null
                                ? 'Any'
                                : '${_localFilter.maxCommuteMins} min',
                            onChanged: (value) => setState(() {
                              _localFilter = _localFilter.copyWith(
                                maxCommuteMins: value == 0
                                    ? null
                                    : value.toInt(),
                              );
                            }),
                          ),
                          if (_localFilter.maxCommuteMins != null) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: _transportModes.map((mode) {
                                final isSelected =
                                    _localFilter.transportMode == mode.$1;
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    _localFilter = _localFilter.copyWith(
                                      transportMode: mode.$1,
                                    );
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.secondary
                                          : AppColors.background,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.secondary
                                            : AppColors.border,
                                      ),
                                    ),
                                    child: Text(
                                      mode.$2,
                                      style: AppTextStyles.chip.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Keywords
                    _FilterSection(
                      title: 'Keywords',
                      child: TextField(
                        controller: TextEditingController(
                          text: _localFilter.keywords,
                        ),
                        onChanged: (v) => setState(() {
                          _localFilter = _localFilter.copyWith(
                            keywords: v.isEmpty ? null : v,
                          );
                        }),
                        style: AppTextStyles.bodyMedium,
                        decoration: const InputDecoration(
                          hintText: 'e.g. fireplace, sea view...',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Apply / Cancel
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: () {
                          ref
                              .read(searchFiltersProvider.notifier)
                              .updatePriceRange(
                                _localFilter.minPrice,
                                _localFilter.maxPrice,
                              );
                          Navigator.pop(context);
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          child,
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

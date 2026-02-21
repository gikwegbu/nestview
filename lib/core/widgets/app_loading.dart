// lib/core/widgets/app_loading.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

/// Full screen loading indicator
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.secondary),
    );
  }
}

/// Shimmer card placeholder for property listings
class PropertyCardShimmer extends StatelessWidget {
  const PropertyCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 20, width: 200, color: Colors.white),
          const SizedBox(height: 8),
          Container(height: 16, width: 140, color: Colors.white),
          const SizedBox(height: 8),
          Container(height: 14, width: 180, color: Colors.white),
        ],
      ),
    );
  }
}

/// Shimmer list of property cards
class PropertyListShimmer extends StatelessWidget {
  final int count;
  const PropertyListShimmer({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (_, __) => const PropertyCardShimmer(),
    );
  }
}

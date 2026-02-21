// lib/features/area_insights/views/area_insights_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

class AreaInsightsScreen extends StatelessWidget {
  final String area;

  const AreaInsightsScreen({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.areaInsights, style: AppTextStyles.headlineMedium),
            Text(area, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          // Average Prices Bar Chart
          _InsightCard(
            title: AppStrings.avgPrices,
            subtitle: 'By property type',
            child: SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 700000,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 100000,
                        getTitlesWidget: (v, _) => Text(
                          '£${(v / 1000).toInt()}k',
                          style: AppTextStyles.labelSmall,
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          const types = [
                            'Det.',
                            'Semi',
                            'Ter.',
                            'Flat',
                            'Bung.',
                          ];
                          return Text(
                            types[v.toInt()],
                            style: AppTextStyles.labelSmall,
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _barGroup(0, 550000, AppColors.detached),
                    _barGroup(1, 380000, AppColors.semiDetached),
                    _barGroup(2, 310000, AppColors.terraced),
                    _barGroup(3, 280000, AppColors.flat),
                    _barGroup(4, 345000, AppColors.bungalow),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Price Trend Line Chart
          _InsightCard(
            title: AppStrings.priceTrends,
            subtitle: 'Average house price trend',
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final years = [
                            '2020',
                            '2021',
                            '2022',
                            '2023',
                            '2024',
                          ];
                          if (v.toInt() >= 0 && v.toInt() < years.length) {
                            return Text(
                              years[v.toInt()],
                              style: AppTextStyles.labelSmall,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 280000),
                        FlSpot(1, 310000),
                        FlSpot(2, 345000),
                        FlSpot(3, 320000),
                        FlSpot(4, 360000),
                      ],
                      isCurved: true,
                      color: AppColors.secondary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.secondary.withOpacity(0.1),
                      ),
                    ),
                  ],
                  minY: 200000,
                  maxY: 400000,
                ),
              ),
            ),
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Crime Rate
          _InsightCard(
            title: AppStrings.crimeRate,
            subtitle: 'Compared to national average',
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Below Average',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.success,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          'Crime index: 32/100',
                          style: AppTextStyles.bodyMediumSecondary,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text('🔒', style: const TextStyle(fontSize: 28)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.32,
                    minHeight: 10,
                    color: AppColors.success,
                    backgroundColor: Color(0xFFE5E7EB),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Low risk',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      'High risk',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // School Ratings
          _InsightCard(
            title: AppStrings.schoolRatings,
            subtitle: 'Nearby schools',
            child: Column(
              children: const [
                _SchoolItem('Riverside Primary', 'Outstanding', 4.8),
                _SchoolItem('Grove Academy', 'Good', 4.2),
                _SchoolItem('St. Mary\'s Secondary', 'Good', 4.1),
                _SchoolItem('Westfield College', 'Requires improvement', 3.2),
              ],
            ),
          ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Transport Links
          _InsightCard(
            title: AppStrings.transportLinks,
            subtitle: 'Key connections',
            child: Column(
              children: const [
                _TransportItem(
                  Icons.train_outlined,
                  'Victoria Line',
                  '0.3 mi',
                  Colors.blue,
                ),
                _TransportItem(
                  Icons.train_outlined,
                  'Overground',
                  '0.5 mi',
                  Colors.orange,
                ),
                _TransportItem(
                  Icons.directions_bus_outlined,
                  'Bus Route 38',
                  '50m',
                  Colors.red,
                ),
                _TransportItem(
                  Icons.local_taxi_outlined,
                  'Cycling route',
                  '0.1 mi',
                  AppColors.success,
                ),
              ],
            ),
          ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _InsightCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          Text(subtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SchoolItem extends StatelessWidget {
  final String name;
  final String rating;
  final double score;

  const _SchoolItem(this.name, this.rating, this.score);

  Color get _ratingColor {
    if (score >= 4.5) return AppColors.success;
    if (score >= 4.0) return AppColors.primary;
    if (score >= 3.5) return AppColors.accent;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.labelLarge),
                Text(
                  rating,
                  style: AppTextStyles.bodySmall.copyWith(color: _ratingColor),
                ),
              ],
            ),
          ),
          Text('⭐ $score', style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}

class _TransportItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final String distance;
  final Color color;

  const _TransportItem(this.icon, this.name, this.distance, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: AppTextStyles.labelLarge)),
          Text(distance, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

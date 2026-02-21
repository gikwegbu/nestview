// lib/features/mortgage_calculator/views/mortgage_calculator_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/mortgage_calculator_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';

class MortgageCalculatorScreen extends ConsumerStatefulWidget {
  final double? initialPrice;

  const MortgageCalculatorScreen({super.key, this.initialPrice});

  @override
  ConsumerState<MortgageCalculatorScreen> createState() =>
      _MortgageCalculatorScreenState();
}

class _MortgageCalculatorScreenState
    extends ConsumerState<MortgageCalculatorScreen> {
  late TextEditingController _priceController;
  late TextEditingController _depositController;
  late TextEditingController _rateController;
  late TextEditingController _incomeController;
  bool _isDepositPercent = false;
  bool _isStampDutyExpanded = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(mortgageCalculatorProvider);
    final price = widget.initialPrice ?? state.propertyPrice;
    if (widget.initialPrice != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(mortgageCalculatorProvider.notifier)
            .prefillFromProperty(widget.initialPrice!);
      });
    }
    _priceController = TextEditingController(text: price.toStringAsFixed(0));
    _depositController = TextEditingController(
      text: state.deposit.toStringAsFixed(0),
    );
    _rateController = TextEditingController(
      text: state.interestRate.toStringAsFixed(2),
    );
    _incomeController = TextEditingController(
      text: state.annualIncome.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _depositController.dispose();
    _rateController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mortgageCalculatorProvider);
    final notifier = ref.read(mortgageCalculatorProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.mortgageTitle,
          style: AppTextStyles.headlineMedium,
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              final calc = notifier.toSavedCalc();
              ref.read(savedCalculationsProvider.notifier).save(calc);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calculation saved!')),
              );
            },
            icon: const Icon(Icons.bookmark_outline_rounded, size: 18),
            label: Text(
              AppStrings.saveCalculation,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          // Input Card
          _InputCard(
            children: [
              _CurrencyInput(
                label: AppStrings.propertyPrice,
                controller: _priceController,
                onChanged: (v) =>
                    notifier.setPropertyPrice(double.tryParse(v) ?? 0),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _CurrencyInput(
                      label: AppStrings.depositAmount,
                      controller: _depositController,
                      suffix: _isDepositPercent ? '%' : '£',
                      onChanged: (v) {
                        final val = double.tryParse(v) ?? 0;
                        if (_isDepositPercent) {
                          notifier.setDepositPercent(val);
                        } else {
                          notifier.setDeposit(val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _isDepositPercent = !_isDepositPercent),
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 25,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _isDepositPercent
                            ? AppColors.secondary
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        _isDepositPercent ? '%' : '£',
                        style: AppTextStyles.labelLarge.copyWith(
                          // color: _isDepositPercent? Colors.white: AppColors.textPrimary,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // LTV Display
              _LtvIndicator(
                ltv: state.ltv,
                depositPercent: state.depositPercentage,
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Repayment toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mortgage Type', style: AppTextStyles.labelLarge),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        _TypeToggleButton(
                          label: 'Repayment',
                          isSelected: !state.isInterestOnly,
                          onTap: () => notifier.toggleInterestOnly(),
                        ),
                        _TypeToggleButton(
                          label: 'Interest Only',
                          isSelected: state.isInterestOnly,
                          onTap: () => notifier.toggleInterestOnly(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Term Slider
              _SliderRow(
                label: AppStrings.mortgageTerm,
                value: '${state.termYears} ${AppStrings.years}',
                child: Slider(
                  value: state.termYears.toDouble(),
                  min: 5,
                  max: 35,
                  divisions: 30,
                  label: '${state.termYears} yrs',
                  onChanged: (v) => notifier.setTermYears(v.toInt()),
                ),
              ),

              const SizedBox(height: 16),

              // Interest Rate
              _CurrencyInput(
                label: AppStrings.interestRate,
                controller: _rateController,
                suffix: '% AER',
                onChanged: (v) =>
                    notifier.setInterestRate(double.tryParse(v) ?? 0),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Results Card
          _ResultsCard(state: state).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 20),

          // Amortisation Chart
          _AmortisationChart(state: state),

          const SizedBox(height: 20),

          // Affordability Checker
          _AffordabilityCard(
            state: state,
            incomeController: _incomeController,
            onIncomeChanged: (v) =>
                notifier.setAnnualIncome(double.tryParse(v) ?? 0),
          ),

          const SizedBox(height: 20),

          // Stamp Duty
          _StampDutyCard(
            state: state,
            isExpanded: _isStampDutyExpanded,
            onToggle: () =>
                setState(() => _isStampDutyExpanded = !_isStampDutyExpanded),
            onTypeChanged: (type) => notifier.setStampDutyType(type),
          ),
        ],
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final List<Widget> children;

  const _InputCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _CurrencyInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? suffix;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  const _CurrencyInput({
    required this.label,
    required this.controller,
    this.suffix,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
          style: AppTextStyles.bodyMedium,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixText: suffix == '%' ? null : '£ ',
            suffixText: suffix,
          ),
        ),
      ],
    );
  }
}

class _LtvIndicator extends StatelessWidget {
  final double ltv;
  final double depositPercent;

  const _LtvIndicator({required this.ltv, required this.depositPercent});

  Color get _ltvColor {
    if (ltv < 60) return AppColors.ltvGood;
    if (ltv < 80) return AppColors.ltvMedium;
    return AppColors.ltvHigh;
  }

  String get _ltvLabel {
    if (ltv < 60) return 'Excellent LTV';
    if (ltv < 80) return 'Good LTV';
    return 'High LTV — Limited deals';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _ltvColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _ltvColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LTV', style: AppTextStyles.labelSmall),
                  Text(
                    '${ltv.toStringAsFixed(1)}%',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: _ltvColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Deposit', style: AppTextStyles.labelSmall),
                  Text(
                    '${depositPercent.toStringAsFixed(1)}%',
                    style: AppTextStyles.headlineLarge,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ltv / 100,
              backgroundColor: _ltvColor.withOpacity(0.15),
              color: _ltvColor,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _ltvLabel,
            style: AppTextStyles.bodySmall.copyWith(color: _ltvColor),
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget child;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.labelLarge),
            Text(
              value,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }
}

class _TypeToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ResultsCard extends StatelessWidget {
  final MortgageState state;

  const _ResultsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Results',
            style: AppTextStyles.headlineSmall.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          // Monthly Payment (big)
          Text(
            CurrencyFormatter.format(state.monthlyPayment),
            style: AppTextStyles.displayLarge.copyWith(
              color: Colors.white,
              fontSize: 40,
            ),
          ),
          Text(
            AppStrings.perMonth,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ResultItem(
                  label: AppStrings.totalRepayable,
                  value: CurrencyFormatter.format(state.totalRepayable),
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: Colors.white.withOpacity(0.2),
              ),
              Expanded(
                child: _ResultItem(
                  label: AppStrings.totalInterest,
                  value: CurrencyFormatter.format(state.totalInterest),
                  valueColor: AppColors.secondary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ResultItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white60),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: valueColor ?? Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmortisationChart extends StatelessWidget {
  final MortgageState state;

  const _AmortisationChart({required this.state});

  @override
  Widget build(BuildContext context) {
    final data = state.amortisationSchedule;
    if (data.isEmpty) return const SizedBox.shrink();

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
          Text(
            AppStrings.amortisationChart,
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'First ${data.length} years breakdown',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: data
                        .map((e) => e.interest + e.principal)
                        .reduce((a, b) => a > b ? a : b) *
                    1.1,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: AppColors.primary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final entry = data[group.x.toInt()];
                      return BarTooltipItem(
                        'Year ${entry.year}\n'
                        'Interest: ${CurrencyFormatter.formatCompact(entry.interest)}\n'
                        'Principal: ${CurrencyFormatter.formatCompact(entry.principal)}',
                        AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
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
                      getTitlesWidget: (value, _) => Text(
                        'Y${data[value.toInt()].year}',
                        style: AppTextStyles.labelSmall,
                      ),
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((entry) {
                  final i = entry.key;
                  final d = entry.value;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: d.interest + d.principal,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                        rodStackItems: [
                          BarChartRodStackItem(
                            0,
                            d.interest,
                            AppColors.secondary,
                          ),
                          BarChartRodStackItem(
                            d.interest,
                            d.interest + d.principal,
                            AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ChartLegend(color: AppColors.secondary, label: 'Interest'),
              const SizedBox(width: 20),
              _ChartLegend(color: AppColors.primary, label: 'Principal'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _AffordabilityCard extends StatelessWidget {
  final MortgageState state;
  final TextEditingController incomeController;
  final ValueChanged<String> onIncomeChanged;

  const _AffordabilityCard({
    required this.state,
    required this.incomeController,
    required this.onIncomeChanged,
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
          Text(
            AppStrings.affordabilityChecker,
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Based on 4.5× salary rule (UK standard)',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: incomeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTextStyles.bodyMedium,
            onChanged: onIncomeChanged,
            decoration: const InputDecoration(
              labelText: 'Annual Income',
              prefixText: '£ ',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: state.isAffordable
                  ? AppColors.success.withOpacity(0.08)
                  : AppColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: state.isAffordable
                    ? AppColors.success.withOpacity(0.3)
                    : AppColors.error.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  state.isAffordable
                      ? Icons.check_circle_outline_rounded
                      : Icons.warning_amber_rounded,
                  color:
                      state.isAffordable ? AppColors.success : AppColors.error,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.isAffordable
                            ? 'Within affordability'
                            : 'Exceeds typical affordability',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: state.isAffordable
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Max loan: ${CurrencyFormatter.format(state.affordabilityMax)}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StampDutyCard extends StatelessWidget {
  final MortgageState state;
  final bool isExpanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onTypeChanged;

  const _StampDutyCard({
    required this.state,
    required this.isExpanded,
    required this.onToggle,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 16)],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.stampDutyCalculator,
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SDLT: ${CurrencyFormatter.format(state.stampDuty)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 12),
                  Text('Buyer Type', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 12),
                  ...{
                    'first_time_buyer': AppStrings.firstTimeBuyer,
                    'home_mover': AppStrings.homeMover,
                    'second_home': AppStrings.secondHome,
                  }.entries.map((entry) {
                    final isSelected = state.stampDutyType == entry.key;
                    return RadioListTile<String>(
                      value: entry.key,
                      groupValue: state.stampDutyType,
                      onChanged: (v) => onTypeChanged(v!),
                      activeColor: AppColors.secondary,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        entry.value,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stamp Duty (SDLT)',
                          style: AppTextStyles.labelLarge,
                        ),
                        Text(
                          CurrencyFormatter.format(state.stampDuty),
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

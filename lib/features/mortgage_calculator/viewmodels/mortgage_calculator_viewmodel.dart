// lib/features/mortgage_calculator/viewmodels/mortgage_calculator_viewmodel.dart
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/mortgage_calculation_model.dart';
import '../../../core/constants/app_constants.dart';

// ─── Mortgage State ───────────────────────────────────────────────────────────
class MortgageState {
  final double propertyPrice;
  final double deposit;
  final double interestRate;
  final int termYears;
  final bool isInterestOnly;
  final String stampDutyType; // first_time_buyer, home_mover, second_home
  final double annualIncome;

  const MortgageState({
    this.propertyPrice = 350000,
    this.deposit = 70000,
    this.interestRate = 4.5,
    this.termYears = 25,
    this.isInterestOnly = false,
    this.stampDutyType = 'home_mover',
    this.annualIncome = 60000,
  });

  double get loanAmount => propertyPrice - deposit;
  double get ltv => loanAmount / propertyPrice * 100;
  double get depositPercentage => deposit / propertyPrice * 100;

  double get monthlyPayment {
    if (isInterestOnly) {
      return loanAmount * (interestRate / 100) / 12;
    }
    final monthlyRate = interestRate / 100 / 12;
    final numPayments = termYears * 12;
    if (monthlyRate == 0) return loanAmount / numPayments;
    final a = math.pow(1 + monthlyRate, numPayments);
    return loanAmount * (monthlyRate * a) / (a - 1);
  }

  double get totalRepayable => monthlyPayment * termYears * 12;
  double get totalInterest => totalRepayable - loanAmount;

  double get stampDuty => _calculateStampDuty();

  double _calculateStampDuty() {
    if (propertyPrice <= 0) return 0;
    switch (stampDutyType) {
      case 'first_time_buyer':
        return _firstTimeBuyerSDLT();
      case 'second_home':
        return _standardSDLT() + propertyPrice * AppConstants.sdSurcharge;
      default:
        return _standardSDLT();
    }
  }

  double _standardSDLT() {
    double duty = 0;
    const double nil = 250000;
    const double band2 = 925000;
    const double band3 = 1500000;

    if (propertyPrice > nil) {
      duty += math.min(propertyPrice, band2) - nil;
      duty *= 0.05;
    }
    if (propertyPrice > band2) {
      duty += (math.min(propertyPrice, band3) - band2) * 0.10;
    }
    if (propertyPrice > band3) {
      duty += (propertyPrice - band3) * 0.12;
    }
    return duty;
  }

  double _firstTimeBuyerSDLT() {
    if (propertyPrice > AppConstants.ftbStampDutyThreshold2) {
      // Over £625k => standard rates apply, no relief
      return _standardSDLT();
    }
    if (propertyPrice <= AppConstants.ftbStampDutyThreshold1) {
      return 0; // Zero SDLT up to £425k for FTB
    }
    // 5% on portion above £425k up to £625k
    return (propertyPrice - AppConstants.ftbStampDutyThreshold1) * 0.05;
  }

  double get affordabilityMax =>
      annualIncome * AppConstants.mortgageAffordabilityMultiple;

  bool get isAffordable => loanAmount <= affordabilityMax;

  List<AmortisationEntry> get amortisationSchedule {
    final entries = <AmortisationEntry>[];
    double balance = loanAmount;
    final monthlyRate = interestRate / 100 / 12;
    final payment = monthlyPayment;

    for (int year = 1; year <= math.min(termYears, 10); year++) {
      double yearlyInterest = 0;
      double yearlyPrincipal = 0;

      for (int month = 0; month < 12; month++) {
        final interestPayment = balance * monthlyRate;
        final principalPayment = isInterestOnly ? 0 : payment - interestPayment;
        yearlyInterest += interestPayment;
        yearlyPrincipal += principalPayment;
        balance = math.max(0, balance - principalPayment);
      }

      entries.add(
        AmortisationEntry(
          year: year,
          interest: yearlyInterest,
          principal: yearlyPrincipal,
          balance: balance,
        ),
      );
    }

    return entries;
  }

  MortgageState copyWith({
    double? propertyPrice,
    double? deposit,
    double? interestRate,
    int? termYears,
    bool? isInterestOnly,
    String? stampDutyType,
    double? annualIncome,
  }) {
    return MortgageState(
      propertyPrice: propertyPrice ?? this.propertyPrice,
      deposit: deposit ?? this.deposit,
      interestRate: interestRate ?? this.interestRate,
      termYears: termYears ?? this.termYears,
      isInterestOnly: isInterestOnly ?? this.isInterestOnly,
      stampDutyType: stampDutyType ?? this.stampDutyType,
      annualIncome: annualIncome ?? this.annualIncome,
    );
  }
}

class AmortisationEntry {
  final int year;
  final double interest;
  final double principal;
  final double balance;

  const AmortisationEntry({
    required this.year,
    required this.interest,
    required this.principal,
    required this.balance,
  });
}

// ─── Mortgage Provider ────────────────────────────────────────────────────────
final mortgageCalculatorProvider =
    NotifierProvider<MortgageCalculatorNotifier, MortgageState>(
      MortgageCalculatorNotifier.new,
    );

class MortgageCalculatorNotifier extends Notifier<MortgageState> {
  @override
  MortgageState build() => const MortgageState();

  void setPropertyPrice(double price) {
    state = state.copyWith(propertyPrice: price);
  }

  void setDeposit(double deposit) {
    state = state.copyWith(deposit: deposit);
  }

  void setDepositPercent(double percent) {
    state = state.copyWith(deposit: state.propertyPrice * percent / 100);
  }

  void setInterestRate(double rate) {
    state = state.copyWith(interestRate: rate);
  }

  void setTermYears(int years) {
    state = state.copyWith(termYears: years);
  }

  void toggleInterestOnly() {
    state = state.copyWith(isInterestOnly: !state.isInterestOnly);
  }

  void setStampDutyType(String type) {
    state = state.copyWith(stampDutyType: type);
  }

  void setAnnualIncome(double income) {
    state = state.copyWith(annualIncome: income);
  }

  void prefillFromProperty(double price) {
    state = state.copyWith(propertyPrice: price, deposit: price * 0.1);
  }

  MortgageCalculationModel toSavedCalc() {
    const uuid = Uuid();
    return MortgageCalculationModel(
      id: uuid.v4(),
      propertyPrice: state.propertyPrice,
      deposit: state.deposit,
      interestRate: state.interestRate,
      termYears: state.termYears,
      isInterestOnly: state.isInterestOnly,
      monthlyPayment: state.monthlyPayment,
      totalRepayable: state.totalRepayable,
      totalInterest: state.totalInterest,
      ltv: state.ltv,
      stampDuty: state.stampDuty,
      stampDutyType: state.stampDutyType,
      savedAt: DateTime.now(),
    );
  }
}

// ─── Saved Calculations Provider ──────────────────────────────────────────────
final savedCalculationsProvider =
    NotifierProvider<SavedCalculationsNotifier, List<MortgageCalculationModel>>(
      SavedCalculationsNotifier.new,
    );

class SavedCalculationsNotifier
    extends Notifier<List<MortgageCalculationModel>> {
  @override
  List<MortgageCalculationModel> build() => [];

  void save(MortgageCalculationModel calc) {
    state = [calc, ...state].take(AppConstants.maxSavedCalculations).toList();
  }

  void remove(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

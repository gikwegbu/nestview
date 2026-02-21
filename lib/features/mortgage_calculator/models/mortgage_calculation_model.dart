// lib/features/mortgage_calculator/models/mortgage_calculation_model.dart
import 'package:hive/hive.dart';

part 'mortgage_calculation_model.g.dart';

@HiveType(typeId: 6)
class MortgageCalculationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double propertyPrice;

  @HiveField(2)
  final double deposit;

  @HiveField(3)
  final double interestRate;

  @HiveField(4)
  final int termYears;

  @HiveField(5)
  final bool isInterestOnly;

  @HiveField(6)
  final double monthlyPayment;

  @HiveField(7)
  final double totalRepayable;

  @HiveField(8)
  final double totalInterest;

  @HiveField(9)
  final double ltv;

  @HiveField(10)
  final double stampDuty;

  @HiveField(11)
  final String stampDutyType; // first_time_buyer, home_mover, second_home

  @HiveField(12)
  final DateTime savedAt;

  @HiveField(13)
  final String? propertyId;

  @HiveField(14)
  final String? propertyAddress;

  @HiveField(15)
  final String? name;

  MortgageCalculationModel({
    required this.id,
    required this.propertyPrice,
    required this.deposit,
    required this.interestRate,
    required this.termYears,
    required this.isInterestOnly,
    required this.monthlyPayment,
    required this.totalRepayable,
    required this.totalInterest,
    required this.ltv,
    required this.stampDuty,
    required this.stampDutyType,
    required this.savedAt,
    this.propertyId,
    this.propertyAddress,
    this.name,
  });

  double get loanAmount => propertyPrice - deposit;

  String get ltvLabel {
    if (ltv < 60) return 'Excellent';
    if (ltv < 75) return 'Good';
    if (ltv < 85) return 'Fair';
    return 'High Risk';
  }
}

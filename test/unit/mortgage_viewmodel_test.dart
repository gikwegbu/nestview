// test/unit/mortgage_viewmodel_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_haven/features/mortgage_calculator/viewmodels/mortgage_calculator_viewmodel.dart';

void main() {
  // Helper to create a MortgageState directly
  // Note: stampDutyType matches the viewmodel switch: 'first_time_buyer', 'second_home', default is 'home_mover'
  MortgageState _state({
    double propertyPrice = 300000,
    double deposit = 30000,
    double interestRate = 4.5,
    int termYears = 25,
    bool isInterestOnly = false,
    double annualIncome = 0,
    String stampDutyType = 'home_mover',
  }) {
    return MortgageState(
      propertyPrice: propertyPrice,
      deposit: deposit,
      interestRate: interestRate,
      termYears: termYears,
      isInterestOnly: isInterestOnly,
      annualIncome: annualIncome,
      stampDutyType: stampDutyType,
    );
  }

  group('MortgageState', () {
    group('loanAmount', () {
      test('is propertyPrice minus deposit', () {
        final s = _state(propertyPrice: 300000, deposit: 30000);
        expect(s.loanAmount, equals(270000));
      });

      test('handles zero deposit', () {
        final s = _state(propertyPrice: 200000, deposit: 0);
        expect(s.loanAmount, equals(200000));
      });
    });

    group('ltv', () {
      test('calculates LTV percentage correctly', () {
        final s = _state(propertyPrice: 300000, deposit: 30000);
        // ltv = (270000 / 300000) * 100 = 90
        expect(s.ltv, closeTo(90.0, 0.01));
      });

      test('LTV is 0 when deposit equals property price', () {
        final s = _state(propertyPrice: 300000, deposit: 300000);
        expect(s.ltv, equals(0.0));
      });
    });

    group('monthlyPayment — repayment', () {
      test('calculates monthly payment with 4.5% rate over 25 years', () {
        final s = _state(
          propertyPrice: 300000,
          deposit: 30000,
          interestRate: 4.5,
          termYears: 25,
        );
        // Expected: roughly £1,500/mo for £270k at 4.5% over 25yrs
        expect(s.monthlyPayment, greaterThan(1400));
        expect(s.monthlyPayment, lessThan(1700));
      });

      test('higher interest rate produces higher monthly payment', () {
        final low = _state(interestRate: 3.0);
        final high = _state(interestRate: 6.0);
        expect(high.monthlyPayment, greaterThan(low.monthlyPayment));
      });

      test('longer term produces lower monthly payment', () {
        final short = _state(termYears: 15);
        final long = _state(termYears: 30);
        expect(long.monthlyPayment, lessThan(short.monthlyPayment));
      });

      test('returns 0 monthly payment when loan is 0', () {
        final s = _state(propertyPrice: 300000, deposit: 300000);
        expect(s.monthlyPayment, equals(0));
      });
    });

    group('monthlyPayment — interest only', () {
      test('interest-only payment is loan * rate / 12', () {
        final s = _state(
          propertyPrice: 300000,
          deposit: 30000,
          interestRate: 4.5,
          isInterestOnly: true,
        );
        final expected = 270000 * 0.045 / 12;
        expect(s.monthlyPayment, closeTo(expected, 0.01));
      });

      test('interest-only is less than repayment for same inputs', () {
        final repayment = _state(isInterestOnly: false);
        final interestOnly = _state(isInterestOnly: true);
        expect(interestOnly.monthlyPayment, lessThan(repayment.monthlyPayment));
      });
    });

    group('totalRepayable', () {
      test('equals monthlyPayment * termYears * 12', () {
        final s = _state(termYears: 25);
        expect(s.totalRepayable, closeTo(s.monthlyPayment * 25 * 12, 0.01));
      });
    });

    group('totalInterest', () {
      test('totalInterest is totalRepayable minus loanAmount', () {
        final s = _state();
        expect(s.totalInterest, closeTo(s.totalRepayable - s.loanAmount, 0.01));
      });

      test('total interest is positive', () {
        final s = _state();
        expect(s.totalInterest, greaterThan(0));
      });
    });

    group('stampDuty — home mover (default)', () {
      test('no stamp duty under £250k for home mover', () {
        final s = _state(propertyPrice: 200000);
        expect(s.stampDuty, equals(0));
      });

      test('stamp duty at 5% between £250k and £925k', () {
        // £300k: (300000 - 250000) * 5% = £2500
        final s = _state(propertyPrice: 300000);
        expect(s.stampDuty, equals(2500));
      });

      test('stamp duty correct at £500k home mover', () {
        // (500000 - 250000) * 5% = 12500
        final s = _state(propertyPrice: 500000);
        expect(s.stampDuty, equals(12500));
      });
    });

    group('stampDuty — first time buyer', () {
      test('no stamp duty for FTB under £425k', () {
        final s =
            _state(propertyPrice: 400000, stampDutyType: 'first_time_buyer');
        expect(s.stampDuty, equals(0));
      });

      test('5% on amount above £425k for FTB up to £625k', () {
        // £500k FTB: (500000 - 425000) * 5% = 3750
        final s =
            _state(propertyPrice: 500000, stampDutyType: 'first_time_buyer');
        expect(s.stampDuty, equals(3750));
      });

      test('FTB over £625k falls back to standard rates', () {
        // Over £625k: same as home mover
        final ftb =
            _state(propertyPrice: 700000, stampDutyType: 'first_time_buyer');
        final homeMover = _state(propertyPrice: 700000);
        expect(ftb.stampDuty, equals(homeMover.stampDuty));
      });
    });

    group('stampDuty — second home', () {
      test('second home adds 3% surcharge on full property value', () {
        // £300k: standard = £2500 + 3% surcharge = 300000 * 3% = £9000, total = £11500
        final s = _state(propertyPrice: 300000, stampDutyType: 'second_home');
        // Standard SDLT: 2500 + surcharge: 300000 * 0.03 = 9000 → total = 11500
        expect(s.stampDuty, equals(2500 + 300000 * 0.03));
      });

      test('second home pays more than home mover', () {
        final homeMover = _state(propertyPrice: 300000);
        final secondHome =
            _state(propertyPrice: 300000, stampDutyType: 'second_home');
        expect(secondHome.stampDuty, greaterThan(homeMover.stampDuty));
      });
    });

    group('affordability', () {
      test('isAffordable when income * 4.5 >= loanAmount', () {
        // loanAmount = 270000, income * 4.5 = 300000 * 4.5 = 1350000
        final s =
            _state(propertyPrice: 300000, deposit: 30000, annualIncome: 300000);
        expect(s.isAffordable, isTrue);
      });

      test('not affordable when income * 4.5 < loanAmount', () {
        // loanAmount = 270000, income * 4.5 = 50000 * 4.5 = 225000 < 270000
        final s =
            _state(propertyPrice: 300000, deposit: 30000, annualIncome: 50000);
        expect(s.isAffordable, isFalse);
      });

      test('affordabilityMax is income * 4.5', () {
        final s = _state(annualIncome: 60000);
        expect(s.affordabilityMax, equals(60000 * 4.5));
      });
    });

    group('amortisationSchedule', () {
      // Note: implementation shows up to min(termYears, 10) years on chart
      test('schedule is capped at 10 entries for long loans', () {
        final s = _state(termYears: 25);
        expect(s.amortisationSchedule.length, equals(10));
      });

      test('schedule length equals termYears for short loans', () {
        final s = _state(termYears: 5);
        expect(s.amortisationSchedule.length, equals(5));
      });

      test('first year has highest interest portion for repayment', () {
        final s = _state(isInterestOnly: false);
        final schedule = s.amortisationSchedule;
        expect(schedule.first.interest, greaterThan(schedule.last.interest));
      });

      test('schedule has positive balance for repayment', () {
        final s = _state(isInterestOnly: false, termYears: 10);
        final schedule = s.amortisationSchedule;
        expect(schedule.last.balance, greaterThanOrEqualTo(0));
      });

      test('schedule is non-empty for valid loan', () {
        final s = _state(propertyPrice: 300000, deposit: 30000);
        expect(s.amortisationSchedule, isNotEmpty);
      });
    });
  });
}

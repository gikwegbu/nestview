// test/unit/currency_formatter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_view/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    group('format()', () {
      test('formats whole numbers without pence', () {
        expect(CurrencyFormatter.format(450000), equals('£450,000'));
      });

      test('formats small amounts', () {
        expect(CurrencyFormatter.format(1000), equals('£1,000'));
      });

      test('formats with pence when requested', () {
        final result = CurrencyFormatter.format(450000.50, includePence: true);
        expect(result, equals('£450,000.50'));
      });

      test('formats zero', () {
        expect(CurrencyFormatter.format(0), equals('£0'));
      });

      test('formats large amounts correctly', () {
        expect(CurrencyFormatter.format(1500000), equals('£1,500,000'));
      });
    });

    group('formatCompact()', () {
      test('formats millions with M suffix', () {
        expect(CurrencyFormatter.formatCompact(1500000), equals('£1.50M'));
      });

      test('formats exact million', () {
        expect(CurrencyFormatter.formatCompact(1000000), equals('£1.00M'));
      });

      test('formats hundreds of thousands with k suffix', () {
        expect(CurrencyFormatter.formatCompact(450000), equals('£450k'));
      });

      test('formats 100k with k suffix', () {
        expect(CurrencyFormatter.formatCompact(100000), equals('£100k'));
      });

      test('formats below 100k as full amount', () {
        expect(CurrencyFormatter.formatCompact(75000), equals('£75,000'));
      });

      test('formats 50k without k suffix', () {
        expect(CurrencyFormatter.formatCompact(50000), equals('£50,000'));
      });
    });

    group('formatPerMonth()', () {
      test('appends /pcm suffix', () {
        expect(CurrencyFormatter.formatPerMonth(1500), equals('£1,500/pcm'));
      });

      test('formats large rent correctly', () {
        expect(CurrencyFormatter.formatPerMonth(5000), equals('£5,000/pcm'));
      });
    });

    group('formatRange()', () {
      test('formats range with em-dash', () {
        expect(
          CurrencyFormatter.formatRange(200000, 500000),
          equals('£200k – £500k'),
        );
      });

      test('formats range crossing million threshold', () {
        expect(
          CurrencyFormatter.formatRange(900000, 1500000),
          equals('£900k – £1.50M'),
        );
      });
    });

    group('parseGBP()', () {
      test('parses formatted string back to double', () {
        expect(CurrencyFormatter.parseGBP('£450,000'), equals(450000.0));
      });

      test('returns 0 for invalid input', () {
        expect(CurrencyFormatter.parseGBP('invalid'), equals(0.0));
      });

      test('parses amount with spaces', () {
        expect(CurrencyFormatter.parseGBP('£ 100 000'), equals(100000.0));
      });

      test('parses plain number string', () {
        expect(CurrencyFormatter.parseGBP('75000'), equals(75000.0));
      });
    });
  });
}

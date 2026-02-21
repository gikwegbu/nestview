// test/unit/property_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_haven/features/search/models/property_model.dart';

PropertyModel _makeProperty({
  double price = 450000,
  double? previousPrice,
  PropertyType type = PropertyType.detached,
  bool isRental = false,
}) {
  return PropertyModel(
    id: 'test-001',
    title: 'Test Property',
    price: price,
    isRental: isRental,
    address: '1 Test Lane',
    city: 'London',
    postcode: 'SW1A 1AA',
    latitude: 51.5074,
    longitude: -0.1278,
    bedrooms: 3,
    bathrooms: 2,
    receptions: 1,
    squareFeet: 1200,
    epcRating: 'B',
    propertyType: type,
    listingType: isRental ? ListingType.rent : ListingType.buy,
    imageUrls: ['https://example.com/img1.jpg'],
    description: 'A lovely test property.',
    keyFeatures: ['Garden', 'Parking'],
    hasGarden: true,
    hasParking: true,
    isNewBuild: false,
    isRetirement: false,
    addedDate: DateTime(2025, 1, 15),
    agentName: 'Test Estate Agent',
    agentPhone: '07700900000',
    agentEmail: 'agent@test.com',
    agentLogo: 'https://example.com/logo.png',
    isPremiumListing: false,
    previousPrice: previousPrice,
  );
}

void main() {
  group('PropertyModel', () {
    group('isPriceReduced', () {
      test('returns true when previousPrice is higher than current price', () {
        final property = _makeProperty(price: 400000, previousPrice: 450000);
        expect(property.isPriceReduced, isTrue);
      });

      test('returns false when previousPrice is null', () {
        final property = _makeProperty(price: 400000, previousPrice: null);
        expect(property.isPriceReduced, isFalse);
      });

      test('returns false when previousPrice is lower than current price', () {
        // Price went up (weird edge case)
        final property = _makeProperty(price: 450000, previousPrice: 400000);
        expect(property.isPriceReduced, isFalse);
      });

      test('returns false when prices are equal', () {
        final property = _makeProperty(price: 450000, previousPrice: 450000);
        expect(property.isPriceReduced, isFalse);
      });
    });

    group('priceReduction', () {
      test('returns correct reduction amount', () {
        final property = _makeProperty(price: 400000, previousPrice: 450000);
        expect(property.priceReduction, equals(50000));
      });

      test('returns 0 when no previous price', () {
        final property = _makeProperty(price: 400000, previousPrice: null);
        expect(property.priceReduction, equals(0));
      });
    });

    group('propertyTypeLabel', () {
      test('returns Detached for detached type', () {
        final p = _makeProperty(type: PropertyType.detached);
        expect(p.propertyTypeLabel, equals('Detached'));
      });

      test('returns Semi-Detached for semiDetached type', () {
        final p = _makeProperty(type: PropertyType.semiDetached);
        expect(p.propertyTypeLabel, equals('Semi-Detached'));
      });

      test('returns Terraced for terraced type', () {
        final p = _makeProperty(type: PropertyType.terraced);
        expect(p.propertyTypeLabel, equals('Terraced'));
      });

      test('returns Flat for flat type', () {
        final p = _makeProperty(type: PropertyType.flat);
        expect(p.propertyTypeLabel, equals('Flat'));
      });

      test('returns Bungalow for bungalow type', () {
        final p = _makeProperty(type: PropertyType.bungalow);
        expect(p.propertyTypeLabel, equals('Bungalow'));
      });

      test('returns Commercial for commercial type', () {
        final p = _makeProperty(type: PropertyType.commercial);
        expect(p.propertyTypeLabel, equals('Commercial'));
      });

      test('returns Land for land type', () {
        final p = _makeProperty(type: PropertyType.land);
        expect(p.propertyTypeLabel, equals('Land'));
      });
    });

    group('copyWith', () {
      test('creates a copy with updated price', () {
        final original = _makeProperty(price: 450000);
        final copy = original.copyWith(price: 425000);
        expect(copy.price, equals(425000));
        expect(copy.id, equals(original.id));
        expect(copy.title, equals(original.title));
      });

      test('creates a copy with updated bedrooms', () {
        final original = _makeProperty();
        final copy = original.copyWith(bedrooms: 5);
        expect(copy.bedrooms, equals(5));
        expect(copy.price, equals(original.price));
      });

      test('preserves original values when no changes', () {
        final original = _makeProperty();
        final copy = original.copyWith();
        expect(copy.id, equals(original.id));
        expect(copy.price, equals(original.price));
        expect(copy.city, equals(original.city));
      });
    });
  });
}

// test/widget/property_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_haven/features/search/models/property_model.dart';
import 'package:nest_haven/features/search/models/property_preview_model.dart';
import 'package:nest_haven/features/search/widgets/property_card.dart';
import 'package:nest_haven/features/favourites/viewmodels/favourites_viewmodel.dart';

// A lightweight property for UI testing
PropertyModel _testProperty({double? previousPrice}) => PropertyModel(
      id: 'prop-001',
      title: 'Beautiful 3-Bed House',
      price: 450000,
      isRental: false,
      address: '12 Oak Avenue',
      city: 'London',
      postcode: 'E1 6AA',
      latitude: 51.5,
      longitude: -0.1,
      bedrooms: 3,
      bathrooms: 2,
      receptions: 1,
      squareFeet: 1200,
      epcRating: 'B',
      propertyType: PropertyType.terraced,
      listingType: ListingType.buy,
      imageUrls: ['https://picsum.photos/400/300'],
      description: 'A lovely test property in a great location.',
      keyFeatures: ['Garden', 'Parking'],
      hasGarden: true,
      hasParking: true,
      isNewBuild: false,
      isRetirement: false,
      addedDate: DateTime(2025, 1, 1),
      agentName: 'Test Agent',
      agentPhone: '07700900000',
      agentEmail: 'agent@test.com',
      agentLogo: 'https://example.com/logo.png',
      previousPrice: previousPrice,
    );

Widget _buildCard(PropertyModel property) {
  return ProviderScope(
    overrides: [
      favouritesProvider.overrideWith(_EmptyFavouritesNotifier.new),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: PropertyCard(property: property, onTap: () {}),
      ),
    ),
  );
}

class _EmptyFavouritesNotifier extends FavouritesNotifier {
  @override
  List<PropertyPreviewModel> build() => [];
}

void main() {
  group('PropertyCard widget', () {
    testWidgets('renders property price', (tester) async {
      await tester.pumpWidget(_buildCard(_testProperty()));
      await tester.pump(const Duration(seconds: 1));
      // Price should appear somewhere in the widget tree
      expect(find.textContaining('450'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders bedroom and bathroom count', (tester) async {
      await tester.pumpWidget(_buildCard(_testProperty()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('3'), findsAtLeastNWidgets(1));
      expect(find.textContaining('2'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders address', (tester) async {
      await tester.pumpWidget(_buildCard(_testProperty()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('Oak Avenue'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows Price Reduced badge when price dropped', (tester) async {
      final property =
          _testProperty(previousPrice: 500000); // was £500k, now £450k
      await tester.pumpWidget(_buildCard(property));
      await tester.pump(const Duration(seconds: 1));
      // Should show some indicator of price reduction
      expect(find.byWidgetPredicate((w) {
        if (w is Text) {
          return w.data?.toLowerCase().contains('reduc') == true ||
              w.data?.toLowerCase().contains('price') == true;
        }
        return false;
      }), findsAtLeastNWidgets(1));
    });

    testWidgets('favourite button is present', (tester) async {
      await tester.pumpWidget(_buildCard(_testProperty()));
      await tester.pump(const Duration(seconds: 1));
      // Look for a heart icon button
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Icon &&
              (w.icon == Icons.favorite_outline_rounded ||
                  w.icon == Icons.favorite_rounded),
        ),
        findsAtLeastNWidgets(1),
      );
    });
  });
}

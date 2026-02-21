import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nest_haven/main.dart';
import 'package:nest_haven/core/constants/app_constants.dart';
import 'package:nest_haven/features/search/models/property_model.dart';
import 'package:nest_haven/features/search/models/property_preview_model.dart';
import 'package:nest_haven/features/search/models/search_filter_model.dart';
import 'package:nest_haven/features/mortgage_calculator/models/mortgage_calculation_model.dart';
import 'dart:io';
import 'dart:ui' as ui;

Future<void> main() async {
  // Test setup for mocking Hive and taking pictures
  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync('nest_haven_test_');
    Hive.init(tempDir.path);

    // Register adapters
    if (!Hive.isAdapterRegistered(PropertyTypeAdapter().typeId)) {
      Hive.registerAdapter(PropertyTypeAdapter());
      Hive.registerAdapter(ListingTypeAdapter());
      Hive.registerAdapter(PropertyModelAdapter());
      Hive.registerAdapter(PropertyPreviewModelAdapter());
      Hive.registerAdapter(TransportModeAdapter());
      Hive.registerAdapter(SearchFilterModelAdapter());
      Hive.registerAdapter(MortgageCalculationModelAdapter());
    }

    // Open boxes
    await Future.wait([
      Hive.openBox<PropertyPreviewModel>(AppConstants.favouritesBox),
      Hive.openBox<SearchFilterModel>(AppConstants.savedSearchesBox),
      Hive.openBox<PropertyPreviewModel>(AppConstants.recentlyViewedBox),
      Hive.openBox<MortgageCalculationModel>(AppConstants.savedCalculationsBox),
      Hive.openBox<dynamic>(AppConstants.userPreferencesBox),
      Hive.openBox<bool>(AppConstants.onboardingBox),
    ]);

    // Set onboarding complete
    Hive.box<bool>(AppConstants.onboardingBox)
        .put('hasCompletedOnboarding', true);

    // Create output directory
    final outDir = Directory(
        '/Users/georgeikwegbu/Developer/Github/Mobile/flutter_apps/nest_haven/storeFiles/playstore');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
  });

  Future<void> takeScreenshot(WidgetTester tester, String name) async {
    // Pixel 6 size approx (1080x2400 in physical pixels, divided by 2.625 pixel ratio = ~411x914)
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;

    await tester.pumpAndSettle();

    final finder = find.byType(RepaintBoundary);
    final renderObject =
        tester.renderObject(finder.first) as RenderRepaintBoundary;
    final image =
        await renderObject.toImage(pixelRatio: tester.view.devicePixelRatio);

    if (image != null) {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        final file = File(
            '/Users/georgeikwegbu/Developer/Github/Mobile/flutter_apps/nest_haven/storeFiles/playstore/$name.png');
        await file.writeAsBytes(bytes.buffer.asUint8List());
        print('Saved screenshot: $name.png');
      }
    }

    // Reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }

  testWidgets('Generate Android Screenshots', (tester) async {
    // Give flutter_animate timers time to clear natively before capturing. Wait for data load.
    await tester.pumpWidget(const ProviderScope(child: NestHavenApp()));
    await tester.pump(const Duration(seconds: 3));

    // 1. Home / Search Bar
    await takeScreenshot(tester, '1_home_search');

    // 2. Search Results
    await tester.tap(find.text('Search Properties'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'London');
    await tester.testTextInput
        .receiveAction(TextInputAction.search); // Submit search
    await tester.pump(const Duration(seconds: 2));
    await takeScreenshot(tester, '2_search_results');

    // 3. Property Detail
    // Find the first property card and tap it
    final propertyCard = find.text('£').first;
    if (propertyCard.evaluate().isNotEmpty) {
      await tester.tap(propertyCard);
      await tester.pump(const Duration(seconds: 2));
      await takeScreenshot(tester, '3_property_detail');

      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    // 4. Mortgage Calculator
    // Navigate using the bottom nav bar (index 3 is assumed to be Calculator based on standard tabs: Home, Map, Fav, Calc, Profile)
    await tester.tap(find.byIcon(Icons.calculate_outlined));
    await tester.pump(const Duration(seconds: 2));
    await takeScreenshot(tester, '4_mortgage_calculator');

    // 5. Map Search
    // Navigate using bottom nav bar (index 1 is usually Map)
    await tester.tap(find.byIcon(Icons.map_outlined));
    await tester.pump(const Duration(seconds: 2));
    await takeScreenshot(tester, '5_map_search');
  });
}

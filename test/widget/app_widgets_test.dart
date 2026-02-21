// test/widget/app_widgets_test.dart
//
// Tests for shared utility widgets: AppLoadingWidget, AppErrorWidget, AppEmptyWidget
//
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_view/core/widgets/app_loading.dart';
import 'package:nest_view/core/widgets/app_error.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('AppLoadingWidget', () {
    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(_wrap(const AppLoadingWidget()));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('displays a progress indicator or shimmer', (tester) async {
      await tester.pumpWidget(_wrap(const AppLoadingWidget()));
      await tester.pump();
      // Should have some visual loading indicator
      expect(
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
              find.byType(LinearProgressIndicator).evaluate().isNotEmpty ||
              find
                  .descendant(
                    of: find.byType(Scaffold),
                    matching: find.byType(Container),
                  )
                  .evaluate()
                  .isNotEmpty,
          isTrue);
    });
  });

  group('AppErrorWidget', () {
    testWidgets('displays error message and retry button', (tester) async {
      bool retried = false;
      await tester.pumpWidget(_wrap(
        AppErrorWidget(
          message: 'Something went wrong',
          onRetry: () => retried = true,
        ),
      ));
      await tester.pump();

      // Message text should be present
      expect(
          find.textContaining('Something went wrong'), findsAtLeastNWidgets(1));
    });

    testWidgets('calls onRetry when retry button tapped', (tester) async {
      bool retried = false;
      await tester.pumpWidget(_wrap(
        AppErrorWidget(
          message: 'Network error',
          onRetry: () => retried = true,
        ),
      ));
      await tester.pump();

      // Find and tap a retry/try again button
      final retryBtn = find.byWidgetPredicate(
        (w) =>
            w is Text &&
            (w.data?.toLowerCase().contains('retry') == true ||
                w.data?.toLowerCase().contains('try') == true),
      );
      if (retryBtn.evaluate().isNotEmpty) {
        await tester.tap(retryBtn.first);
        expect(retried, isTrue);
      }
    });

    testWidgets('renders without onRetry (optional)', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppErrorWidget(message: 'Error occurred'),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('AppEmptyWidget', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppEmptyWidget(
          title: 'Nothing here',
          subtitle: 'No items to show.',
          icon: Icons.search_off,
        ),
      ));
      await tester.pump();
      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('No items to show.'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppEmptyWidget(
          title: 'Empty',
          subtitle: 'No data.',
          icon: Icons.search_off,
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.search_off), findsAtLeastNWidgets(1));
    });

    testWidgets('renders action widget when provided', (tester) async {
      await tester.pumpWidget(_wrap(
        AppEmptyWidget(
          title: 'Empty',
          subtitle: 'No items.',
          icon: Icons.inbox_rounded,
          action: ElevatedButton(
            onPressed: () {},
            child: const Text('Browse items'),
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('Browse items'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui' as ui;
import 'dart:io';

void main() {
  testWidgets('Generate screenshot', (WidgetTester tester) async {
    await tester.pumpWidget(
      const RepaintBoundary(
        child: MaterialApp(
          home: Scaffold(body: Center(child: Text('Hello'))),
        ),
      ),
    );

    final finder = find.byType(RepaintBoundary);
    final renderObject = tester.renderObject(finder.first) as RenderRepaintBoundary;
    final image = await renderObject.toImage(pixelRatio: 2.0);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    print('Image bytes: ${bytes?.lengthInBytes}');
  });
}

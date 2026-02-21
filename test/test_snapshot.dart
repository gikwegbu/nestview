import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui' as ui;
import 'dart:io';

void main() {
  testWidgets('Test snapshot', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Text('Hello'))));

    // try to use takeExceptionSafeSnapshot
    try {
      final image =
          await captureImage(find.byType(MaterialApp).evaluate().single);
      print("captureImage worked!");
    } catch (e) {
      print("Error: $e");
    }
  });
}

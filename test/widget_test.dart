import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/main.dart';

void main() {
  testWidgets('Weather app loads and shows Chiniot as default location',
          (WidgetTester tester) async {
        // Build the app
        await tester.pumpWidget(const MyApp());

        // Wait for async operations (like fetching weather) to complete
        await tester.pumpAndSettle();

        // Check if "Chiniot" is displayed
        expect(find.text('Chiniot'), findsOneWidget);

        // Optional: Check if temperature (°) symbol is present
        expect(find.textContaining('°'), findsWidgets);
      });
}

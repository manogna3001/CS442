import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/views/search.dart';

Widget createSearchScreen() => const MaterialApp(
      home: Search(),
    );

void main() {
  group('Search Page Widget Tests', () {

    testWidgets('Testing - Search field ', (tester) async {
      await tester.pumpWidget(createSearchScreen());
      expect(find.text("Search"), findsWidgets);
    });

    testWidgets('Testing - Search button', (tester) async {
      await tester.pumpWidget(createSearchScreen());
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Test - Home icon', (tester) async {
      await tester.pumpWidget(createSearchScreen());
      expect(find.byIcon(Icons.home), findsWidgets);
    });

  });
}
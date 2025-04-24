import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/views/menu.dart';

Widget createMenu() => const MaterialApp(
      home: Menu(),
    );

void main() {
  group('Menu Page Widget Tests', () {
    testWidgets('Test -  Home menu', (tester) async {
      await tester.pumpWidget(createMenu());
      expect(find.text("Home"), findsWidgets);
    });

    testWidgets('Test - Home icon', (tester) async {
      await tester.pumpWidget(createMenu());
      expect(find.byIcon(Icons.home), findsWidgets);
    });

    testWidgets('Test - Favorites menu', (tester) async {
      await tester.pumpWidget(createMenu());
      expect(find.text("Favorites"), findsWidgets);
    });

    testWidgets('Test - Favorites icon', (tester) async {
      await tester.pumpWidget(createMenu());
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('Test - Search History menu',
        (tester) async {
      await tester.pumpWidget(createMenu());
      expect(find.text("Search History"), findsWidgets);
    });

    testWidgets('Test - Search History icon',
        (tester) async {
      await tester.pumpWidget(createMenu());
      expect(find.byIcon(Icons.history), findsWidgets);
    });
  });
}
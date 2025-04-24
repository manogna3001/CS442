import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/views/search_results.dart';

Widget createSearchResults() => const MaterialApp(
      home: SearchResults(searchText: 'govenment'),
    );

void main() {
  group('Home Page Widget Tests', () {

    testWidgets('Test - Search icon', (tester) async {
      await tester.pumpWidget(createSearchResults());
      expect(find.byIcon(Icons.search), findsWidgets);
    });

  });
}
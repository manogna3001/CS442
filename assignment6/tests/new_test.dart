import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/views/newsapp.dart';
import 'package:cs442_mp6/views/search.dart';

class TestingApp extends StatelessWidget {
  const TestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NewsApp(),
    );
  }
}

void main() {
     
  group('Long scrolling test', () {
    testWidgets('Scroll to bottom', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const NewsApp(),
        );
        await tester.pumpAndSettle(const Duration(seconds: 5));
        await tester.dragUntilVisible(find.byKey(const ValueKey("icon_10")),
            find.byType(ListView), const Offset(0, -500));

        expect(find.byKey(const ValueKey("icon_10")), findsWidgets);
      });
    });
  });

  group('Search', () {
    testWidgets('Search function', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Search(),
          ),
        );

        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(find.text("Search"), findsWidgets);

       
        final button = find.byType(ElevatedButton);
        await tester.tap(button);
        await tester.pumpAndSettle();
        const Duration(seconds: 40);
      });
    });
  });
}
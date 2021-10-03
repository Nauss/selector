import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:selector/widgets/empty_search.dart';

void main() {
  testWidgets("Empty search displays correctly", (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: EmptySearch(
          query: "",
        ),
      ),
    );
    expect(find.text("Search artists, albums and more..."), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:selector/data/selector.dart';
import '../utils/setup.dart';

main() async {
  await initHive();
  group("Selector utils", () {
    group("Filter", () {
      Selector selector = Selector();
      selector.loadSelectorSearch();
      selector.loadRecords();
      test('empty query should return the full list', () {
        selector.filter("");
        expect(selector.recordsSubject.value, selector.records);
      });
      test('query = car should return only carlos', () async {
        selector.filter("car");
        expect(selector.recordsSubject.value.length, 1);
        final carlos = selector.recordsSubject.value[0];
        expect(carlos.info.artist, "Carlos");
      });
      // Other filters
      // Search history
    });
  });
}

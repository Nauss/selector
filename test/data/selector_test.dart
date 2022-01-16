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
        final records = selector.recordsSubject.valueWrapper?.value;
        expect(records, selector.records);
      });
      test('query = car should return only carlos', () async {
        selector.filter("car");
        final records = selector.recordsSubject.valueWrapper?.value;
        expect(records?.length, 1);
        final carlos = records?[0];
        expect(carlos?.info.artist, "Carlos");
      });
      // Other filters
      // Search history
    });
  });
}

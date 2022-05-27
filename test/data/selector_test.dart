import 'package:flutter_test/flutter_test.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';
import '../utils/records.dart';
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
    group("ensureRecordPosition", () {
      test('when empty add the record in 1 and then in 2', () {
        Selector selector = Selector();
        final record1 = Record(info: simpleInfo1);
        selector.ensureRecordPosition(record1);
        expect(record1.position, 1);
        selector.records.add(record1);

        final record2 = Record(info: simpleInfo2);
        selector.ensureRecordPosition(record2);
        expect(record2.position, 2);
      });
      test('add in the next possible position', () {
        Selector selector = Selector();
        final record1 = Record(info: simpleInfo1);
        record1.position = 1;
        selector.records.add(record1);
        final record2 = Record(info: simpleInfo2);
        record2.position = 2;
        selector.records.add(record2);
        final record3 = Record(info: simpleInfo1);
        record3.position = 4;
        selector.records.add(record3);

        final record = Record(info: simpleInfo1);
        selector.ensureRecordPosition(record);
        expect(record.position, 3);
      });
      test('handle full selector', () {
        Selector selector = Selector();
        for (var i = 0; i < selectorCapacity; i++) {
          final record = Record(info: simpleInfo1);
          record.position = i + 1;
          selector.records.add(record);
        }

        final record = Record(info: simpleInfo1);
        expect(() => selector.ensureRecordPosition(record), throwsException);
      });
      group("double vinyle", () {
        test('when empty add the record in 1 and then in 3', () {
          Selector selector = Selector();
          final record1 = Record(info: doubleInfo1);
          selector.ensureRecordPosition(record1);
          expect(record1.position, 1);
          selector.records.add(record1);

          final record2 = Record(info: doubleInfo2);
          selector.ensureRecordPosition(record2);
          expect(record2.position, 3);
        });
        test('add in the next possible position', () {
          Selector selector = Selector();
          final record1 = Record(info: simpleInfo1);
          record1.position = 1;
          selector.records.add(record1);
          final record2 = Record(info: simpleInfo2);
          record2.position = 2;
          selector.records.add(record2);
          final record3 = Record(info: simpleInfo1);
          record3.position = 4;
          selector.records.add(record3);

          final record = Record(info: doubleInfo1);
          selector.ensureRecordPosition(record);
          expect(record.position, 5);
        });
        test('add in the next possible even position', () {
          Selector selector = Selector();
          final record1 = Record(info: simpleInfo1);
          record1.position = 1;
          selector.records.add(record1);
          final record2 = Record(info: simpleInfo2);
          record2.position = 2;
          selector.records.add(record2);
          final record3 = Record(info: simpleInfo1);
          record3.position = 3;
          selector.records.add(record3);

          final record = Record(info: doubleInfo1);
          selector.ensureRecordPosition(record);
          expect(record.position, 5);
        });
        test('add in the next possible even position with a gap', () {
          Selector selector = Selector();
          final record1 = Record(info: simpleInfo1);
          record1.position = 1;
          selector.records.add(record1);
          final record2 = Record(info: simpleInfo2);
          record2.position = 2;
          selector.records.add(record2);
          final record3 = Record(info: simpleInfo1);
          record3.position = 3;
          selector.records.add(record3);
          final record4 = Record(info: simpleInfo1);
          record4.position = 5;
          selector.records.add(record4);

          final record = Record(info: doubleInfo1);
          selector.ensureRecordPosition(record);
          expect(record.position, 7);
        });
        test('add in the next possible even position with a gap landing on odd',
            () {
          Selector selector = Selector();
          final record1 = Record(info: simpleInfo1);
          record1.position = 1;
          selector.records.add(record1);
          final record2 = Record(info: simpleInfo2);
          record2.position = 2;
          selector.records.add(record2);
          final record3 = Record(info: simpleInfo1);
          record3.position = 3;
          selector.records.add(record3);
          final record4 = Record(info: simpleInfo1);
          record4.position = 6;
          selector.records.add(record4);

          final record = Record(info: doubleInfo1);
          selector.ensureRecordPosition(record);
          expect(record.position, 7);
        });
        test('handle full selector', () {
          Selector selector = Selector();
          // Fill with doubles
          for (var i = 0; i < selectorCapacity; i += 2) {
            final record = Record(info: doubleInfo1);
            record.position = i + 1;
            selector.records.add(record);
          }

          {
            final record = Record(info: doubleInfo1);
            expect(
                () => selector.ensureRecordPosition(record), throwsException);
          }
          {
            final record = Record(info: simpleInfo1);
            expect(
                () => selector.ensureRecordPosition(record), throwsException);
          }
        });
      });
    });
  });
}

import 'package:hive/hive.dart';
import 'package:selector/data/hive_ids.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/data/enums.dart';

part 'record.g.dart';

@HiveType(typeId: hiveRecordId)
class Record extends HiveObject {
  static const boxName = 'records';

  @HiveField(0)
  RecordStatus status;
  @HiveField(1)
  int position;
  @HiveField(2)
  RecordInfo info;
  @HiveField(3)
  bool isDouble;

  Record({
    required this.info,
    required this.isDouble,
    this.status = RecordStatus.none,
    this.position = -1,
  });

  String get uniqueId => '${info.id}-$position';
}

typedef RecordList = List<Record>;

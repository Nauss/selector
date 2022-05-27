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

  Record({
    required this.info,
    this.status = RecordStatus.missing,
    this.position = -1,
  });

  Future<void> store() async {
    // Get the box
    var box = Hive.box(boxName);
    await box.put(position, this);
  }

  // For now we check whether the record has tracks on C or D sides
  // to know if its a double
  bool get isDouble =>
      info.tracks.any((track) => track.side != Side.A && track.side != Side.B);

  String get uniqueId => '${info.id}-$position';
}

typedef RecordList = List<Record>;

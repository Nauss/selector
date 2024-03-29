import 'package:hive/hive.dart';
import 'package:selector/data/hive_ids.dart';

part 'enums.g.dart';

@HiveType(typeId: hiveRecordStatusId)
enum RecordStatus {
  @HiveField(0)
  none,
  @HiveField(1)
  inside,
  @HiveField(2)
  outside,
  @HiveField(3)
  removed,
}

@HiveType(typeId: hiveSideId)
enum Side {
  @HiveField(0)
  A,
  @HiveField(1)
  B,
  @HiveField(2)
  C,
  @HiveField(3)
  D,
}

@HiveType(typeId: hiveSortTypeId)
enum SortType {
  @HiveField(0)
  listening,
  @HiveField(1)
  mySelector,
  @HiveField(2)
  removed,
}

enum BlueToothState {
  noLocation,
  noBluetooth,
  bluetoothIsOff,
  disconnected,
  connecting,
  connected,
  sendingData,
  receivingData,
  offline
}

enum Scenario {
  add,
  addRemoved,
  addMore,
  store,
  listen,
  takeOut,
  remove,
  removeAlreadyOut,
  removePermanently,
  close,
}

enum CategoryFilter {
  none,
  listening,
  mySelector,
  removed,
}

// Parameters
@HiveType(typeId: hiveGridViewTypeId)
enum GridViewType {
  @HiveField(0)
  normal,
  @HiveField(1)
  large,
}

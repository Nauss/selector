// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordStatusAdapter extends TypeAdapter<RecordStatus> {
  @override
  final int typeId = 2;

  @override
  RecordStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecordStatus.missing;
      case 1:
        return RecordStatus.inside;
      case 2:
        return RecordStatus.outside;
      default:
        return RecordStatus.missing;
    }
  }

  @override
  void write(BinaryWriter writer, RecordStatus obj) {
    switch (obj) {
      case RecordStatus.missing:
        writer.writeByte(0);
        break;
      case RecordStatus.inside:
        writer.writeByte(1);
        break;
      case RecordStatus.outside:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SideAdapter extends TypeAdapter<Side> {
  @override
  final int typeId = 4;

  @override
  Side read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Side.A;
      case 1:
        return Side.B;
      case 2:
        return Side.C;
      case 3:
        return Side.D;
      default:
        return Side.A;
    }
  }

  @override
  void write(BinaryWriter writer, Side obj) {
    switch (obj) {
      case Side.A:
        writer.writeByte(0);
        break;
      case Side.B:
        writer.writeByte(1);
        break;
      case Side.C:
        writer.writeByte(2);
        break;
      case Side.D:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SideAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SortTypeAdapter extends TypeAdapter<SortType> {
  @override
  final int typeId = 6;

  @override
  SortType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortType.name;
      case 1:
        return SortType.artist;
      case 2:
        return SortType.favorites;
      case 3:
        return SortType.year;
      default:
        return SortType.name;
    }
  }

  @override
  void write(BinaryWriter writer, SortType obj) {
    switch (obj) {
      case SortType.name:
        writer.writeByte(0);
        break;
      case SortType.artist:
        writer.writeByte(1);
        break;
      case SortType.favorites:
        writer.writeByte(2);
        break;
      case SortType.year:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

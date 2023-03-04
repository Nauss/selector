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
        return RecordStatus.none;
      case 1:
        return RecordStatus.inside;
      case 2:
        return RecordStatus.outside;
      case 3:
        return RecordStatus.removed;
      default:
        return RecordStatus.none;
    }
  }

  @override
  void write(BinaryWriter writer, RecordStatus obj) {
    switch (obj) {
      case RecordStatus.none:
        writer.writeByte(0);
        break;
      case RecordStatus.inside:
        writer.writeByte(1);
        break;
      case RecordStatus.outside:
        writer.writeByte(2);
        break;
      case RecordStatus.removed:
        writer.writeByte(3);
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
        return SortType.listening;
      case 1:
        return SortType.mySelector;
      case 2:
        return SortType.removed;
      default:
        return SortType.listening;
    }
  }

  @override
  void write(BinaryWriter writer, SortType obj) {
    switch (obj) {
      case SortType.listening:
        writer.writeByte(0);
        break;
      case SortType.mySelector:
        writer.writeByte(1);
        break;
      case SortType.removed:
        writer.writeByte(2);
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

class GridViewTypeAdapter extends TypeAdapter<GridViewType> {
  @override
  final int typeId = 8;

  @override
  GridViewType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GridViewType.normal;
      case 1:
        return GridViewType.large;
      default:
        return GridViewType.normal;
    }
  }

  @override
  void write(BinaryWriter writer, GridViewType obj) {
    switch (obj) {
      case GridViewType.normal:
        writer.writeByte(0);
        break;
      case GridViewType.large:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridViewTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

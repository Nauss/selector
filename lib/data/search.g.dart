// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchAdapter extends TypeAdapter<Search> {
  @override
  final int typeId = 5;

  @override
  Search read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Search()
      ..history = (fields[0] as List).cast<String>()
      ..sortTypes = (fields[1] as List).cast<SortType>();
  }

  @override
  void write(BinaryWriter writer, Search obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.history)
      ..writeByte(1)
      ..write(obj.sortTypes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

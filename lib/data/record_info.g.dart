// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordInfoAdapter extends TypeAdapter<RecordInfo> {
  @override
  final int typeId = 1;

  @override
  RecordInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordInfo(
      id: fields[0] as int,
      title: fields[1] as String,
      artist: fields[2] as String,
      image: fields[3] as String,
      country: fields[4] as String,
      year: fields[5] as int,
      format: fields[6] as String,
      label: fields[7] as String,
      tracks: (fields[8] as List).cast<Track>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecordInfo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.format)
      ..writeByte(7)
      ..write(obj.label)
      ..writeByte(8)
      ..write(obj.tracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

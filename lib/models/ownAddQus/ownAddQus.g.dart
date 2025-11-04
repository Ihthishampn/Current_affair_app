// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ownAddQus.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OwnaddqusAdapter extends TypeAdapter<Ownaddqus> {
  @override
  final int typeId = 2;

  @override
  Ownaddqus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ownaddqus(
      questian: fields[0] as String,
      answer: fields[1] as String,
      status: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Ownaddqus obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.questian)
      ..writeByte(1)
      ..write(obj.answer)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnaddqusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_sync.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TableSyncAdapter extends TypeAdapter<TableSync> {
  @override
  final int typeId = 1;

  @override
  TableSync read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TableSync(
      tableName: fields[0] as String,
      lastReceived: fields[1] as DateTime?,
      lastSent: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TableSync obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.tableName)
      ..writeByte(1)
      ..write(obj.lastReceived)
      ..writeByte(2)
      ..write(obj.lastSent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableSyncAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableSync _$TableSyncFromJson(Map<String, dynamic> json) => TableSync(
      tableName: json['tableName'] as String,
      lastReceived: json['lastReceived'] == null
          ? null
          : DateTime.parse(json['lastReceived'] as String),
      lastSent: json['lastSent'] == null
          ? null
          : DateTime.parse(json['lastSent'] as String),
    );

Map<String, dynamic> _$TableSyncToJson(TableSync instance) => <String, dynamic>{
      'tableName': instance.tableName,
      'lastReceived': instance.lastReceived?.toIso8601String(),
      'lastSent': instance.lastSent?.toIso8601String(),
    };

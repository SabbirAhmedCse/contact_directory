// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactAdapter extends TypeAdapter<Contact> {
  @override
  final int typeId = 2;

  @override
  Contact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contact(
      id: fields[0] as int,
      unit: fields[1] as String?,
      subUnit: fields[2] as String?,
      subSubUnit: fields[3] as String?,
      designation: fields[4] as String?,
      mobileNumber: fields[5] as String?,
      email: fields[6] as String?,
      phone: fields[7] as String?,
      // Gracefully handle missing/older fields by providing sensible defaults
      isActive: (fields[8] as bool?) ?? true,
      isDeleted: (fields[9] as bool?) ?? false,
      createdOn: (fields[10] as DateTime?) ?? DateTime.now(),
      createdBy: fields[11] as String?,
      updatedOn: (fields[12] as DateTime?) ?? DateTime.now(),
      updatedBy: fields[13] as String?,
      deletedOn: (fields[14] as DateTime?) ?? DateTime(0),
      deletedBy: fields[15] as String?,
      isFavorite: (fields[16] as bool?) ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, Contact obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.subUnit)
      ..writeByte(3)
      ..write(obj.subSubUnit)
      ..writeByte(4)
      ..write(obj.designation)
      ..writeByte(5)
      ..write(obj.mobileNumber)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.isDeleted)
      ..writeByte(10)
      ..write(obj.createdOn)
      ..writeByte(11)
      ..write(obj.createdBy)
      ..writeByte(12)
      ..write(obj.updatedOn)
      ..writeByte(13)
      ..write(obj.updatedBy)
      ..writeByte(14)
      ..write(obj.deletedOn)
      ..writeByte(15)
      ..write(obj.deletedBy)
      ..writeByte(16)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      id: (json['id'] as num).toInt(),
      unit: json['unit'] as String?,
      subUnit: json['subUnit'] as String?,
      subSubUnit: json['subSubUnit'] as String?,
      designation: json['designation'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      isActive: json['isActive'] as bool,
      isDeleted: json['isDeleted'] as bool,
      createdOn: DateTime.parse(json['createdOn'] as String),
      createdBy: json['createdBy'] as String?,
      updatedOn: DateTime.parse(json['updatedOn'] as String),
      updatedBy: json['updatedBy'] as String?,
      deletedOn: DateTime.parse(json['deletedOn'] as String),
      deletedBy: json['deletedBy'] as String?,
      isFavorite: json['isFavorite'] as bool,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'id': instance.id,
      'unit': instance.unit,
      'subUnit': instance.subUnit,
      'subSubUnit': instance.subSubUnit,
      'designation': instance.designation,
      'mobileNumber': instance.mobileNumber,
      'email': instance.email,
      'phone': instance.phone,
      'isActive': instance.isActive,
      'isDeleted': instance.isDeleted,
      'createdOn': instance.createdOn.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedOn': instance.updatedOn.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'deletedOn': instance.deletedOn.toIso8601String(),
      'deletedBy': instance.deletedBy,
      'isFavorite': instance.isFavorite,
    };

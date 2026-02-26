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
      id: fields[0] as String,
      unit: fields[1] as String,
      subUnit: fields[2] as String,
      subSubUnit: fields[3] as String,
      designation: fields[4] as String,
      mobileNumber: fields[5] as String,
      email: fields[6] as String,
      phone: fields[7] as String,
      isActive: fields[8] as bool,
      isDeleted: fields[9] as bool,
      createdOn: fields[10] as DateTime,
      createdBy: fields[11] as String,
      updatedOn: fields[12] as DateTime,
      updatedBy: fields[13] as String,
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
      ..write(obj.updatedBy);
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

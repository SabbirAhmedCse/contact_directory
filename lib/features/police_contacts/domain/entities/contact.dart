import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/domain/constant/constant.dart';

part 'contact.g.dart';

@JsonSerializable()
@HiveType(typeId: policeDirectoryTypeId)
class Contact {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? unit;
  @HiveField(2)
  final String? subUnit;
  @HiveField(3)
  final String? subSubUnit;
  @HiveField(4)
  final String? designation;
  @HiveField(5)
  final String? mobileNumber;
  @HiveField(6)
  final String? email;
  @HiveField(7)
  final String? phone;
  @HiveField(8)
  final bool isActive;
  @HiveField(9)
  final bool isDeleted;
  @HiveField(10)
  final DateTime createdOn;
  @HiveField(11)
  final String? createdBy;
  @HiveField(12)
  final DateTime updatedOn;
  @HiveField(13)
  final String? updatedBy;
  @HiveField(14)
  final DateTime deletedOn;
  @HiveField(15)
  final String? deletedBy;
  @HiveField(16)
  final bool isFavorite;

  const Contact({
    required this.id,
    this.unit,
    this.subUnit,
    this.subSubUnit,
    this.designation, 
    this.mobileNumber,
    this.email,
    this.phone,
    required this.isActive,
    required this.isDeleted,
    required this.createdOn,
    this.createdBy,
    required this.updatedOn,
    this.updatedBy,
    required this.deletedOn,
    this.deletedBy,
    this.isFavorite = false,
  });

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);

  Contact copyWith({
    int? id,
    String? unit,
    String? subUnit,
    String? subSubUnit,
    String? designation,
    String? mobileNumber,
    String? email,
    String? phone,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdOn,
    String? createdBy,
    DateTime? updatedOn,
    String? updatedBy,
    DateTime? deletedOn,
    String? deletedBy,
    bool? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      subUnit: subUnit ?? this.subUnit,
      subSubUnit: subSubUnit ?? this.subSubUnit,
      designation: designation ?? this.designation,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdOn: createdOn ?? this.createdOn,
      createdBy: createdBy ?? this.createdBy,
      updatedOn: updatedOn ?? this.updatedOn,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedOn: deletedOn ?? this.deletedOn,
      deletedBy: deletedBy ?? this.deletedBy,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

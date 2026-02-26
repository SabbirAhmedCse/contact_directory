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
  });

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this); 
}

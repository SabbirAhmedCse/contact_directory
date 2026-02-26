import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 2)
class Contact {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String unit;
  @HiveField(2)
  final String subUnit;
  @HiveField(3)
  final String subSubUnit;
  @HiveField(4)
  final String designation;
  @HiveField(5)
  final String mobileNumber;
  @HiveField(6)
  final String email;
  @HiveField(7)
  final String phone;
  @HiveField(8)
  final bool isActive;
  @HiveField(9)
  final bool isDeleted;
  @HiveField(10)
  final DateTime createdOn;
  @HiveField(11)
  final String createdBy;
  @HiveField(12)
  final DateTime updatedOn;
  @HiveField(13)
  final String updatedBy;

  const Contact({
    required this.id,
    required this.unit,
    required this.subUnit,
    required this.subSubUnit,
    required this.designation,
    required this.mobileNumber,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.isDeleted,
    required this.createdOn,
    required this.createdBy,
    required this.updatedOn,
    required this.updatedBy,
  });
}

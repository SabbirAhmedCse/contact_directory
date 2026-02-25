import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../constant/constant.dart';

part 'table_sync.g.dart';

@JsonSerializable()
@HiveType(typeId: tableSyncTypeId) 
class TableSync {
  @HiveField(0)
  String tableName;
  
  @HiveField(1)
  DateTime? lastReceived;
  
  @HiveField(2)
  DateTime? lastSent;

  TableSync({
    required this.tableName,
    this.lastReceived,
    this.lastSent,
  });

  factory TableSync.fromJson(Map<String, dynamic> json) =>
      _$TableSyncFromJson(json);

  Map<String, dynamic> toJson() => _$TableSyncToJson(this); 
}
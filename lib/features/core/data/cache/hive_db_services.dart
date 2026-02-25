import '../../domain/constant/constant.dart';
import '../../domain/entity/table_sync.dart';
import 'generic_hive_service.dart';

class HiveDBServices {
  HiveDBServices._privateConstructor();
  static final HiveDBServices instance = HiveDBServices._privateConstructor();

  /// Services
  late final GenericHiveService<TableSync> tableSync;

  /// Initialize all services
  Future<void> init() async {
    tableSync = GenericHiveService<TableSync>(
      boxName: tableSyncBox,
      adapterId: tableSyncTypeId,
      adapter: TableSyncAdapter(),
      idSelector: (tableSync) => tableSync.tableName,
    );
    await closeAllBoxes();
    await initBoxes();
  }

  Future<void> initBoxes() async {
    await tableSync.init();
  }

  Future<void> closeAllBoxes() async { 
    await tableSync.close();
    return Future.value();
  }
}

import '../../domain/constant/constant.dart';
import '../../domain/entity/table_sync.dart';
import '../../../police_contacts/domain/entities/contact.dart';
import 'generic_hive_service.dart';

class HiveDBServices {
  HiveDBServices._privateConstructor();
  static final HiveDBServices instance = HiveDBServices._privateConstructor();

  /// Services
  late final GenericHiveService<TableSync> tableSync;
  late final GenericHiveService<Contact> policeContacts;

  /// Initialize all services
  Future<void> init() async {
    tableSync = GenericHiveService<TableSync>(
      boxName: tableSyncBox,
      adapterId: tableSyncTypeId,
      adapter: TableSyncAdapter(),
      idSelector: (tableSync) => tableSync.tableName,
    );

    policeContacts = GenericHiveService<Contact>(
      boxName: policeDirectoryBox,
      adapterId: policeDirectoryTypeId,
      adapter: ContactAdapter(),
      idSelector: (contact) => contact.id,
    );

    await closeAllBoxes();
    await initBoxes();
  }

  Future<void> initBoxes() async {
    await tableSync.init();
    await policeContacts.init();
  }

  Future<void> closeAllBoxes() async { 
    await tableSync.close();
    await policeContacts.close();
    return Future.value();
  }
}

import '../../domain/entities/contact.dart';
import '../../domain/entities/units.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_local_data_source.dart';
import '../datasources/contact_remote_data_source.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactLocalDataSource localDataSource;
  final ContactRemoteDataSource? remoteDataSource;

  ContactRepositoryImpl(this.localDataSource, {this.remoteDataSource});

  @override
  Future<List<Contact>> getContacts() {
    if (remoteDataSource == null) {
      return localDataSource.getContacts();
    }
    return remoteDataSource!.getContacts();
  }

  @override
  Future<void> addContact(Contact contact) {
    if (remoteDataSource == null) {
      return localDataSource.addContact(contact);
    }
    return remoteDataSource!
        .addContact(contact)
        .then((_) => localDataSource.addContact(contact));
  }

  @override
  Future<List<Unit>> getUnits() {
    return localDataSource.getUnits();
  }
}

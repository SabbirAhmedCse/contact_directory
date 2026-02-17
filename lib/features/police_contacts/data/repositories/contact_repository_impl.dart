import '../../domain/entities/contact.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_local_data_source.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactLocalDataSource localDataSource;

  ContactRepositoryImpl(this.localDataSource);

  @override
  Future<List<Contact>> getContacts() {
    return localDataSource.getContacts();
  }

  @override
  Future<void> addContact(Contact contact) {
    return localDataSource.addContact(contact);
  }
}

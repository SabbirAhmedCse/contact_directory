import '../entities/contact.dart';
import '../entities/units.dart';
import '../repositories/police_contacts_repository.dart';

class PoliceContactsUseCase {
  final PoliceContactsRepository repository;

  PoliceContactsUseCase(this.repository);

  Future<void> addContact(Contact contact) {
    return repository.addContact(contact);
  }

  Future<List<Contact>> getContacts() {
    return repository.getContacts();
  }

  Future<List<Unit>> getUnits() {
    return repository.getUnits();
  }
  
  Future<void> saveFavoriteContact(Contact contact) {
    return repository.saveFavoriteContact(contact);
  }
}
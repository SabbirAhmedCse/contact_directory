import '../entities/contact.dart';
import '../entities/units.dart';

abstract class PoliceContactsRepository {
  Future<List<Contact>> getContacts();
  Future<void> addContact(Contact contact);
  Future<List<Unit>> getUnits();
  Future<void> saveFavoriteContact(Contact contact);
}

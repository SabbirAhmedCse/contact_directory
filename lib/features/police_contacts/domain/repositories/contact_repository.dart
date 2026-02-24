import '../entities/contact.dart';
import '../entities/units.dart';

abstract class ContactRepository {
  Future<List<Contact>> getContacts();
  Future<void> addContact(Contact contact);
  Future<List<Unit>> getUnits();
}

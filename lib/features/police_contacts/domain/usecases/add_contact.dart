import '../entities/contact.dart';
import '../repositories/contact_repository.dart';

class AddContact {
  final ContactRepository repository;

  AddContact(this.repository);

  Future<void> call(Contact contact) {
    return repository.addContact(contact);
  }
}

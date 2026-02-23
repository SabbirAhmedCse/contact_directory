import 'package:firebase_database/firebase_database.dart';

import '../../domain/entities/contact.dart';

abstract class ContactRemoteDataSource {
  Future<List<Contact>> getContacts();
  Future<void> addContact(Contact contact);
}

class FirebaseContactRemoteDataSource implements ContactRemoteDataSource {
  final DatabaseReference ref;

  FirebaseContactRemoteDataSource(this.ref);

  @override
  Future<List<Contact>> getContacts() async {
    final DataSnapshot snapshot = await ref.get();
    final List<Contact> contacts = <Contact>[];

    final Object? value = snapshot.value;
    if (value is Map<Object?, Object?>) {
      value.forEach((Object? key, Object? raw) {
        if (raw is Map<Object?, Object?>) {
          final String? id = raw['id']?.toString();
          final String? name = raw['name']?.toString();
          final String? phone = raw['phone']?.toString();
          if (id != null && name != null && phone != null) {
            contacts.add(
              Contact(
                id: id,
                name: name,
                phone: phone,
              ),
            );
          }
        }
      });
    }

    return contacts;
  }

  @override
  Future<void> addContact(Contact contact) async {
    await ref.child(contact.id).set(<String, dynamic>{
      'id': contact.id,
      'name': contact.name,
      'phone': contact.phone,
    });
  }
}


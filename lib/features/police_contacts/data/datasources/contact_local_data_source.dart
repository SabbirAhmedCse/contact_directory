import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/contact.dart';

abstract class ContactLocalDataSource {
  Future<List<Contact>> getContacts();
  Future<void> addContact(Contact contact);
}

class HiveContactLocalDataSource implements ContactLocalDataSource {
  final Box<Map> box;

  HiveContactLocalDataSource(this.box);

  @override
  Future<List<Contact>> getContacts() async {
    if (box.isEmpty) {
      await _seedInitialData();
    }

    final List<Contact> contacts = <Contact>[];

    for (final dynamic value in box.values) {
      if (value is Map) {
        final String? id = value['id'] as String?;
        final String? name = value['name'] as String?;
        final String? phone = value['phone'] as String?;

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
    }

    return contacts;
  }

  @override
  Future<void> addContact(Contact contact) async {
    await box.put(
      contact.id,
      <String, String>{
        'id': contact.id,
        'name': contact.name,
        'phone': contact.phone,
      },
    );
  }

  Future<void> _seedInitialData() async {
    final List<Contact> initialContacts = <Contact>[
      const Contact(
        id: '1',
        name: 'Alice Johnson',
        phone: '555-0100',
      ),
      const Contact(
        id: '2',
        name: 'Bob Smith',
        phone: '555-0110',
      ),
    ];

    for (final Contact contact in initialContacts) {
      await addContact(contact);
    }
  }
}

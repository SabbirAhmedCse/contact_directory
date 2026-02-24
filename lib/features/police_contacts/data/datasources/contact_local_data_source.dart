import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/contact.dart';
import '../../domain/entities/units.dart';

abstract class ContactLocalDataSource {
  Future<List<Contact>> getContacts();
  Future<void> addContact(Contact contact);
  Future<List<Unit>> getUnits();
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

  @override
  Future<List<Unit>> getUnits() async {
    final String jsonString = await rootBundle.loadString(
      'lib/features/police_contacts/data/json/units.json',
    );

    final dynamic data = jsonDecode(jsonString);
    if (data is! List<dynamic>) {
      return <Unit>[];
    }

    return data
        .map<Unit>(
          (dynamic raw) => _mapToUnit(Map<String, dynamic>.from(raw as Map)),
        )
        .toList();
  }

  Unit _mapToUnit(Map<String, dynamic> map) {
    final List<dynamic> children =
        (map['units'] as List<dynamic>? ?? <dynamic>[]);

    return Unit(
      id: map['id'] as int,
      name: map['name'] as String,
      units: children
          .map<Unit>(
            (dynamic child) =>
                _mapToUnit(Map<String, dynamic>.from(child as Map)),
          )
          .toList(),
    );
  }
}

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/contact.dart';
import '../../domain/entities/units.dart';
import '../../domain/repositories/police_contacts_repository.dart';
import '../../../core/data/cache/hive_db_services.dart';

class PoliceContactsLocalDataSource implements PoliceContactsRepository {
  PoliceContactsLocalDataSource();
  final localDb = HiveDBServices.instance;

  @override
  Future<List<Contact>> getContacts() async {
    try {
      final  policeContactsBox = localDb.policeContacts;

      final List<Contact> contacts = await policeContactsBox.getAll();

      if (contacts.isNotEmpty) {
        return contacts;
      }

      final String jsonString = await rootBundle.loadString(
        'lib/features/police_contacts/data/json/police_contacts.json',
      );

      final List<Map<String, dynamic>> jsonList =
          List<Map<String, dynamic>>.from(json.decode(jsonString));

      final List<Contact> contactList = jsonList.map((e) {
        return Contact(
          id: e['id'],
          unit: e['unit'] ?? '',
          subUnit: e['subUnit'] ?? '',
          subSubUnit: e['subSubUnit'] ?? '',
          designation: e['designation'] ?? '',
          mobileNumber: e['mobileNumber'] ?? '',
          email: e['email'] ?? '',
          phone: e['phone'] ?? '',
          isActive: e['isActive'] ?? true,
          isDeleted: e['isDeleted'] ?? false,
          createdOn: DateTime.now(),
          updatedOn: DateTime.now(),
          deletedOn: DateTime.now(),
          createdBy: null,
          updatedBy: null,
          deletedBy: null,
          isFavorite: false,
        );
      }).toList();

      await policeContactsBox.upsertEntities(entities:contactList);

      return contactList;
    } catch (e) {
      throw Exception('Error loading contacts: $e');
    }
  }

  @override
  Future<void> addContact(Contact contact) async {
    await localDb.policeContacts.save(contact);
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
      logo: map['logo'] as String?,
      name: map['name'] as String,
      units: children
          .map<Unit>(
            (dynamic child) =>
                _mapToUnit(Map<String, dynamic>.from(child as Map)),
          )
          .toList(),
    );
  }

  @override
  Future<void> saveFavoriteContact(Contact contact) async {
    await localDb.policeContacts.save(contact);
  }
}

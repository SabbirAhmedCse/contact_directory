import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/contact.dart';
import '../../domain/entities/units.dart';
import '../../domain/repositories/police_contacts_repository.dart';



class PoliceContactsLocalDataSource implements PoliceContactsRepository {

  PoliceContactsLocalDataSource();

  @override
  Future<List<Contact>> getContacts() async {
    //if (box.isEmpty) {
      await _seedFromExcel();
    //}

    final List<Contact> contacts = <Contact>[];

    // for (final dynamic value in box.values) {
    //   if (value is Map) {
    //     final String? id = value['id'] as String?;
    //     final String? name = value['name'] as String?;
    //     final String? phone = value['phone'] as String?;

    //     if (id != null && name != null && phone != null) {
    //       contacts.add(
    //         Contact(
    //           id: id,
    //           name: name,
    //           phone: phone,
    //         ),
    //       );
    //     }
    //   }
    // }

    return contacts;
  }

  @override
  Future<void> addContact(Contact contact) async {
    // await box.put(
    //   contact.id,
    //   <String, String>{
    //     'id': contact.id,
    //     'name': contact.name,
    //     'phone': contact.phone,
    //   },
    // );
  }

  Future<void> _seedFromExcel() async {
    try {
      final ByteData data = await rootBundle.load(
        'lib/features/police_contacts/data/json/police_contacts.xlsx',
      );
      final List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final Excel excel = Excel.decodeBytes(bytes);

      for (final String table in excel.tables.keys) {
        final Sheet? sheet = excel.tables[table];
        if (sheet == null) continue;

        // Skip header row
        for (int i = 1; i < sheet.maxRows; i++) {
          final List<Data?> row = sheet.rows[i];
          if (row.length < 3) continue;

          final String name = row[0]?.value?.toString() ?? '';
          final String phone = row[1]?.value?.toString() ?? '';
          final String id = row[2]?.value?.toString() ?? i.toString();

          if (name.isNotEmpty && phone.isNotEmpty) {
            await addContact(Contact(id: id, name: name, phone: phone));
          }
        }
      }
    } catch (e) {
      // Fallback to initial data if excel fails
      await _seedInitialData();
    }
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

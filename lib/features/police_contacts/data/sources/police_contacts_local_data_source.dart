import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/contact.dart';
import '../../domain/entities/units.dart';
import '../../domain/repositories/police_contacts_repository.dart';
import '../../../core/data/cache/hive_db_services.dart';

class PoliceContactsLocalDataSource implements PoliceContactsRepository {
  PoliceContactsLocalDataSource();

  @override
  Future<List<Contact>> getContacts() async {
    final contacts = await HiveDBServices.instance.policeContacts.getAll();
    if (contacts.isEmpty) {
      await _seedFromExcel();
      return HiveDBServices.instance.policeContacts.getAll();
    }
    return contacts;
  }

  @override
  Future<void> addContact(Contact contact) async {
    await HiveDBServices.instance.policeContacts.save(contact);
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
          if (row.length < 8) continue;

          String cellValue(int index) {
            if (index >= row.length) return '';
            return row[index]?.value?.toString().trim() ?? '';
          }

          final String unit = cellValue(0);
          final String subUnit = cellValue(1);
          final String subSubUnit = cellValue(2);
          final String designation = cellValue(3);
          final String phone = cellValue(4);
          final String mobileNumber = cellValue(5);
          final String email = cellValue(7);

          if (unit.isNotEmpty || designation.isNotEmpty) {
            final contact = Contact(
              id: i,
              unit: unit,
              subUnit: subUnit,
              subSubUnit: subSubUnit,
              designation: designation,
              mobileNumber: mobileNumber,
              email: email,
              phone: phone,
              isActive: true,
              isDeleted: false,
              createdOn: DateTime.now(),
              createdBy: 'system',
              updatedOn: DateTime.now(),
              updatedBy: 'system',
            );
            await addContact(contact);
          }
        }
      }
    } catch (e) {
      // Fallback if excel fails
      await _seedInitialData();
    }
  }

  Future<void> _seedInitialData() async {
    final now = DateTime.now();
    final List<Contact> initialContacts = [
      Contact(
        id: 1,
        unit: 'PHQ',
        subUnit: '',
        subSubUnit: '',
        designation: 'IGP',
        mobileNumber: '0123456789',
        email: 'igp@police.gov.bd',
        phone: '555-0100',
        isActive: true,
        isDeleted: false,
        createdOn: now,
        createdBy: 'system',
        updatedOn: now,
        updatedBy: 'system',
      ),
    ];

    for (final contact in initialContacts) {
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

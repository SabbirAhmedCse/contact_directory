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
   
      await _seedFromExcel();
      return HiveDBServices.instance.policeContacts.getAll();
    
    //return contacts;
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

      final bytes = data.buffer.asUint8List();
      final excel = Excel.decodeBytes(bytes);

      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null || sheet.rows.isEmpty) continue;

        /// 🔥 Step 1: Read header row
        final headerRow = sheet.rows.first;

        Map<String, int> columnIndex = {};

        for (int i = 0; i < headerRow.length; i++) {
          final headerValue = headerRow[i]?.value
              ?.toString()
              .trim()
              .toLowerCase();

          if (headerValue != null && headerValue.isNotEmpty) {
            columnIndex[headerValue] = i;
          }
        }

        /// 🔥 Step 2: Helper to get value by column name
        String getValue(List<Data?> row, String columnName) {
          final index = columnIndex[columnName.toLowerCase()];
          if (index == null || index >= row.length) return '';
          final cell = row[index];
          if (cell == null || cell.value == null) return '';
          return cell.value.toString().trim();
        }

        /// 🔥 Step 3: Loop data rows
        for (int i = 1; i < sheet.rows.length; i++) {
          final row = sheet.rows[i];
          final id = getValue(row, 'id');
          final unit = getValue(row, 'unit');
          final subUnit = getValue(row, 'subUnit');
          final subSubUnit = getValue(row, 'subSubUnit');
          final designation = getValue(row, 'designation');
          final mobileNumber = getValue(row, 'mobileNumber');
          final email = getValue(row, 'email');
          final phone = getValue(row, 'phone');

          if (unit.isEmpty && designation.isEmpty) continue;

          final contact = Contact(
            id: int.parse(id),
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
            deletedOn: DateTime(0),
            deletedBy: '',
            isFavorite: false,
          );

          await addContact(contact);
        }
      }
    } catch (e) {
      rethrow;
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

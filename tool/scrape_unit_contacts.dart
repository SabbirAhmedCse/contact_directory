import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

class ContactRow {
  final String unitLevel1;
  final String unitLevel2;
  final String unitLevel3;
  final String designation;
  final String phoneOffice;
  final String mobile;
  final String fax;
  final String email;

  const ContactRow({
    required this.unitLevel1,
    required this.unitLevel2,
    required this.unitLevel3,
    required this.designation,
    required this.phoneOffice,
    required this.mobile,
    required this.fax,
    required this.email,
  });
}

Future<void> main(List<String> arguments) async {
  if (arguments.contains('--from-excel')) {
    final String excelPath =
        '${Directory.current.path}${Platform.pathSeparator}police_unit_contacts.xlsx';
    final List<ContactRow> excelRows = await _readContactsFromExcel(excelPath);
    await _uploadToFirebase(excelRows);
    stdout.writeln(
      'Uploaded ${excelRows.length} rows to Firebase from $excelPath',
    );
    return;
  }

  final List<ContactRow> rows = <ContactRow>[];
  final String unitContactHtml =
      await _fetchText('https://www.police.gov.bd/en/unitContact');
  final List<MapEntry<String, String>> topUnits =
      _parseTopUnits(unitContactHtml);

  for (final MapEntry<String, String> unit in topUnits) {
    await _fetchUnitContacts(
      unitId: unit.key,
      path: <String>[unit.value],
      rows: rows,
    );
  }

  final String outputPath =
      '${Directory.current.path}${Platform.pathSeparator}police_unit_contacts.xlsx';
  _writeExcel(outputPath, rows);
  await _uploadToFirebase(rows);

  stdout.writeln('Units scanned: ${topUnits.length}');
  stdout.writeln('Rows exported: ${rows.length}');
  stdout.writeln('Excel saved: $outputPath');
}

Future<void> _fetchUnitContacts({
  required String unitId,
  required List<String> path,
  required List<ContactRow> rows,
}) async {
  final Uri url = Uri.parse('https://www.police.gov.bd/en/units/$unitId');
  final http.Response response = await http.get(url);
  if (response.statusCode != 200) {
    return;
  }

  final dynamic data = jsonDecode(response.body);
  if (data is! Map<String, dynamic>) {
    return;
  }

  final String? type = data['type'] as String?;
  if (type == 'organograms') {
    final dynamic units = data['units'];
    if (units is Map) {
      for (final MapEntry entry in units.entries) {
        final dynamic unitData = entry.value;
        if (unitData is Map) {
          final String? childId = unitData['id']?.toString();
          final String? childName = unitData['name']?.toString();
          if (childId != null && childName != null) {
            await _fetchUnitContacts(
              unitId: childId,
              path: <String>[...path, childName],
              rows: rows,
            );
          }
        }
      }
    }
    return;
  }

  if (type == 'organogramContact') {
    final String? unitContact = data['unitContact'] as String?;
    if (unitContact == null || unitContact.trim().isEmpty) {
      return;
    }
    rows.addAll(_parseContactTable(unitContact, path));
  }
}

List<ContactRow> _parseContactTable(String htmlText, List<String> path) {
  final List<ContactRow> rows = <ContactRow>[];
  final document = html.parse(htmlText);
  final List<String> unitPath = List<String>.from(path);
  final String unitLevel1 = unitPath.isNotEmpty ? unitPath[0] : '';
  final String unitLevel2 = unitPath.length > 1 ? unitPath[1] : '';
  final String unitLevel3 =
      unitPath.length > 2 ? unitPath.sublist(2).join(' / ') : '';

  final tableRows = document.querySelectorAll('tr');
  for (final row in tableRows) {
    final cells = row.querySelectorAll('td');
    if (cells.isEmpty) {
      continue;
    }

    final List<String> values =
        cells.map((cell) => _cleanText(cell.text)).toList();
    if (values.every((value) => value.isEmpty)) {
      continue;
    }

    final List<String> normalized = _normalizeCells(values);
    rows.add(
      ContactRow(
        unitLevel1: unitLevel1,
        unitLevel2: unitLevel2,
        unitLevel3: unitLevel3,
        designation: normalized[0],
        phoneOffice: normalized[1],
        mobile: normalized[2],
        fax: normalized[3],
        email: normalized[4],
      ),
    );
  }

  return rows;
}

List<MapEntry<String, String>> _parseTopUnits(String htmlText) {
  final document = html.parse(htmlText);
  final select = document.querySelector('#unitName');
  if (select == null) {
    return <MapEntry<String, String>>[];
  }

  final List<MapEntry<String, String>> units = <MapEntry<String, String>>[];
  for (final option in select.querySelectorAll('option')) {
    final String? value = option.attributes['value'];
    final String name = _cleanText(option.text);
    if (value == null || value.isEmpty) {
      continue;
    }
    units.add(MapEntry<String, String>(value, name));
  }

  return units;
}

List<String> _normalizeCells(List<String> cells) {
  final List<String> normalized = List<String>.from(cells);
  while (normalized.length < 5) {
    normalized.add('');
  }
  if (normalized.length > 5) {
    final String email = normalized.sublist(4).join(' | ');
    return <String>[
      normalized[0],
      normalized[1],
      normalized[2],
      normalized[3],
      email,
    ];
  }
  return normalized;
}

String _cleanText(String value) {
  return value.replaceAll('\u00A0', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
}

Future<String> _fetchText(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch $url');
  }
  return response.body;
}

Future<List<ContactRow>> _readContactsFromExcel(String path) async {
  final File file = File(path);
  if (!file.existsSync()) {
    throw Exception('Excel file not found at $path');
  }
  final List<int> bytes = file.readAsBytesSync();
  final Excel excel = Excel.decodeBytes(bytes);
  if (excel.tables.isEmpty) {
    return <ContactRow>[];
  }
  final Sheet sheet = excel.tables.values.first;
  final List<ContactRow> rows = <ContactRow>[];
  bool isHeader = true;
  for (final List<Data?> row in sheet.rows) {
    if (isHeader) {
      isHeader = false;
      continue;
    }
    if (row.isEmpty) {
      continue;
    }
    String cellValue(int index) {
      if (index >= row.length) {
        return '';
      }
      final Data? data = row[index];
      if (data == null || data.value == null) {
        return '';
      }
      return data.value.toString().trim();
    }

    final String unitLevel1 = cellValue(0);
    final String unitLevel2 = cellValue(1);
    final String unitLevel3 = cellValue(2);
    final String designation = cellValue(3);
    final String phoneOffice = cellValue(4);
    final String mobile = cellValue(5);
    final String fax = cellValue(6);
    final String email = cellValue(7);

    if (unitLevel1.isEmpty &&
        unitLevel2.isEmpty &&
        unitLevel3.isEmpty &&
        designation.isEmpty &&
        phoneOffice.isEmpty &&
        mobile.isEmpty &&
        fax.isEmpty &&
        email.isEmpty) {
      continue;
    }

    rows.add(
      ContactRow(
        unitLevel1: unitLevel1,
        unitLevel2: unitLevel2,
        unitLevel3: unitLevel3,
        designation: designation,
        phoneOffice: phoneOffice,
        mobile: mobile,
        fax: fax,
        email: email,
      ),
    );
  }
  return rows;
}

Future<void> _uploadToFirebase(List<ContactRow> rows) async {
  final String? baseUrl = Platform.environment['FIREBASE_DB_URL'];
  final String? authToken = Platform.environment['FIREBASE_DB_AUTH'];
  if (baseUrl == null || baseUrl.isEmpty) {
    stdout.writeln('FIREBASE_DB_URL not set, skipping Firebase upload');
    return;
  }
  final String url = authToken == null || authToken.isEmpty
      ? '$baseUrl/police_contacts.json'
      : '$baseUrl/police_contacts.json?auth=$authToken';
  final Uri uri = Uri.parse(url);
  final List<Map<String, dynamic>> payload = rows
      .map(
        (ContactRow r) => <String, dynamic>{
          'unitLevel1': r.unitLevel1,
          'unitLevel2': r.unitLevel2,
          'unitLevel3': r.unitLevel3,
          'designation': r.designation,
          'phoneOffice': r.phoneOffice,
          'mobile': r.mobile,
          'fax': r.fax,
          'email': r.email,
        },
      )
      .toList();
  final http.Response response = await http.put(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(payload),
  );
  if (response.statusCode >= 200 && response.statusCode < 300) {
    stdout.writeln('Firebase upload completed');
  } else {
    stdout.writeln(
      'Firebase upload failed with status ${response.statusCode}: ${response.body}',
    );
  }
}

void _writeExcel(String outputPath, List<ContactRow> rows) {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['unit_contacts_3level'];
  sheet.appendRow(<dynamic>[
    'Unit Level 1',
    'Unit Level 2',
    'Unit Level 3',
    'Designation',
    'Phone (Office)',
    'Mobile',
    'Fax',
    'Email',
  ]);

  for (final ContactRow row in rows) {
    sheet.appendRow(<dynamic>[
      row.unitLevel1,
      row.unitLevel2,
      row.unitLevel3,
      row.designation,
      row.phoneOffice,
      row.mobile,
      row.fax,
      row.email,
    ]);
  }

  final List<int>? bytes = excel.encode();
  if (bytes == null) {
    throw Exception('Failed to encode Excel file');
  }
  File(outputPath).writeAsBytesSync(bytes, flush: true);
}

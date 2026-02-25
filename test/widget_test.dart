// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:contact_directory/features/police_contacts/domain/entities/contact.dart';
import 'package:contact_directory/features/police_contacts/domain/entities/units.dart';
import 'package:contact_directory/features/police_contacts/domain/repositories/police_contacts_repository.dart';
import 'package:contact_directory/features/police_contacts/domain/usecases/police_contacts_usecase.dart';
import 'package:contact_directory/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _InMemoryContactRepository implements PoliceContactsRepository {
  final List<Contact> _contacts = <Contact>[
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

  @override
  Future<void> addContact(Contact contact) async {
    _contacts.add(contact);
  }

  @override
  Future<List<Contact>> getContacts() async {
    return List<Contact>.unmodifiable(_contacts);
  }

  @override
  Future<List<Unit>> getUnits() {
    return Future<List<Unit>>.value(<Unit>[]);
  }
}

void main() {
  testWidgets(
    'Police contacts page shows initial data and allows adding a contact',
    (WidgetTester tester) async {
      final repository = _InMemoryContactRepository();
      final useCase = PoliceContactsUseCase(repository);

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<PoliceContactsUseCase>.value(value: useCase),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Police Contacts'), findsOneWidget);
      expect(find.text('Alice Johnson'), findsOneWidget);
      expect(find.text('Bob Smith'), findsOneWidget);

      await tester.enterText(
        find.byType(TextField).at(0),
        'Charlie Brown',
      );
      await tester.enterText(
        find.byType(TextField).at(1),
        '555-0123',
      );
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Charlie Brown'), findsOneWidget);
      expect(find.text('555-0123'), findsOneWidget);
    },
  );
}

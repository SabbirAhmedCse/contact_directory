import 'package:equatable/equatable.dart';

import '../../domain/entities/contact.dart';

enum ContactsStatus {
  initial,
  loading,
  loaded,
  failure,
}

class ContactsState extends Equatable {
  final ContactsStatus status;
  final List<Contact> contacts;

  const ContactsState({
    required this.status,
    required this.contacts,
  });

  const ContactsState.initial()
      : status = ContactsStatus.initial,
        contacts = const <Contact>[];

  ContactsState copyWith({
    ContactsStatus? status,
    List<Contact>? contacts,
  }) {
    return ContactsState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, contacts];
}

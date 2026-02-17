import 'package:equatable/equatable.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadContacts extends ContactsEvent {
  const LoadContacts();
}

class AddContactEvent extends ContactsEvent {
  final String name;
  final String phone;

  const AddContactEvent({
    required this.name,
    required this.phone,
  });

  @override
  List<Object?> get props => <Object?>[name, phone];
}

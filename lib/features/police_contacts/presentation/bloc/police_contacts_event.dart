part of 'police_contacts_bloc.dart';

abstract class PoliceContactsEvent extends Equatable {
  const PoliceContactsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadContacts extends PoliceContactsEvent {
  const LoadContacts();
}

class AddContactEvent extends PoliceContactsEvent {
  final String name;
  final String phone;

  const AddContactEvent({
    required this.name,
    required this.phone,
  });

  @override
  List<Object?> get props => <Object?>[name, phone];
}

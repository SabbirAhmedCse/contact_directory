part of 'police_contacts_bloc.dart';

enum PoliceContactsStatus {
  initial,
  loading,
  loaded,
  failure,
}

class PoliceContactsState extends Equatable {
  final PoliceContactsStatus? status;  
  final List<Contact> contacts;

  const PoliceContactsState({
     this.status,
     this.contacts = const [],
  });


  PoliceContactsState copyWith({
    PoliceContactsStatus? status,
    List<Contact>? contacts,
  }) {
    return PoliceContactsState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, contacts];
}

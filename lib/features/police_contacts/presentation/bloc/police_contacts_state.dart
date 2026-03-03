part of 'police_contacts_bloc.dart';

enum PoliceContactsStatus {
  policeContactsInitial,
  policeContactsLoading,
  policeContactsLoaded,
  policeContactsFailure,
}

class PoliceContactsState extends Equatable {
  final PoliceContactsStatus status;
  final List<Contact> allContacts;
  final List<Contact> filteredByUnitContacts;
  final List<Contact> filteredContacts;
  final List<Contact> favoriteContacts;

  const PoliceContactsState({
    this.status = PoliceContactsStatus.policeContactsInitial,
    this.allContacts = const [],
    this.filteredByUnitContacts = const [],
    this.filteredContacts = const [],
    this.favoriteContacts = const [],
  });

  PoliceContactsState copyWith({
    PoliceContactsStatus? status,
    List<Contact>? allContacts,
    List<Contact>? filteredByUnitContacts,
    List<Contact>? filteredContacts,
    List<Contact>? favoriteContacts,
  }) {
    return PoliceContactsState(
      status: status ?? this.status,
      allContacts: allContacts ?? this.allContacts,
      filteredByUnitContacts: filteredByUnitContacts ?? this.filteredByUnitContacts,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      favoriteContacts: favoriteContacts ?? this.favoriteContacts,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    allContacts,
    filteredByUnitContacts,
    filteredContacts,
    favoriteContacts,
  ];
}

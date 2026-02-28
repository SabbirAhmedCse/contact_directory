part of 'police_contacts_bloc.dart';

abstract class PoliceContactsEvent extends Equatable {
  const PoliceContactsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadContacts extends PoliceContactsEvent {
  const LoadContacts();
}

class SearchContacts extends PoliceContactsEvent {
  final String query;

  const SearchContacts({required this.query});

  @override
  List<Object?> get props => <Object?>[query];
}

class FilterContacts extends PoliceContactsEvent {
  final String? unit;
  final String? subUnit;
  final String? subSubUnit;

  const FilterContacts({required this.unit, required this.subUnit, required this.subSubUnit});

  @override
  List<Object?> get props => <Object?>[unit, subUnit, subSubUnit];
}

class SaveFavoriteContactEvent extends PoliceContactsEvent {
  final Contact contact;

  const SaveFavoriteContactEvent({required this.contact});

  @override
  List<Object?> get props => <Object?>[contact];
}

class GetFavoriteContactsEvent extends PoliceContactsEvent {
  const GetFavoriteContactsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class RemoveFavoriteContactEvent extends PoliceContactsEvent {
  final Contact contact;

  const RemoveFavoriteContactEvent({required this.contact});

  @override
  List<Object?> get props => <Object?>[contact];
}
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contact.dart';
import '../../domain/usecases/police_contacts_usecase.dart';
part 'police_contacts_event.dart';
part 'police_contacts_state.dart';

class PoliceContactsBloc extends Bloc<PoliceContactsEvent, PoliceContactsState> {
  final PoliceContactsUseCase policeContactsUseCase;
  PoliceContactsBloc(this.policeContactsUseCase) : super(PoliceContactsState()) { 
    on<LoadContacts>(_onLoadContacts);
    on<SearchContacts>(_onSearchContacts);
    on<FilterContacts>(_onFilterContacts);
    on<SaveFavoriteContactEvent>(_onSaveFavoriteContact);
    on<GetFavoriteContactsEvent>(_onGetFavoriteContacts);
    on<RemoveFavoriteContactEvent>(_onRemoveFavoriteContact);
  }

  Future<void> _onLoadContacts(
    LoadContacts event,
    Emitter<PoliceContactsState> emit,
  ) async {
    emit(state.copyWith(status: PoliceContactsStatus.policeContactsLoading));

    try {
      final List<Contact> contacts = await policeContactsUseCase.getContacts();
      emit(
        state.copyWith(
          status: PoliceContactsStatus.policeContactsLoaded,
          allContacts: contacts,
          favoriteContacts: contacts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PoliceContactsStatus.policeContactsFailure));
    }
  }

  Future<void> _onSearchContacts(
    SearchContacts event,
    Emitter<PoliceContactsState> emit,
  ) async {
    emit(state.copyWith(status: PoliceContactsStatus.policeContactsLoading));
    final List<Contact> filteredContacts = state.allContacts.where((Contact contact) {
      if (contact.designation?.toLowerCase().contains(event.query.toLowerCase()) ?? false) {
        return true;
      }
      return false;
    }).toList();
    emit(state.copyWith(status: PoliceContactsStatus.policeContactsLoaded, filteredContacts: filteredContacts));
  }

  Future<void> _onFilterContacts(
    FilterContacts event,
    Emitter<PoliceContactsState> emit,
  ) async {
    emit(state.copyWith(status: PoliceContactsStatus.policeContactsLoading));
    final List<Contact> filteredContacts = state.allContacts.where((Contact contact) {
      if (event.unit != null && contact.unit != event.unit) {
        return false;
      }
      if (event.subUnit != null && contact.subUnit != event.subUnit) {
        return false;
      }
      if (event.subSubUnit != null && contact.subSubUnit != event.subSubUnit) {
        return false;
      }
      return true;
    }).toList();
    emit(
      state.copyWith(
        status: PoliceContactsStatus.policeContactsLoaded,
        filteredContacts: filteredContacts,
      ),
    );
  }

  Future<void> _onSaveFavoriteContact(
    SaveFavoriteContactEvent event,
    Emitter<PoliceContactsState> emit,
  ) async {
    try {
      final List<Contact> contacts = await policeContactsUseCase.getContacts();
      emit(
        state.copyWith(
          status: PoliceContactsStatus.policeContactsLoaded,
          allContacts: contacts,
          favoriteContacts: contacts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PoliceContactsStatus.policeContactsFailure));
    }
  }

  Future<void> _onGetFavoriteContacts(
    GetFavoriteContactsEvent event,
    Emitter<PoliceContactsState> emit,
  ) async {
    emit(state.copyWith(status: PoliceContactsStatus.policeContactsLoading));
  }

  Future<void> _onRemoveFavoriteContact(
    RemoveFavoriteContactEvent event,
    Emitter<PoliceContactsState> emit,
  ) async {
    emit(state.copyWith(status: PoliceContactsStatus.policeContactsLoading));
  }
}

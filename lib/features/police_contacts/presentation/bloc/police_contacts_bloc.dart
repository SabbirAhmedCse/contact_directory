import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/utils/utils.dart';
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
          filteredContacts: contacts,
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
    final String query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          status: PoliceContactsStatus.policeContactsLoaded,
          filteredContacts: state.allContacts,
        ),
      );
      return;
    }

    final List<ScoredContact> scoredList = [];

    for (final contact in state.allContacts) {
      int score = 0;

      final designation = contact.designation?.toLowerCase() ?? '';
      final mobile = contact.mobileNumber?.toLowerCase() ?? '';
      final phone = contact.phone?.toLowerCase() ?? '';
      final unit = contact.unit?.toLowerCase() ?? '';

      // 🔹 1. Exact match (Highest score)
      if (designation == query) score += 50;
      if (mobile == query) score += 50;
      if (phone == query) score += 50;

      // 🔹 2. Contains match (Medium score)
      if (designation.contains(query)) score += 20;
      if (mobile.contains(query)) score += 20;
      if (phone.contains(query)) score += 20;
      if (unit.contains(query)) score += 10;

      // 🔹 3. Fuzzy match (Low score)
      if (isFuzzyMatch(designation, query)) score += 5;
      if (isFuzzyMatch(unit, query)) score += 5;

      if (score > 0) {
        scoredList.add(ScoredContact(contact, score));
      }
    }

    scoredList.sort((a, b) => b.score.compareTo(a.score));

    final filtered = scoredList.map((e) => e.contact).toList();

    emit(
      state.copyWith(
        status: PoliceContactsStatus.policeContactsLoaded,
        filteredContacts: filtered,
      ),
    );
  }

  Future<void> _onFilterContacts(
    FilterContacts event,
    Emitter<PoliceContactsState> emit,
  ) async {
    emit(state.copyWith(status: PoliceContactsStatus.policeContactsLoading));
    final List<Contact> filteredContacts = state.allContacts.where((Contact contact) {
      if (event.unit != null && contact.unit?.toLowerCase().trim() != event.unit?.toLowerCase().trim()) {
        return false;
      }
      if (event.subUnit != null && contact.subUnit?.toLowerCase().trim() != event.subUnit?.toLowerCase().trim()) {
        return false;
      }
      if (event.subSubUnit != null && contact.subSubUnit?.toLowerCase().trim() != event.subSubUnit?.toLowerCase().trim()) {
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
    final Contact updated = event.contact.copyWith(
      isFavorite: !event.contact.isFavorite,
    );
    await policeContactsUseCase.saveFavoriteContact(updated);
    final List<Contact> allContacts = state.allContacts
        .map((Contact c) => c.id == updated.id ? updated : c)
        .toList();
    final List<Contact> filteredContacts = state.filteredContacts
        .map((Contact c) => c.id == updated.id ? updated : c)
        .toList();
    emit(
      state.copyWith(
        status: PoliceContactsStatus.policeContactsLoaded,
        allContacts: allContacts,
        filteredContacts: filteredContacts,
      ),
    );
  }

  Future<void> _onGetFavoriteContacts(
    GetFavoriteContactsEvent event,
    Emitter<PoliceContactsState> emit,
  ) async {
    emit(state.copyWith(status: PoliceContactsStatus.policeContactsLoading));
    try {
      final List<Contact> favoriteContacts = state.allContacts.where((Contact contact) => contact.isFavorite).toList();
      emit(
        state.copyWith(
          status: PoliceContactsStatus.policeContactsLoaded,
          favoriteContacts: favoriteContacts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PoliceContactsStatus.policeContactsFailure));
    }
  }

  Future<void> _onRemoveFavoriteContact(
    RemoveFavoriteContactEvent event,
    Emitter<PoliceContactsState> emit,
  ) async {
    emit(state.copyWith(status: PoliceContactsStatus.policeContactsLoading));
    try {
      final Contact updated = event.contact.copyWith(
        isFavorite: false,
      );
      await policeContactsUseCase.saveFavoriteContact(updated);
      final List<Contact> allContacts = state.allContacts
          .map((Contact c) => c.id == updated.id ? updated : c)
          .toList();
      final List<Contact> filteredContacts = state.filteredContacts
          .map((Contact c) => c.id == updated.id ? updated : c)
          .toList();
          
      emit(
        state.copyWith(
          status: PoliceContactsStatus.policeContactsLoaded,
          allContacts: allContacts,
          filteredContacts: filteredContacts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PoliceContactsStatus.policeContactsFailure));
    }
  }
}

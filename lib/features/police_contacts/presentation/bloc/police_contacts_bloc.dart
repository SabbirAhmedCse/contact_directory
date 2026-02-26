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
    on<AddContactEvent>(_onAddContact);
  }

  Future<void> _onLoadContacts(
    LoadContacts event,
    Emitter<PoliceContactsState> emit,
  ) async {
    emit(state.copyWith(status: PoliceContactsStatus.loading));

    try {
      final List<Contact> contacts = await policeContactsUseCase.getContacts();
      emit(
        state.copyWith(
          status: PoliceContactsStatus.loaded,
          contacts: contacts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PoliceContactsStatus.failure));
    }
  }

  Future<void> _onAddContact(
    AddContactEvent event,
    Emitter<PoliceContactsState> emit,
  ) async {
    final now = DateTime.now();
    final Contact contact = Contact(
      id: now.millisecondsSinceEpoch.toString(),
      unit: '',
      subUnit: '',
      subSubUnit: '',
      designation: event.name, // Mapping name to designation for now
      mobileNumber: event.phone,
      email: '',
      phone: '',
      isActive: true,
      isDeleted: false,
      createdOn: now,
      createdBy: 'user',
      updatedOn: now,
      updatedBy: 'user',
    );

    try {
      await policeContactsUseCase.addContact(contact);
      final List<Contact> contacts = await policeContactsUseCase.getContacts();
      emit(
        state.copyWith(
          status: PoliceContactsStatus.loaded,
          contacts: contacts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PoliceContactsStatus.failure));
    }
  }
}

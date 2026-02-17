import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contact.dart';
import '../../domain/usecases/add_contact.dart';
import '../../domain/usecases/get_contacts.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final GetContacts getContacts;
  final AddContact addContact;

  ContactsBloc({
    required this.getContacts,
    required this.addContact,
  }) : super(const ContactsState.initial()) {
    on<LoadContacts>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
  }

  Future<void> _onLoadContacts(
    LoadContacts event,
    Emitter<ContactsState> emit,
  ) async {
    emit(state.copyWith(status: ContactsStatus.loading));

    try {
      final List<Contact> contacts = await getContacts();
      emit(
        state.copyWith(
          status: ContactsStatus.loaded,
          contacts: contacts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ContactsStatus.failure));
    }
  }

  Future<void> _onAddContact(
    AddContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    final Contact contact = Contact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: event.name,
      phone: event.phone,
    );

    try {
      await addContact(contact);
      final List<Contact> contacts = await getContacts();
      emit(
        state.copyWith(
          status: ContactsStatus.loaded,
          contacts: contacts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ContactsStatus.failure));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contact.dart';
import '../../domain/usecases/add_contact.dart';
import '../../domain/usecases/get_contacts.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';

class ContactsPage extends StatefulWidget {
  final GetContacts getContacts;
  final AddContact addContact;

  const ContactsPage({
    super.key,
    required this.getContacts,
    required this.addContact,
  });

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onAddPressed(BuildContext context) {
    final String name = _nameController.text.trim();
    final String phone = _phoneController.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      return;
    }

    _nameController.clear();
    _phoneController.clear();

    context.read<ContactsBloc>().add(
          AddContactEvent(
            name: name,
            phone: phone,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsBloc>(
      create: (BuildContext context) {
        return ContactsBloc(
          getContacts: widget.getContacts,
          addContact: widget.addContact,
        )..add(const LoadContacts());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Police Contacts'),
        ),
        body: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (BuildContext context, ContactsState state) {
            if (state.status == ContactsStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<Contact> contacts = state.contacts;

            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => _onAddPressed(context),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: contacts.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 1);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final Contact contact = contacts[index];
                      return ListTile(
                        title: Text(contact.name),
                        subtitle: Text(contact.phone),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

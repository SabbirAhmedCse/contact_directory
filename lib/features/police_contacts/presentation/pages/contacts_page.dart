import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contact.dart';
import '../../domain/entities/units.dart';
import '../../domain/usecases/add_contact.dart';
import '../../domain/usecases/get_contacts.dart';
import '../../domain/usecases/get_units.dart';
import '../../../core/presentation/widgets/common_text_field.dart';
import '../../../core/presentation/widgets/common_dropdown.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';

class ContactsDependencies {
  static late GetContacts getContacts;
  static late AddContact addContact;
  static late GetUnits getUnits;
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final List<Unit> _units = <Unit>[];
  Unit? _selectedUnit;
  final List<Unit> _childUnits = <Unit>[];
  Unit? _selectedChildUnit;
  final List<Unit> _grandChildUnits = <Unit>[];
  Unit? _selectedGrandChildUnit;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final List<Unit> units = await ContactsDependencies.getUnits();
    if (!mounted) {
      return;
    }
    setState(() {
      _units
        ..clear()
        ..addAll(units);
      if (_units.isNotEmpty) {
        _selectedUnit = _units.first;
        _childUnits
          ..clear()
          ..addAll(_selectedUnit!.units);
        _selectedChildUnit = _childUnits.isNotEmpty ? _childUnits.first : null;
        _grandChildUnits
          ..clear()
          ..addAll(_selectedChildUnit?.units ?? <Unit>[]);
        _selectedGrandChildUnit = _grandChildUnits.isNotEmpty
            ? _grandChildUnits.first
            : null;
        _selectedUnit = null;
        _childUnits.clear();
        _selectedChildUnit = null;
      }
      _grandChildUnits.clear();
      _selectedGrandChildUnit = null;
    });
  }


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
          getContacts: ContactsDependencies.getContacts,
          addContact: ContactsDependencies.addContact,
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: CommonDropdown<Unit>(
                    label: 'Unit',
                    initialValue: _selectedUnit,
                    items: _units
                        .map(
                          (Unit unit) => DropdownMenuItem<Unit>(
                            value: unit,
                            child: Text(unit.name),
                          ),
                        )
                        .toList(),
                    onChanged: (Unit? value) {
                      setState(() {
                        _selectedUnit = value;
                        _childUnits
                          ..clear()
                          ..addAll(value?.units ?? <Unit>[]);
                        _selectedChildUnit = _childUnits.isNotEmpty
                            ? _childUnits.first
                            : null;
                        _grandChildUnits
                          ..clear()
                          ..addAll(_selectedChildUnit?.units ?? <Unit>[]);
                        _selectedGrandChildUnit = _grandChildUnits.isNotEmpty
                            ? _grandChildUnits.first
                            : null;
                      });
                    },
                  ),
                ),
                if (_childUnits.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: CommonDropdown<Unit>(
                      label: 'Sub Unit',
                      initialValue: _selectedChildUnit,
                      items: _childUnits
                          .map(
                            (Unit unit) => DropdownMenuItem<Unit>(
                              value: unit,
                              child: Text(unit.name),
                            ),
                          )
                          .toList(),
                      onChanged: (Unit? value) {
                        setState(() {
                          _selectedChildUnit = value;
                          _grandChildUnits
                            ..clear()
                            ..addAll(value?.units ?? <Unit>[]);
                          _selectedGrandChildUnit = _grandChildUnits.isNotEmpty
                              ? _grandChildUnits.first
                              : null;
                        });
                      },
                    ),
                  ),
                if (_grandChildUnits.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: CommonDropdown<Unit>(
                      label: 'Sub Sub Unit',
                      initialValue: _selectedGrandChildUnit,
                      items: _grandChildUnits
                          .map(
                            (Unit unit) => DropdownMenuItem<Unit>(
                              value: unit,
                              child: Text(unit.name),
                            ),
                          )
                          .toList(),
                      onChanged: (Unit? value) {
                        setState(() {
                          _selectedGrandChildUnit = value;
                        });
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CommonTextField(
                          controller: _nameController,
                          label: 'Name',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CommonTextField(
                          controller: _phoneController,
                          label: 'Phone',
                          keyboardType: TextInputType.phone,
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

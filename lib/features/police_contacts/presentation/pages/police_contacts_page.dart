import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../domain/entities/contact.dart';
import '../../domain/entities/units.dart';
import '../../domain/usecases/police_contacts_usecase.dart';
import '../../../core/presentation/widgets/common_text_field.dart';
import '../../../core/presentation/widgets/common_dropdown.dart';
import '../bloc/police_contacts_bloc.dart';

class PoliceContactsPage extends StatefulWidget {
  const PoliceContactsPage({super.key});

  @override
  State<PoliceContactsPage> createState() => _PoliceContactsPageState();
}

class _PoliceContactsPageState extends State<PoliceContactsPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Unit> _units = <Unit>[];
  Unit? _selectedUnit;
  final List<Unit> _subUnits = <Unit>[];
  Unit? _selectedSubUnit;
  final List<Unit> _subSubUnits = <Unit>[];
  Unit? _selectedSubSubUnit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUnits();
      _loadContacts();
    });
  }

  Future<void> _loadUnits() async {
    final useCase = context.read<PoliceContactsUseCase>();
    final List<Unit> units = await useCase.getUnits();
    if (!mounted) {
      return;
    }
    setState(() {
      _units
        ..clear()
        ..addAll(units);
      _subSubUnits.clear();
      _selectedSubSubUnit = null;
      _selectedUnit = null;
      _subUnits.clear();
      _selectedSubUnit = null;
    });
  }
  Future<void> _loadContacts() async {
    context.read<PoliceContactsBloc>().add(const LoadContacts());
   
  }
  Future<void> _searchContacts(String query) async {
    final useCase = context.read<PoliceContactsUseCase>();
     // context.read<PoliceContactsBloc>().add(SearchContactsEvent(query: query));
  }

  @override
  void didUpdateWidget(PoliceContactsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.key != widget.key) {
      _loadContacts();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadContacts();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Police Contacts')),
      body: BlocBuilder<PoliceContactsBloc, PoliceContactsState>(
        builder: (BuildContext context, PoliceContactsState state) {
          if (state.status == PoliceContactsStatus.policeContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Contact> contacts = state.allContacts;

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                CommonTextField(
                  controller: _searchController,
                  label: 'Search Contact',
                  onChanged: (String value) {
                    // context.read<PoliceContactsBloc>().add(
                    //       SearchContactsEvent(query: value),
                    //     );
                  },
                ),
                Gap(16.h),
                CommonDropdown<Unit>(
                  label: 'Unit',
                  initialValue: _selectedUnit,
                  items: _units
                      .map(
                        (Unit unit) => DropdownMenuItem<Unit>(
                          value: unit,
                          child: Row(
                            children: [
                              const Icon(Icons.local_police),
                              Gap(8.w),
                              Expanded(
                                child: Text(
                                  unit.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (Unit? value) {
                    setState(() {
                      _selectedUnit = value;
                      _subUnits
                        ..clear()
                        ..addAll(value?.units ?? <Unit>[]);
                      _selectedSubUnit = null;
                      _subSubUnits.clear();
                      _selectedSubSubUnit = null;
                    });
                  },
                ),
                Gap(16.h),
                if (_subUnits.isNotEmpty) ...[
                  Row(
                    children: [
                      Expanded(
                        child: CommonDropdown<Unit>(
                          label: 'Sub Unit',
                          initialValue: _selectedSubUnit,
                          items: _subUnits
                              .map(
                                (Unit unit) => DropdownMenuItem<Unit>(
                                  value: unit,
                                  child: Text(unit.name),
                                ),
                              )
                              .toList(),
                          onChanged: (Unit? value) {
                            setState(() {
                              _selectedSubUnit = value;
                              _subSubUnits
                                ..clear()
                                ..addAll(value?.units ?? <Unit>[]);
                              _selectedSubSubUnit = null;
                            });
                          },
                        ),
                      ),

                      if (_subSubUnits.isNotEmpty) ...[
                        Gap(16.w),
                        Expanded(
                          child: CommonDropdown<Unit>(
                            label: 'Sub Sub Unit',
                            initialValue: _selectedSubSubUnit,
                            items: _subSubUnits
                                .map(
                                  (Unit unit) => DropdownMenuItem<Unit>(
                                    value: unit,
                                    child: Text(unit.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (Unit? value) {
                              setState(() {
                                _selectedSubSubUnit = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                Expanded(
                  child: ListView.separated(
                    itemCount: contacts.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 1);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final Contact contact = contacts[index];
                      return ListTile(
                        title: Text(contact.designation ?? ''),
                        subtitle: Text(
                          contact.mobileNumber?.isNotEmpty ?? false
                              ? contact.mobileNumber ?? ''
                              : contact.phone ?? '',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

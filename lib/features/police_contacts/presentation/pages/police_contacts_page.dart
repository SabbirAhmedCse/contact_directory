import 'package:contact_directory/features/police_contacts/presentation/widget/contact_primary_phone.dart';
import 'package:contact_directory/resources/resource_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../domain/entities/contact.dart';
import '../../domain/entities/units.dart';
import '../../domain/usecases/police_contacts_usecase.dart';
import '../bloc/police_contacts_bloc.dart';
import '../widget/contact_card.dart';
import '../widget/contact_details_dialog.dart';
import '../widget/contacts_list_header.dart';
import '../widget/empty_State.dart';
import '../widget/error_state.dart';
import '../widget/filter_section.dart';
import '../widget/police_contacts_app_bar.dart';
import '../widget/police_favorite_bottomsheet.dart';
import '../widget/loading_state.dart';
import '../widget/search_card.dart';
import '../widget/selected_unit_header.dart';
import '../widget/unit_selection_cards.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const double _horizontalPadding = 16;
const double _bottomPadding = 24;
const double _cardSpacing = 12;

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUnits() async {
    final useCase = context.read<PoliceContactsUseCase>();
    final List<Unit> units = await useCase.getUnits();
    if (!mounted) return;
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

  void _loadContacts() {
    context.read<PoliceContactsBloc>().add(const LoadContacts());
  }

  void _applyUnitFilter() {
    context.read<PoliceContactsBloc>().add(
      FilterContacts(
        unit: _selectedUnit?.name,
        subUnit: _selectedSubUnit?.name,
        subSubUnit: _selectedSubSubUnit?.name,
      ),
    );
  }

  void _onSearchChanged(String value) {
    context.read<PoliceContactsBloc>().add(SearchContacts(query: value.trim()));
  }

  bool get _isSelectionComplete {
    // If no unit is selected, selection is not complete
    if (_selectedUnit == null) return false;

    // Selection is complete if:
    // 1. A Unit is selected and it has no sub-units
    if (_subUnits.isEmpty) return true;

    // 2. A Sub Unit is selected and it has no sub-sub-units
    if (_selectedSubUnit != null && _subSubUnits.isEmpty) return true;

    // 3. A Sub Sub Unit is selected
    if (_selectedSubSubUnit != null) return true;

    return false;
  }

  void _onUnitCardTapped(Unit unit) {
    _onUnitChanged(unit);
  }

  void _onResetUnit() {
    setState(() {
      _selectedUnit = null;
      _subUnits.clear();
      _selectedSubUnit = null;
      _subSubUnits.clear();
      _selectedSubSubUnit = null;
    });
    _applyUnitFilter();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.resources.color;
    final style = context.resources.style;

    return Scaffold(
      backgroundColor: color.primaryColorBackground,
      appBar: PoliceContactsAppBar(color: color, style: style),
      body: BlocBuilder<PoliceContactsBloc, PoliceContactsState>(
        builder: (BuildContext context, PoliceContactsState state) {
          if (state.status == PoliceContactsStatus.policeContactsLoading &&
              state.allContacts.isEmpty) {
            return LoadingState(color: color, style: style);
          }
          if (state.status == PoliceContactsStatus.policeContactsFailure) {
            return ErrorState(
              color: color,
              style: style,
              onRetry: _loadContacts,
            );
          }

          final List<Contact> contacts = state.filteredContacts;
          final bool isComplete = _isSelectionComplete;

          if (_selectedUnit == null) {
            return UnitSelectionCards(
              units: _units,
              onUnitSelected: _onUnitCardTapped,
              color: color,
              style: style,
            );
          }

          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    _horizontalPadding.w,
                    16.h,
                    _horizontalPadding.w,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SelectedUnitHeader(
                        unit: _selectedUnit!,
                        onReset: _onResetUnit,
                        color: color,
                        style: style,
                      ),
                      Gap(16.h),
                      FilterSection(
                        units: _units,
                        selectedUnit: _selectedUnit,
                        subUnits: _subUnits,
                        selectedSubUnit: _selectedSubUnit,
                        subSubUnits: _subSubUnits,
                        selectedSubSubUnit: _selectedSubSubUnit,
                        onUnitChanged: _onUnitChanged,
                        onSubUnitChanged: _onSubUnitChanged,
                        onSubSubUnitChanged: _onSubSubUnitChanged,
                        color: color,
                        style: style,
                      ),
                      if (isComplete) ...[
                        Gap(16.h),
                        SearchCard(
                          controller: _searchController,
                          hint: 'Search by name, designation, or number',
                          onChanged: _onSearchChanged,
                          color: color,
                          style: style,
                        ),
                        Gap(20.h),
                        ContactsListHeader(
                          count: contacts.length,
                          color: color,
                          style: style,
                        ),
                        Gap(12.h),
                      ],
                    ],
                  ),
                ),
              ),
              if (isComplete) ...[
                if (contacts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(style: style, color: color),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      _horizontalPadding.w,
                      0,
                      _horizontalPadding.w,
                      _bottomPadding.h,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((
                        BuildContext context,
                        int index,
                      ) {
                        final contact = contacts[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: _cardSpacing.h),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    ContactDetailsDialog(contact: contact),
                              );
                            },
                            child: ContactCard(
                              contact: contact,
                              primaryPhone: contact.primaryPhone,
                              color: color,
                              style: style,
                            ),
                          ),
                        );
                      }, childCount: contacts.length),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        duration: const Duration(milliseconds: 800),
        curve: Curves.bounceIn,
        builder: (context, double scale, child) {
          return Transform.scale(
            scale: scale,
            child: FloatingActionButton(
              onPressed: () {
                policeFavoriteContactsBottomSheet(context:context);
              },
              backgroundColor: Colors.red,
              child: const Icon(size: 40, Icons.favorite, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  void _onUnitChanged(Unit? value) {
    setState(() {
      _selectedUnit = value;
      _subUnits
        ..clear()
        ..addAll(value?.units ?? <Unit>[]);
      _selectedSubUnit = null;
      _subSubUnits.clear();
      _selectedSubSubUnit = null;
    });
    _applyUnitFilter();
  }

  void _onSubUnitChanged(Unit? value) {
    setState(() {
      _selectedSubUnit = value;
      _subSubUnits
        ..clear()
        ..addAll(value?.units ?? <Unit>[]);
      _selectedSubSubUnit = null;
    });
    _applyUnitFilter();
  }

  void _onSubSubUnitChanged(Unit? value) {
    setState(() => _selectedSubSubUnit = value);
    _applyUnitFilter();
  }
}

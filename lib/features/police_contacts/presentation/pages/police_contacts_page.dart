import 'package:contact_directory/features/police_contacts/presentation/widget/contact_primary_phone.dart';
import 'package:contact_directory/resources/resource_export.dart';
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
import '../widget/contact_card.dart';
import '../widget/contact_details_dialog.dart';
import '../widget/empty_State.dart';
import '../widget/error_state.dart';
import '../widget/police_favorite_bottomsheet.dart';
import '../widget/loading_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final color = context.resources.color;
    final style = context.resources.style;

    return Scaffold(
      backgroundColor: color.primaryColorBackground,
      appBar: _PoliceContactsAppBar(color: color, style: style),
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
                      _SearchCard(
                        controller: _searchController,
                        hint: 'Search by name, designation, or number',
                        onChanged: _onSearchChanged,
                        color: color,
                        style: style,
                      ),
                      Gap(16.h),
                      _FilterSection(
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
                      Gap(20.h),
                      _ContactsListHeader(
                        count: contacts.length,
                        color: color,
                        style: style,
                      ),
                      Gap(12.h),
                    ],
                  ),
                ),
              ),
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

// ---------------------------------------------------------------------------
// App bar & state widgets
// ---------------------------------------------------------------------------

class _PoliceContactsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _PoliceContactsAppBar({required this.color, required this.style});

  final AppColors color;
  final AppTextStyle style;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: color.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20.sp,
          color: color.primaryTextColor,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Police Contacts',
        style: style.w700s18(color.primaryTextColor),
      ),
      centerTitle: false,
    );
  }
}

// ---------------------------------------------------------------------------
// Filter section
// ---------------------------------------------------------------------------

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.units,
    required this.selectedUnit,
    required this.subUnits,
    required this.selectedSubUnit,
    required this.subSubUnits,
    required this.selectedSubSubUnit,
    required this.onUnitChanged,
    required this.onSubUnitChanged,
    required this.onSubSubUnitChanged,
    required this.color,
    required this.style,
  });

  final List<Unit> units;
  final Unit? selectedUnit;
  final List<Unit> subUnits;
  final Unit? selectedSubUnit;
  final List<Unit> subSubUnits;
  final Unit? selectedSubSubUnit;
  final ValueChanged<Unit?> onUnitChanged;
  final ValueChanged<Unit?> onSubUnitChanged;
  final ValueChanged<Unit?> onSubSubUnitChanged;
  final AppColors color;
  final AppTextStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Filter by unit', style: style.w600s14(color.primaryTextColor)),
        Gap(10.h),
        CommonDropdown<Unit>(
          label: 'Unit',
          initialValue: selectedUnit,
          items: units
              .map(
                (Unit unit) => DropdownMenuItem<Unit>(
                  value: unit,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.account_balance_rounded,
                        size: 20.sp,
                        color: color.primaryColor,
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Text(
                          unit.name,
                          overflow: TextOverflow.ellipsis,
                          style: style.w500s14(color.primaryTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onUnitChanged,
        ),
        if (subUnits.isNotEmpty) ...[
          Gap(12.h),
          Row(
            children: <Widget>[
              Expanded(
                child: CommonDropdown<Unit>(
                  label: 'Sub unit',
                  initialValue: selectedSubUnit,
                  items: subUnits
                      .map(
                        (Unit unit) => DropdownMenuItem<Unit>(
                          value: unit,
                          child: Text(
                            unit.name,
                            overflow: TextOverflow.ellipsis,
                            style: style.w500s14(color.primaryTextColor),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onSubUnitChanged,
                ),
              ),
              if (subSubUnits.isNotEmpty) ...[
                Gap(12.w),
                Expanded(
                  child: CommonDropdown<Unit>(
                    label: 'Sub sub unit',
                    initialValue: selectedSubSubUnit,
                    items: subSubUnits
                        .map(
                          (Unit unit) => DropdownMenuItem<Unit>(
                            value: unit,
                            child: Text(
                              unit.name,
                              overflow: TextOverflow.ellipsis,
                              style: style.w500s14(color.primaryTextColor),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: onSubSubUnitChanged,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// List header
// ---------------------------------------------------------------------------

class _ContactsListHeader extends StatelessWidget {
  const _ContactsListHeader({
    required this.count,
    required this.color,
    required this.style,
  });

  final int count;
  final AppColors color;
  final AppTextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('Contacts', style: style.w700s16(color.primaryTextColor)),
        Gap(8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text('$count', style: style.w600s12(color.primaryColor)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Search card
// ---------------------------------------------------------------------------

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.color,
    required this.style,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final AppColors color;
  final AppTextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.primaryTextColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CommonTextField(
        controller: controller,
        label: 'Search',
        hintText: hint,
        onChanged: onChanged,
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 22.sp,
          color: color.iconColor,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}



// ---------------------------------------------------------------------------
// Contact extension
// ---------------------------------------------------------------------------



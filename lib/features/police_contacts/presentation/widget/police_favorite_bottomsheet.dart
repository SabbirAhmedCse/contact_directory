import 'package:contact_directory/resources/resource_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../domain/entities/contact.dart';
import '../bloc/police_contacts_bloc.dart';
import 'contact_card.dart';
import 'contact_details_dialog.dart';
import 'empty_State.dart';
import 'error_state.dart';
import 'loading_state.dart';


void policeFavoriteContactsBottomSheet({
  required BuildContext context,
}) async {
  context.read<PoliceContactsBloc>().add(const GetFavoriteContactsEvent());
  void loadContacts() {
     context.read<PoliceContactsBloc>().add(const GetFavoriteContactsEvent());
  }
  
  showModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withOpacity(0.65),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.r), topLeft: Radius.circular(16.r)),
    ),
    builder: (BuildContext context) {
      const double _horizontalPadding = 16;
      const double _bottomPadding = 24;
      const double _cardSpacing = 12;
      final color = context.resources.color;
      final style = context.resources.style;
      return  BlocBuilder<PoliceContactsBloc, PoliceContactsState>(
        builder: (BuildContext context, PoliceContactsState state) {
          if (state.status == PoliceContactsStatus.policeContactsLoading &&
              state.allContacts.isEmpty) {
            return LoadingState(color: color, style: style);
          }
          if (state.status == PoliceContactsStatus.policeContactsFailure) {
            return ErrorState(
              color: color,
              style: style,
              onRetry: loadContacts,
            );
          }

          final List<Contact> contacts = state.favoriteContacts;

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
                      // _ContactsListHeader(
                      //   count: contacts.length,
                      //   color: color,
                      //   style: style,
                      // ),
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
      );
    },
  );
}

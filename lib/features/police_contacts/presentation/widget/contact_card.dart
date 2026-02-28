import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';
import '../../domain/entities/contact.dart';
import '../bloc/police_contacts_bloc.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, 
    required this.contact,
    required this.primaryPhone,
    required this.color,
    required this.style,
  });

  final Contact contact;
  final String primaryPhone;
  final AppColors color;
  final AppTextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.primaryColorBorder, width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.primaryTextColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: color.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.person_rounded,
              size: 24.sp,
              color: color.primaryColor,
            ),
          ),
          Gap(14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  contact.designation ?? '—',
                  style: style.w600s14(color.primaryTextColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (contact.unit != null && contact.unit!.isNotEmpty) ...[
                  Gap(4.h),
                  Text(
                    contact.unit!,
                    style: style.w400s12(color.tertiaryTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (primaryPhone.isNotEmpty) ...[
                  Gap(8.h),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.phone_rounded,
                        size: 16.sp,
                        color: color.primaryColor,
                      ),
                      Gap(6.w),
                      SelectableText(
                        primaryPhone,
                        style: style.w500s14(color.primaryColor),
                      ),
                    ],
                  ),
                ],
                if (contact.email != null &&
                    contact.email!.isNotEmpty &&
                    primaryPhone.isNotEmpty) ...[
                  Gap(4.h),
                ],
                if (contact.email != null && contact.email!.isNotEmpty) ...[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.mail_outline_rounded,
                        size: 16.sp,
                        color: color.tertiaryTextColor,
                      ),
                      Gap(6.w),
                      Expanded(
                        child: SelectableText(
                          contact.email!,
                          style: style.w400s12(color.tertiaryTextColor),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (primaryPhone.isNotEmpty)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<PoliceContactsBloc>().add(
                    SaveFavoriteContactEvent(contact: contact),
                  );
                },
                borderRadius: BorderRadius.circular(10.r),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    contact.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                    size: 22.sp,
                    color: color.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';

class ContactsListHeader extends StatelessWidget {
  const ContactsListHeader({super.key, 
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

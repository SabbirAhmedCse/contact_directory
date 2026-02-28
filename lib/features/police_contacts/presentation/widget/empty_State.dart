import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.style, required this.color});

  final AppTextStyle style;
  final AppColors color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.contact_phone_outlined,
              size: 64.sp,
              color: color.iconColor,
            ),
            Gap(16.h),
            Text(
              'No contacts found',
              style: style.w600s16(color.primaryTextColor),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              'Try a different search or filter.',
              style: style.w400s14(color.tertiaryTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

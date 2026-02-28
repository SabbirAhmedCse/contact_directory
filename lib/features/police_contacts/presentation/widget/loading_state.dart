import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, required this.color, required this.style});

  final AppColors color;
  final AppTextStyle style;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: color.primaryColor,
            ),
          ),
          Gap(16.h),
          Text(
            'Loading contacts…',
            style: style.w400s14(color.tertiaryTextColor),
          ),
        ],
      ),
    );
  }
}

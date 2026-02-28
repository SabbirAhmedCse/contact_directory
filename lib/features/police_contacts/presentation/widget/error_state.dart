import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, 
    required this.color,
    required this.style,
    required this.onRetry,
  });

  final AppColors color;
  final AppTextStyle style;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error_outline_rounded, size: 48.sp, color: color.appRed),
          Gap(12.h),
          Text(
            'Could not load contacts',
            style: style.w600s16(color.primaryTextColor),
            textAlign: TextAlign.center,
          ),
          Gap(8.h),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

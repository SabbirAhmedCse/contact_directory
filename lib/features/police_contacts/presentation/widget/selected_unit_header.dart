import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';
import '../../domain/entities/units.dart';

class SelectedUnitHeader extends StatelessWidget {
  const SelectedUnitHeader({super.key, 
    required this.unit,
    required this.onReset,
    required this.color,
    required this.style,
  });

  final Unit unit;
  final VoidCallback onReset;
  final AppColors color;
  final AppTextStyle style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onReset,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.primaryColor.withOpacity(0.2)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.primaryColor,
                shape: BoxShape.circle,
              ),
              child: unit.logo != null
                  ? Image.asset(unit.logo!, width: 20.sp, height: 20.sp)
                  : Icon(
                      Icons.account_balance_rounded,
                      size: 20.sp,
                      color: color.white,
                    ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selected Unit',
                    style: style.w500s12(
                      color.primaryTextColor.withOpacity(0.6),
                    ),
                  ),
                  Text(unit.name, style: style.w700s16(color.primaryTextColor)),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: onReset,
              icon: Icon(Icons.change_circle_outlined, size: 20.sp),
              label: Text('Change', style: style.w600s14(color.primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}

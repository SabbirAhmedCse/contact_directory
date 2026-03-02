import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';
import '../../domain/entities/units.dart';

class UnitSelectionCards extends StatelessWidget {
  const UnitSelectionCards({super.key, 
    required this.units,
    required this.onUnitSelected,
    required this.color,
    required this.style,
  });

  final List<Unit> units;
  final ValueChanged<Unit> onUnitSelected;
  final AppColors color;
  final AppTextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gap(16.h),
          Text(
            'Select a Unit to continue',
            style: style.w700s18(color.primaryTextColor),
          ),
          Gap(4.h),
          Text(
            'Choose the main department to see contacts',
            style: style.w400s14(color.primaryTextColor.withOpacity(0.6)),
          ),
          Gap(20.h),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(bottom: 24.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.1,
              ),
              itemCount: units.length,
              itemBuilder: (context, index) {
                final unit = units[index];
                return GestureDetector(
                  onTap: () => onUnitSelected(unit),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: color.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: color.primaryTextColor.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: color.primaryColor.withOpacity(0.05),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: color.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: unit.logo != null
                              ? Image.asset(
                                  unit.logo!,
                                  width: 24.sp,
                                  height: 24.sp,
                                )
                              : Icon(
                                  Icons.account_balance_rounded,
                                  size: 24.sp,
                                  color: color.primaryColor,
                                ),
                        ),
                        Gap(12.h),
                        Text(
                          unit.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: style.w700s14(color.primaryTextColor),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

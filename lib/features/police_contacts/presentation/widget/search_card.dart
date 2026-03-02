import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';
import '../../../core/presentation/widgets/common_text_field.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({super.key, 
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

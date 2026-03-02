import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';

class PoliceContactsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PoliceContactsAppBar({super.key, required this.color, required this.style});

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

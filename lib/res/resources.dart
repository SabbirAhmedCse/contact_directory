import 'package:flutter/cupertino.dart';
import '../../res/drawable/app_drawable.dart';
import '../resources/colors/app_colors.dart';
import '../resources/dimensions/app_dimension.dart';
import '../resources/style/app_style.dart';

class Resources {

  final BuildContext _context;
  Resources(this._context);

  

  AppDrawable get drawable {
    return AppDrawable();
  }
  AppColors get color {
    return AppColors();
  }

  AppDimension get dimension {
    return AppDimension();
  }

  AppTextStyle get style {
    return AppTextStyle();
  }

  static Resources of(BuildContext context){
    return Resources(context);
  }
}
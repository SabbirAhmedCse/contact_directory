import 'package:flutter/cupertino.dart';
import '../../res/drawable/app_drawable.dart';

class Resources {

  final BuildContext _context;
  Resources(this._context);

  

  AppDrawable get drawable {
    return AppDrawable();
  }

  static Resources of(BuildContext context){
    return Resources(context);
  }
}
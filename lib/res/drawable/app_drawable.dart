import 'drawable.dart';

class AppDrawable implements BasicDrawable {
  String baseSvg = "assets/svg/";
  String baseImage = "assets/images/";
  String baseIcon = "assets/icons/";

  @override
  String get bangladeshPoliceLogo =>
      "${baseImage}bangladesh_police_logo.png";
}

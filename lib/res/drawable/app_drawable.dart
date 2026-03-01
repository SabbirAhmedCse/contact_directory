import 'drawable.dart';

class AppDrawable implements BasicDrawable {
  String baseSvg = "assets/svg/";
  String baseImage = "assets/images/";
  String baseIcon = "assets/icons/";

  @override
  String get bangladeshPoliceLogo =>
      "${baseImage}bangladesh_police_logo.png";
  @override
  String get antiTerrorismUnitPoliceLogo =>
      "${baseImage}anti_terrorism_unit_police_logo.png";
  @override
  String get armedPoliceBattalionPoliceLogo =>
      "${baseImage}armed_police_battalion_police_logo.png";
  @override
  String get bangladeshIndustrialPoliceLogo =>
      "${baseImage}bangladesh_industrial_police_logo.png";
  @override
  String get centralPoliceHospitalLogo =>
      "${baseImage}central_police_hospital_logo.png";
  @override
  String get highwayPoliceLogo =>
      "${baseImage}highway_police_logo.png";
  @override
  String get policeBureauOfInvestigationLogo =>
      "${baseImage}police_bureau_of_investigation_logo.png";
  @override
  String get policeHeadQuartersLogo =>
      "${baseImage}police_head_quarters_logo.png";
  @override
  String get rabLogo =>
      "${baseImage}rab_logo.png";
  @override
  String get riverPoliceLogo =>
      "${baseImage}river_police_logo.png";
  @override
  String get specialBranchPoliceLogo =>
      "${baseImage}special_branch_police_logo.png";
  @override
  String get touristPoliceLogo =>
      "${baseImage}tourist_police_logo.png";
}

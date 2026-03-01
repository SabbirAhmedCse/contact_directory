class Unit {
  final int id;
  final String? logo;
  final String name;
  final List<Unit> units;

  Unit({required this.id, this.logo, required this.name, this.units = const []});
}
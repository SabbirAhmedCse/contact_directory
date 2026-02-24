class Unit {
  final int id;
  final String name;
  final List<Unit> units;

  Unit({required this.id, required this.name, this.units = const []});
}
import 'package:hive/hive.dart';


/// BaseDb is your existing base class (unchanged)
class GenericHiveService<T> {
  final String boxName;
  final int adapterId;
  final TypeAdapter<T> adapter;
  final dynamic Function(T) idSelector;

  Box<T>? _box;

  GenericHiveService({
    required this.boxName,
    required this.adapterId,
    required this.adapter,
    required this.idSelector,
  });

  Future<void> init() async {
    final fullName = boxName;

    if (!Hive.isAdapterRegistered(adapterId)) {
      Hive.registerAdapter(adapter);
    }

    if (!Hive.isBoxOpen(fullName)) {
      _box = await Hive.openBox<T>(fullName);
    } else {
      _box = Hive.box<T>(fullName);
    }
  }

  Future<Box<T>> get _open async {
    final fullName = boxName;
    if (_box == null || !_box!.isOpen) {
      if (!Hive.isAdapterRegistered(adapterId)) {
        Hive.registerAdapter(adapter);
      }
      _box = await Hive.openBox<T>(fullName);
    }
    return _box!;
  }

  /// -----------------------------
  /// BASIC CRUD
  /// -----------------------------
  Future<void> save(T item) async {
    final box = await _open;
    final key = idSelector(item);
    await box.put(key, item);
  }

  Future<void> upsert(T item) async => save(item);

  Future<void> put(dynamic key, T item) async {
    final box = await _open;
    await box.put(key, item);
  }

  Future<T?> get(dynamic key) async {
    final box = await _open;
    return box.get(key);
  }

  Future<List<T>> getAll() async {
    final box = await _open;
    return box.values.toList();
  }

  Future<void> delete(dynamic key) async {
    final box = await _open;
    await box.delete(key);
  }

  Future<void> clear() async {
    final box = await _open;
    await box.clear();
  }

  Future<void> close() async {
    final fullName = boxName;
    final box = await _open;
    if (Hive.isBoxOpen(fullName)) {
      await box.close();
    }
  }

  Future<void> upsertEntities({required List<T> entities}) async {
    final box = await _open;

    final Map<dynamic, T> map = {
      for (var item in entities) idSelector(item): item,
    };

    await box.putAll(map);
  }

  Future<int> getNextId() async {
    final box = await _open;
    if (box.isEmpty) return 1;
    final lastKey = box.keys.cast<int>().reduce((a, b) => a > b ? a : b);

    return lastKey + 1;
  }
}

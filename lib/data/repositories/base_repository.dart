import 'package:hive/hive.dart';

abstract class BaseRepository<T> {
  final String boxName;
  Box<T>? _box;

  BaseRepository(this.boxName);

  Future<Box<T>> get box async {
    _box ??= await Hive.openBox<T>(boxName);
    return _box!;
  }

  Future<void> add(String key, T item) async {
    final b = await box;
    await b.put(key, item);
  }

  Future<T?> get(String key) async {
    final b = await box;
    return b.get(key);
  }

  Future<List<T>> getAll() async {
    final b = await box;
    return b.values.toList();
  }

  Future<void> update(String key, T item) async {
    final b = await box;
    await b.put(key, item);
  }

  Future<void> delete(String key) async {
    final b = await box;
    await b.delete(key);
  }

  Future<void> clear() async {
    final b = await box;
    await b.clear();
  }

  Future<bool> exists(String key) async {
    final b = await box;
    return b.containsKey(key);
  }

  Future<List<String>> getKeys() async {
    final b = await box;
    return b.keys.cast<String>().toList();
  }

  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}

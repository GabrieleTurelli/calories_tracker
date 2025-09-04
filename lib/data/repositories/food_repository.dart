import '../models/food.dart';
import 'base_repository.dart';

class FoodRepository extends BaseRepository<Food> {
  FoodRepository() : super('foods');

  Future<List<Food>> searchByName(String query) async {
    final foods = await getAll();
    return foods
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<Food?> getByBarcode(String barcode) async {
    final foods = await getAll();
    return foods.where((food) => food.barcode == barcode).firstOrNull;
  }

  Future<List<Food>> getMostUsed({int limit = 10}) async {
    final foods = await getAll();
    return foods.take(limit).toList();
  }

  Future<List<Food>> getRecent({int limit = 10}) async {
    final foods = await getAll();
    return foods.reversed.take(limit).toList();
  }
}

extension on Iterable<Food> {
  Food? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}

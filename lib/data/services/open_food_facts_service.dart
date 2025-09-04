import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';

class OpenFoodFactsService {
  static const String _baseUrl =
      'https://world.openfoodfacts.org/api/v2/product';

  static Future<Food?> getProductByBarcode(String barcode) async {
    try {
      final url = Uri.parse('$_baseUrl/$barcode.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 1 && data['product'] != null) {
          return _parseProduct(data['product'], barcode);
        }
      }
      return null;
    } catch (e) {
      print('Errore nel recupero del prodotto: $e');
      return null;
    }
  }

  static Food _parseProduct(Map<String, dynamic> product, String barcode) {
    String name =
        product['product_name'] ??
        product['product_name_it'] ??
        product['product_name_en'] ??
        'Prodotto sconosciuto';

    final nutriments = product['nutriments'] ?? {};

    double calories =
        _parseNutriment(nutriments, 'energy-kcal_100g') ??
        _parseNutriment(
          nutriments,
          'energy_100g',
        )?.let((energy) => energy / 4.184) ??
        0.0;

    double protein = _parseNutriment(nutriments, 'proteins_100g') ?? 0.0;
    double carbs = _parseNutriment(nutriments, 'carbohydrates_100g') ?? 0.0;
    double fat = _parseNutriment(nutriments, 'fat_100g') ?? 0.0;

    double? fiber = _parseNutriment(nutriments, 'fiber_100g'); // g
    double? sugar = _parseNutriment(nutriments, 'sugars_100g'); // g
    double? sodium = _parseNutriment(
      nutriments,
      'sodium_100g',
    ); // g di sodio -> converti in mg
    if (sodium != null) sodium = sodium * 1000; // g -> mg
    double? potassium = _parseNutriment(
      nutriments,
      'potassium_100g',
    ); // mg già (alcune volte in mg)
    if (potassium != null && potassium < 20) potassium = potassium * 1000;
    double? calcium = _parseNutriment(nutriments, 'calcium_100g');
    if (calcium != null && calcium < 20) calcium = calcium * 1000; // g -> mg
    double? iron = _parseNutriment(nutriments, 'iron_100g');
    if (iron != null && iron < 20) iron = iron * 1000; // g -> mg
    double? vitaminC = _parseNutriment(nutriments, 'vitamin-c_100g');
    if (vitaminC != null && vitaminC < 20) {
      vitaminC = vitaminC * 1000; // g -> mg
    }
    double? saturatedFat = _parseNutriment(
      nutriments,
      'saturated-fat_100g',
    ); // g

    String? brand = product['brands'];
    String? categories = product['categories'];
    String? imageUrl = product['image_url'];

    return Food(
      id: barcode,
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      barcode: barcode,
      brand: brand,
      categories: categories,
      imageUrl: imageUrl,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
      potassium: potassium,
      calcium: calcium,
      iron: iron,
      vitaminC: vitaminC,
      saturatedFat: saturatedFat,
    );
  }

  static double? _parseNutriment(Map<String, dynamic> nutriments, String key) {
    final value = nutriments[key];
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}

extension _LetExtension<T> on T? {
  R? let<R>(R Function(T) transform) {
    final self = this;
    return self != null ? transform(self) : null;
  }
}

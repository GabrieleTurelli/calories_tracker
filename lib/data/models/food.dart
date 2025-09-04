import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'food.g.dart';

@HiveType(typeId: 0)
class Food extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double calories; // per 100g

  @HiveField(3)
  final double protein; // per 100g

  @HiveField(4)
  final double carbs; // per 100g

  @HiveField(5)
  final double fat; // per 100g

  @HiveField(6)
  final String? barcode;

  @HiveField(7)
  final String? brand;

  @HiveField(8)
  final String? categories;

  @HiveField(9)
  final String? imageUrl;

  @HiveField(10)
  final double? fiber; // g
  @HiveField(11)
  final double? sugar; // g
  @HiveField(12)
  final double? sodium; // mg
  @HiveField(13)
  final double? potassium; // mg
  @HiveField(14)
  final double? calcium; // mg
  @HiveField(15)
  final double? iron; // mg
  @HiveField(16)
  final double? vitaminC; // mg
  @HiveField(17)
  final double? saturatedFat; // g

  const Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.barcode,
    this.brand,
    this.categories,
    this.imageUrl,
    this.fiber,
    this.sugar,
    this.sodium,
    this.potassium,
    this.calcium,
    this.iron,
    this.vitaminC,
    this.saturatedFat,
  });

  Food copyWith({
    String? id,
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? barcode,
    String? brand,
    String? categories,
    String? imageUrl,
    double? fiber,
    double? sugar,
    double? sodium,
    double? potassium,
    double? calcium,
    double? iron,
    double? vitaminC,
    double? saturatedFat,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      barcode: barcode ?? this.barcode,
      brand: brand ?? this.brand,
      categories: categories ?? this.categories,
      imageUrl: imageUrl ?? this.imageUrl,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
      potassium: potassium ?? this.potassium,
      calcium: calcium ?? this.calcium,
      iron: iron ?? this.iron,
      vitaminC: vitaminC ?? this.vitaminC,
      saturatedFat: saturatedFat ?? this.saturatedFat,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    calories,
    protein,
    carbs,
    fat,
    barcode,
    brand,
    categories,
    imageUrl,
    fiber,
    sugar,
    sodium,
    potassium,
    calcium,
    iron,
    vitaminC,
    saturatedFat,
  ];
}

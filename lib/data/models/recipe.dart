import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'food.dart';

part 'recipe.g.dart';

@HiveType(typeId: 1)
class Recipe extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<RecipeIngredient> ingredients;

  @HiveField(3)
  final String? instructions;

  @HiveField(4)
  final int servings;

  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    this.instructions,
    this.servings = 1,
  });

  double get totalCalories {
    return ingredients.fold(
      0.0,
      (sum, ingredient) =>
          sum + (ingredient.food.calories * ingredient.quantity / 100),
    );
  }

  double get totalProtein {
    return ingredients.fold(
      0.0,
      (sum, ingredient) =>
          sum + (ingredient.food.protein * ingredient.quantity / 100),
    );
  }

  double get totalCarbs {
    return ingredients.fold(
      0.0,
      (sum, ingredient) =>
          sum + (ingredient.food.carbs * ingredient.quantity / 100),
    );
  }

  double get totalFat {
    return ingredients.fold(
      0.0,
      (sum, ingredient) =>
          sum + (ingredient.food.fat * ingredient.quantity / 100),
    );
  }

  Recipe copyWith({
    String? id,
    String? name,
    List<RecipeIngredient>? ingredients,
    String? instructions,
    int? servings,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      servings: servings ?? this.servings,
    );
  }

  @override
  List<Object?> get props => [id, name, ingredients, instructions, servings];
}

@HiveType(typeId: 2)
class RecipeIngredient extends Equatable {
  @HiveField(0)
  final Food food;

  @HiveField(1)
  final double quantity; // in grams

  const RecipeIngredient({required this.food, required this.quantity});

  RecipeIngredient copyWith({Food? food, double? quantity}) {
    return RecipeIngredient(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [food, quantity];
}

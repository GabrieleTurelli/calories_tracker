import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'food.dart';

part 'diary_entry.g.dart';

@HiveType(typeId: 10)
class DiaryEntry extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final List<MealEntry> meals;

  @HiveField(3)
  final double? waterIntake; // in liters

  const DiaryEntry({
    required this.id,
    required this.date,
    required this.meals,
    this.waterIntake,
  });

  double get totalCalories {
    return meals.fold(0.0, (sum, meal) => sum + meal.totalCalories);
  }

  double get totalProtein {
    return meals.fold(0.0, (sum, meal) => sum + meal.totalProtein);
  }

  double get totalCarbs {
    return meals.fold(0.0, (sum, meal) => sum + meal.totalCarbs);
  }

  double get totalFat {
    return meals.fold(0.0, (sum, meal) => sum + meal.totalFat);
  }

  double get totalFiber => meals.fold(0.0, (s, m) => s + m.totalFiber);
  double get totalSugar => meals.fold(0.0, (s, m) => s + m.totalSugar);
  double get totalSodium => meals.fold(0.0, (s, m) => s + m.totalSodium); // mg
  double get totalPotassium =>
      meals.fold(0.0, (s, m) => s + m.totalPotassium); // mg
  double get totalCalcium =>
      meals.fold(0.0, (s, m) => s + m.totalCalcium); // mg
  double get totalIron => meals.fold(0.0, (s, m) => s + m.totalIron); // mg
  double get totalVitaminC =>
      meals.fold(0.0, (s, m) => s + m.totalVitaminC); // mg
  double get totalSaturatedFat =>
      meals.fold(0.0, (s, m) => s + m.totalSaturatedFat); // g

  DiaryEntry copyWith({
    String? id,
    DateTime? date,
    List<MealEntry>? meals,
    double? waterIntake,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      meals: meals ?? this.meals,
      waterIntake: waterIntake ?? this.waterIntake,
    );
  }

  @override
  List<Object?> get props => [id, date, meals, waterIntake];
}

@HiveType(typeId: 11)
class MealEntry extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final MealType mealType;

  @HiveField(2)
  final List<FoodEntry> foods;

  @HiveField(3)
  final DateTime timestamp;

  const MealEntry({
    required this.id,
    required this.mealType,
    required this.foods,
    required this.timestamp,
  });

  double get totalCalories {
    return foods.fold(
      0.0,
      (sum, foodEntry) =>
          sum + (foodEntry.food.calories * foodEntry.quantity / 100),
    );
  }

  double get totalProtein {
    return foods.fold(
      0.0,
      (sum, foodEntry) =>
          sum + (foodEntry.food.protein * foodEntry.quantity / 100),
    );
  }

  double get totalCarbs {
    return foods.fold(
      0.0,
      (sum, foodEntry) =>
          sum + (foodEntry.food.carbs * foodEntry.quantity / 100),
    );
  }

  double get totalFat {
    return foods.fold(
      0.0,
      (sum, foodEntry) => sum + (foodEntry.food.fat * foodEntry.quantity / 100),
    );
  }

  double get totalFiber => foods.fold(
    0.0,
    (sum, e) => sum + ((e.food.fiber ?? 0) * e.quantity / 100),
  );
  double get totalSugar => foods.fold(
    0.0,
    (sum, e) => sum + ((e.food.sugar ?? 0) * e.quantity / 100),
  );
  double get totalSodium => foods.fold(
    0.0,
    (sum, e) => sum + ((e.food.sodium ?? 0) * e.quantity / 100),
  );
  double get totalPotassium => foods.fold(
    0.0,
    (sum, e) => sum + ((e.food.potassium ?? 0) * e.quantity / 100),
  );
  double get totalCalcium => foods.fold(
    0.0,
    (sum, e) => sum + ((e.food.calcium ?? 0) * e.quantity / 100),
  );
  double get totalIron => foods.fold(
    0.0,
    (sum, e) => sum + ((e.food.iron ?? 0) * e.quantity / 100),
  );
  double get totalVitaminC => foods.fold(
    0.0,
    (sum, e) => sum + ((e.food.vitaminC ?? 0) * e.quantity / 100),
  );
  double get totalSaturatedFat => foods.fold(
    0.0,
    (sum, e) => sum + ((e.food.saturatedFat ?? 0) * e.quantity / 100),
  );

  MealEntry copyWith({
    String? id,
    MealType? mealType,
    List<FoodEntry>? foods,
    DateTime? timestamp,
  }) {
    return MealEntry(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      foods: foods ?? this.foods,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [id, mealType, foods, timestamp];
}

@HiveType(typeId: 12)
class FoodEntry extends Equatable {
  @HiveField(0)
  final Food food;

  @HiveField(1)
  final double quantity; // in grams

  const FoodEntry({required this.food, required this.quantity});

  FoodEntry copyWith({Food? food, double? quantity}) {
    return FoodEntry(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [food, quantity];
}

@HiveType(typeId: 13)
enum MealType {
  @HiveField(0)
  breakfast("Colazione"),

  @HiveField(1)
  lunch("Pranzo"),

  @HiveField(2)
  dinner("Cena"),

  @HiveField(3)
  snack("Spuntino");

  const MealType(this.displayName);

  final String displayName;
}

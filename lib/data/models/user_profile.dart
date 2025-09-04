import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 6)
class UserProfile extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final Gender sex;

  @HiveField(4)
  final double height; // in cm

  @HiveField(5)
  final double weight; // in kg

  @HiveField(6)
  final Goal goal;

  @HiveField(7)
  final ActivityLevel activityLevel;

  @HiveField(8)
  final double? targetWeight; // in kg

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.sex,
    required this.height,
    required this.weight,
    required this.goal,
    required this.activityLevel,
    this.targetWeight,
    required this.createdAt,
    required this.updatedAt,
  });

  double get bmr {
    final baseBmr = (10 * weight) + (6.25 * height) - (5 * age);
    return sex == Gender.male ? baseBmr + 5 : baseBmr - 161;
  }

  double get tdee {
    return bmr * activityLevel.multiplier;
  }

  double get targetCalories {
    switch (goal) {
      case Goal.weightLoss:
        return tdee - 500; // 0.5kg per week loss
      case Goal.maintain:
        return tdee;
      case Goal.weightGain:
        return tdee + 500; // 0.5kg per week gain
    }
  }

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    Gender? sex,
    double? height,
    double? weight,
    Goal? goal,
    ActivityLevel? activityLevel,
    double? targetWeight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      targetWeight: targetWeight ?? this.targetWeight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    age,
    sex,
    height,
    weight,
    goal,
    activityLevel,
    targetWeight,
    createdAt,
    updatedAt,
  ];
}

@HiveType(typeId: 7)
enum Gender {
  @HiveField(0)
  male,

  @HiveField(1)
  female,
}

@HiveType(typeId: 8)
enum Goal {
  @HiveField(0)
  weightLoss,

  @HiveField(1)
  maintain,

  @HiveField(2)
  weightGain,
}

@HiveType(typeId: 9)
enum ActivityLevel {
  @HiveField(0)
  sedentary(1.2, "Sedentario"),

  @HiveField(1)
  lightlyActive(1.375, "Leggera attività"),

  @HiveField(2)
  moderatelyActive(1.55, "Moderata attività"),

  @HiveField(3)
  veryActive(1.725, "Molto attivo"),

  @HiveField(4)
  extraActive(1.9, "Estremamente attivo");

  const ActivityLevel(this.multiplier, this.displayName);

  final double multiplier;
  final String displayName;
}

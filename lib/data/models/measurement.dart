import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'measurement.g.dart';

@HiveType(typeId: 3)
class Measurement extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double? weight; // in kg

  @HiveField(3)
  final double? waist; // in cm

  @HiveField(4)
  final double? chest; // in cm

  @HiveField(5)
  final double? waterIntake; // in liters

  const Measurement({
    required this.id,
    required this.date,
    this.weight,
    this.waist,
    this.chest,
    this.waterIntake,
  });

  Measurement copyWith({
    String? id,
    DateTime? date,
    double? weight,
    double? waist,
    double? chest,
    double? waterIntake,
  }) {
    return Measurement(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      waist: waist ?? this.waist,
      chest: chest ?? this.chest,
      waterIntake: waterIntake ?? this.waterIntake,
    );
  }

  @override
  List<Object?> get props => [id, date, weight, waist, chest, waterIntake];
}

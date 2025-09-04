class NutritionUtils {
  static double getMacroPercentage(double macro, double totalCalories) {
    if (totalCalories == 0) return 0;
    return (macro * 4) /
        totalCalories *
        100; // 4 kcal per grammo di carbs/protein
  }

  static double getFatPercentage(double fat, double totalCalories) {
    if (totalCalories == 0) return 0;
    return (fat * 9) / totalCalories * 100; // 9 kcal per grammo di fat
  }

  static String formatNutrition(double value, {int decimals = 1}) {
    return value.toStringAsFixed(decimals);
  }

  static double getCaloriesFromMacros(
    double protein,
    double carbs,
    double fat,
  ) {
    return (protein * 4) + (carbs * 4) + (fat * 9);
  }

  static bool isValidNutritionValue(double value) {
    return value >= 0 && value <= 1000; // Range ragionevole per 100g
  }

  static Map<String, double> calculateMacroTargets(
    double targetCalories, {
    double proteinPercentage = 30,
    double carbsPercentage = 40,
    double fatPercentage = 30,
  }) {
    final proteinCalories = targetCalories * (proteinPercentage / 100);
    final carbsCalories = targetCalories * (carbsPercentage / 100);
    final fatCalories = targetCalories * (fatPercentage / 100);

    return {
      'protein': proteinCalories / 4, // 4 kcal per grammo
      'carbs': carbsCalories / 4, // 4 kcal per grammo
      'fat': fatCalories / 9, // 9 kcal per grammo
    };
  }

  static double calculateProgress(double current, double target) {
    if (target == 0) return 0;
    return (current / target * 100).clamp(0, 100);
  }

  static double convertToGrams(double value, String unit) {
    switch (unit.toLowerCase()) {
      case 'kg':
        return value * 1000;
      case 'oz':
        return value * 28.35;
      case 'lb':
        return value * 453.59;
      default:
        return value; // Assume grams
    }
  }

  static double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Sottopeso';
    if (bmi < 25) return 'Normopeso';
    if (bmi < 30) return 'Sovrappeso';
    return 'Obeso';
  }

  static double calculateWaterTarget(double weightKg) {
    return weightKg * 0.035; // 35ml per kg di peso corporeo
  }
}

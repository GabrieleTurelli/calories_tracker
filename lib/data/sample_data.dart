import 'package:calories_tracker/data/models/food.dart';

class SampleData {
  static List<Food> getSampleFoods() {
    return [
      const Food(
        id: '1',
        name: 'Mela',
        calories: 52,
        protein: 0.3,
        carbs: 14,
        fat: 0.2,
      ),
      const Food(
        id: '2',
        name: 'Banana',
        calories: 89,
        protein: 1.1,
        carbs: 23,
        fat: 0.3,
      ),
      const Food(
        id: '3',
        name: 'Petto di pollo',
        calories: 165,
        protein: 31,
        carbs: 0,
        fat: 3.6,
      ),
      const Food(
        id: '4',
        name: 'Riso integrale',
        calories: 123,
        protein: 2.6,
        carbs: 23,
        fat: 0.9,
      ),
      const Food(
        id: '5',
        name: 'Broccoli',
        calories: 34,
        protein: 2.8,
        carbs: 7,
        fat: 0.4,
      ),
      const Food(
        id: '6',
        name: 'Salmone',
        calories: 208,
        protein: 22,
        carbs: 0,
        fat: 12,
      ),
      const Food(
        id: '7',
        name: 'Avocado',
        calories: 160,
        protein: 2,
        carbs: 9,
        fat: 15,
      ),
      const Food(
        id: '8',
        name: 'Spinaci',
        calories: 23,
        protein: 2.9,
        carbs: 3.6,
        fat: 0.4,
      ),
      const Food(
        id: '9',
        name: 'Mandorle',
        calories: 579,
        protein: 21,
        carbs: 22,
        fat: 49,
      ),
      const Food(
        id: '10',
        name: 'Yogurt greco',
        calories: 59,
        protein: 10,
        carbs: 3.6,
        fat: 0.4,
      ),
    ];
  }
}

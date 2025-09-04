import '../models/diary_entry.dart';
import '../../core/utils/date_utils.dart' as date_utils;
import 'base_repository.dart';

class DiaryRepository extends BaseRepository<DiaryEntry> {
  DiaryRepository() : super('diary_entries');

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<DiaryEntry?> getEntryForDate(DateTime date) async {
    final key = _dateKey(date);
    return await get(key);
  }

  Future<void> saveEntryForDate(DateTime date, DiaryEntry entry) async {
    final key = _dateKey(date);
    await add(key, entry);
  }

  Future<List<DiaryEntry>> getEntriesForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final entries = await getAll();
    return entries.where((entry) {
      return entry.date.isAfter(start.subtract(const Duration(days: 1))) &&
          entry.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<List<DiaryEntry>> getWeekEntries(DateTime date) async {
    final weekDates = date_utils.DateUtils.getWeekDates(date);
    final start = weekDates.first;
    final end = weekDates.last;
    return await getEntriesForDateRange(start, end);
  }

  Future<List<DiaryEntry>> getMonthEntries(DateTime date) async {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    return await getEntriesForDateRange(start, end);
  }

  Future<double> getAverageCalories(DateTime start, DateTime end) async {
    final entries = await getEntriesForDateRange(start, end);
    if (entries.isEmpty) return 0.0;

    final totalCalories = entries.fold(
      0.0,
      (sum, entry) => sum + entry.totalCalories,
    );
    return totalCalories / entries.length;
  }

  Future<Map<String, double>> getAverageMacros(
    DateTime start,
    DateTime end,
  ) async {
    final entries = await getEntriesForDateRange(start, end);
    if (entries.isEmpty) {
      return {'protein': 0.0, 'carbs': 0.0, 'fat': 0.0};
    }

    final totalProtein = entries.fold(
      0.0,
      (sum, entry) => sum + entry.totalProtein,
    );
    final totalCarbs = entries.fold(
      0.0,
      (sum, entry) => sum + entry.totalCarbs,
    );
    final totalFat = entries.fold(0.0, (sum, entry) => sum + entry.totalFat);

    final count = entries.length;
    return {
      'protein': totalProtein / count,
      'carbs': totalCarbs / count,
      'fat': totalFat / count,
    };
  }
}

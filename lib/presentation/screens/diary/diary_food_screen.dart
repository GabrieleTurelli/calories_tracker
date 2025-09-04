import 'package:calories_tracker/core/theme/app_theme.dart';
import 'package:calories_tracker/data/models/diary_entry.dart';
import 'package:calories_tracker/presentation/widgets/add_food_dialog.dart';
import 'package:calories_tracker/logic/blocs/diary_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDiaryEntry();
  }

  void _loadDiaryEntry() {
    context.read<DiaryBloc>().add(LoadDiaryEntry(selectedDate));
  }

  void _openAddFoodSheet(MealType mealType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          height: MediaQuery.of(ctx).size.height * 0.85,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Aggiungi a ${mealType.displayName}',
                    style: AppTextStylesHelper.h3(context),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Expanded(
                child: AddFoodDialog(
                  onFoodAdded: (food, quantity) {
                    final mealEntry = MealEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      mealType: mealType,
                      foods: [FoodEntry(food: food, quantity: quantity)],
                      timestamp: DateTime.now(),
                    );
                    context.read<DiaryBloc>().add(
                      AddMealToDiary(selectedDate, mealEntry),
                    );
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Diario', style: AppTextStylesHelper.h2(context)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.date_range,
              color: AppColors.tangerinePrimary,
            ),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: BlocBuilder<DiaryBloc, DiaryState>(
        builder: (context, state) {
          if (state is DiaryLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.tangerinePrimary,
              ),
            );
          }

          if (state is DiaryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.errorRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: AppTextStylesHelper.bodyLarge(context),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadDiaryEntry,
                    child: Text('Riprova', style: AppTextStyles.buttonText),
                  ),
                ],
              ),
            );
          }

          if (state is DiaryLoaded) {
            final entry = state.diaryEntry;
            final targetCalories = 2000.0; // TODO: da profilo utente

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 16),
                _buildCalorieRing(entry.totalCalories, targetCalories, entry),
                const SizedBox(height: 16),
                _buildMacroSummary(entry),
                const SizedBox(height: 16),
                _buildWaterCard(entry),
                const SizedBox(height: 16),
                ...MealType.values.map(
                  (type) => _buildMealSection(type, entry),
                ),
                const SizedBox(height: 100),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: _buildSpeedDial(),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppColors.tangerinePrimary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              _formatDate(selectedDate),
              style: AppTextStylesHelper.h3(context),
            ),
            const Spacer(),
            if (!_isToday(selectedDate))
              TextButton(
                onPressed: () {
                  setState(() => selectedDate = DateTime.now());
                  _loadDiaryEntry();
                },
                child: Text(
                  'Oggi',
                  style: AppTextStylesHelper.bodyLarge(
                    context,
                  ).copyWith(color: AppColors.tangerinePrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _buildCalorieRing(double calories, double target, DiaryEntry entry) {
    final percentage = (calories / target).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of( context).cardColor,
              Theme.of( context).cardColor,

            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Calorie', style: AppTextStylesHelper.h3(context)),
                TextButton.icon(
                  onPressed: () => _showMicronutrients(entry),
                  icon: Icon(
                    Icons.science,
                    color: AppColors.mintSecondary,
                    size: 18,
                  ),
                  label: Text(
                    'Micros',
                    style: AppTextStylesHelper.bodySmall(
                      context,
                    ).copyWith(color: AppColors.mintSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CustomPaint(
                    painter: CalorieRingPainter(
                      percentage: percentage,
                      strokeWidth: 12,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      calories.toInt().toString(),
                      style: AppTextStylesHelper.h1(
                        context,
                      ).copyWith(fontSize: 28),
                    ),
                    Text('kcal', style: AppTextStylesHelper.bodySmall(context)),
                    Text(
                      'di ${target.toInt()}',
                      style: AppTextStylesHelper.bodySmall(
                        context,
                      ).copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroSummary(DiaryEntry entry) {
    final targetCalories = 2000.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Macronutrienti', style: AppTextStylesHelper.h3(context)),
            const SizedBox(height: 16),
            _buildMacroBar(
              'Proteine',
              entry.totalProtein,
              targetCalories * 0.3 / 4, // 30% delle calorie da proteine
              AppColors.successGreen,
              'g',
            ),
            const SizedBox(height: 12),
            _buildMacroBar(
              'Carboidrati',
              entry.totalCarbs,
              targetCalories * 0.4 / 4, // 40% delle calorie da carbi
              AppColors.mintSecondary,
              'g',
            ),
            const SizedBox(height: 12),
            _buildMacroBar(
              'Grassi',
              entry.totalFat,
              targetCalories * 0.3 / 9, // 30% delle calorie da grassi
              AppColors.coralAccent,
              'g',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBar(
    String label,
    double current,
    double target,
    Color color,
    String unit,
  ) {
    final percentage = (current / target).clamp(0.0, 1.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStylesHelper.bodyLarge(
                context,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              '${current.toStringAsFixed(0)}$unit / ${target.toStringAsFixed(0)}$unit',
              style: AppTextStylesHelper.numbersMono(
                context,
              ).copyWith(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage > 1.0 ? 1.0 : percentage,
            minHeight: 8,
            backgroundColor: AppColors.inputBackground,
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage > 1.0 ? AppColors.warningYellow : color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterCard(DiaryEntry entry) {
    final currentWater = entry.waterIntake ?? 0.0;
    final targetWater = 2.5; // Litri al giorno
    final percentage = (currentWater / targetWater).clamp(0.0, 1.0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.mintSecondary.withOpacity(0.1),
              Theme.of(context).cardColor,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop, color: AppColors.mintSecondary),
                const SizedBox(width: 8),
                Text('Idratazione', style: AppTextStylesHelper.h3(context)),
                const Spacer(),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: AppTextStylesHelper.numbersMono(context).copyWith(
                    color: AppColors.mintSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 10,
                backgroundColor: AppColors.inputBackground,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.mintSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${currentWater.toStringAsFixed(1)} L / ${targetWater.toStringAsFixed(1)} L',
                    style: AppTextStylesHelper.bodySmall(context),
                  ),
                ),
                Row(
                  children: [
                    _buildWaterButton('+250ml', 0.25),
                    const SizedBox(width: 8),
                    _buildWaterButton('+500ml', 0.5),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterButton(String label, double amount) {
    return ElevatedButton(
      onPressed: () => _addWater(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mintSecondary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
      ),
      child: Text(
        label,
        style: AppTextStyles.buttonText.copyWith(fontSize: 12),
      ),
    );
  }

  Widget _buildMealSection(MealType type, DiaryEntry entry) {
    final mealsOfType = entry.meals.where((m) => m.mealType == type).toList();
    final totalCalories = mealsOfType.fold(
      0.0,
      (sum, meal) => sum + meal.totalCalories,
    );

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.tangerinePrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getMealIcon(type),
            color: AppColors.tangerinePrimary,
            size: 20,
          ),
        ),
        title: Text(type.displayName, style: AppTextStylesHelper.h3(context)),
        subtitle: Text(
          '${totalCalories.toInt()} kcal • ${mealsOfType.fold(0, (sum, meal) => sum + meal.foods.length)} alimenti',
          style: AppTextStylesHelper.bodySmall(context),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            color: AppColors.tangerinePrimary,
          ),
          onPressed: () => _openAddFoodSheet(type),
          tooltip: 'Aggiungi alimento a ${type.displayName}',
        ),
        children: [
          if (mealsOfType.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      color: AppColors.inputBorder,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nessun alimento aggiunto',
                      style: AppTextStylesHelper.bodySmall(context),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _openAddFoodSheet(type),
                      icon: Icon(Icons.add, size: 18),
                      label: Text('Aggiungi il primo alimento'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.tangerinePrimary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...mealsOfType.expand(
              (meal) => meal.foods.map(
                (foodEntry) => _buildFoodItem(meal, foodEntry, entry),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(MealEntry meal, FoodEntry foodEntry, DiaryEntry entry) {
    final calories = (foodEntry.food.calories * foodEntry.quantity / 100);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.tangerinePrimary.withOpacity(0.1),
        radius: 20,
        child: Text(
          foodEntry.food.name.substring(0, 1).toUpperCase(),
          style: AppTextStylesHelper.bodyLarge(context).copyWith(
            color: AppColors.tangerinePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        foodEntry.food.name,
        style: AppTextStylesHelper.bodyLarge(
          context,
        ).copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${foodEntry.quantity.toStringAsFixed(0)} g',
        style: AppTextStylesHelper.bodySmall(context),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${calories.toStringAsFixed(0)} kcal',
            style: AppTextStylesHelper.numbersMono(
              context,
            ).copyWith(fontSize: 14),
          ),
          Text(
            'P: ${(foodEntry.food.protein * foodEntry.quantity / 100).toStringAsFixed(0)}g',
            style: AppTextStylesHelper.bodySmall(
              context,
            ).copyWith(fontSize: 10),
          ),
        ],
      ),
      onLongPress: () => _showRemoveFoodDialog(meal, foodEntry, entry),
    );
  }

  void _showRemoveFoodDialog(
    MealEntry meal,
    FoodEntry foodEntry,
    DiaryEntry entry,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Rimuovi alimento', style: AppTextStylesHelper.h3(context)),
        content: Text(
          'Vuoi rimuovere "${foodEntry.food.name}" dal pasto?',
          style: AppTextStylesHelper.bodyLarge(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedFoods = meal.foods
                  .where((f) => f != foodEntry)
                  .toList();
              if (updatedFoods.isEmpty) {
                context.read<DiaryBloc>().add(
                  RemoveMealFromDiary(selectedDate, meal.id),
                );
              } else {
                final updatedMeal = meal.copyWith(foods: updatedFoods);
                context.read<DiaryBloc>().add(
                  UpdateMealInDiary(selectedDate, updatedMeal),
                );
              }
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: Text('Rimuovi', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDial() {
    return FloatingActionButton.extended(
      onPressed: () => _openAddFoodSheet(MealType.snack),
      backgroundColor: AppColors.tangerinePrimary,
      foregroundColor: Colors.white,
      elevation: 6,
      icon: const Icon(Icons.add),
      label: Text('Aggiungi', style: AppTextStyles.buttonText),
    );
  }

  void _showMicronutrients(DiaryEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.science, color: AppColors.mintSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Micronutrienti',
                      style: AppTextStylesHelper.h2(context),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildMicronutrientTile(
                      'Fibra',
                      entry.totalFiber,
                      25.0, // RDI: 25g per donne, 38g per uomini
                      'g',
                      AppColors.successGreen,
                      Icons.grass,
                    ),
                    _buildMicronutrientTile(
                      'Zuccheri',
                      entry.totalSugar,
                      50.0, // Limite consigliato: <50g al giorno
                      'g',
                      AppColors.warningYellow,
                      Icons.cake,
                      isLimitValue: true,
                    ),
                    _buildMicronutrientTile(
                      'Sodio',
                      entry.totalSodium,
                      2300.0, // Limite: <2300mg al giorno
                      'mg',
                      AppColors.errorRed,
                      Icons.warning,
                      isLimitValue: true,
                    ),
                    _buildMicronutrientTile(
                      'Potassio',
                      entry.totalPotassium,
                      3500.0, // RDI: 3500mg
                      'mg',
                      AppColors.mintSecondary,
                      Icons.flash_on,
                    ),
                    _buildMicronutrientTile(
                      'Calcio',
                      entry.totalCalcium,
                      1000.0, // RDI: 1000mg
                      'mg',
                      AppColors.coralAccent,
                      Icons.foundation,
                    ),
                    _buildMicronutrientTile(
                      'Ferro',
                      entry.totalIron,
                      18.0, // RDI: 18mg per donne, 8mg per uomini
                      'mg',
                      AppColors.errorRed,
                      Icons.fitness_center,
                    ),
                    _buildMicronutrientTile(
                      'Vitamina C',
                      entry.totalVitaminC,
                      90.0, // RDI: 90mg per uomini, 75mg per donne
                      'mg',
                      AppColors.pastelPurple,
                      Icons.local_hospital,
                    ),
                    _buildMicronutrientTile(
                      'Grassi Saturi',
                      entry.totalSaturatedFat,
                      20.0, // Limite: <22g al giorno (10% delle calorie)
                      'g',
                      AppColors.warningYellow,
                      Icons.warning_amber,
                      isLimitValue: true,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMicronutrientTile(
    String name,
    double current,
    double target,
    String unit,
    Color color,
    IconData icon, {
    bool isLimitValue = false,
  }) {
    final percentage = (current / target).clamp(0.0, 1.5);
    final status = _getMicronutrientStatus(current, target, isLimitValue);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          name,
          style: AppTextStylesHelper.bodyLarge(
            context,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage > 1.0 ? 1.0 : percentage,
                minHeight: 6,
                backgroundColor: AppColors.inputBackground,
                valueColor: AlwaysStoppedAnimation<Color>(
                  status == 'Eccesso'
                      ? AppColors.errorRed
                      : status == 'OK'
                      ? AppColors.successGreen
                      : AppColors.warningYellow,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${current.toStringAsFixed(1)} $unit ${isLimitValue ? "max" : "di"} ${target.toStringAsFixed(0)} $unit',
              style: AppTextStylesHelper.bodySmall(context),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: status == 'Eccesso'
                ? AppColors.errorRed.withOpacity(0.1)
                : status == 'OK'
                ? AppColors.successGreen.withOpacity(0.1)
                : AppColors.warningYellow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: AppTextStylesHelper.bodySmall(context).copyWith(
              color: status == 'Eccesso'
                  ? AppColors.errorRed
                  : status == 'OK'
                  ? AppColors.successGreen
                  : AppColors.warningYellow,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  String _getMicronutrientStatus(
    double current,
    double target,
    bool isLimitValue,
  ) {
    if (isLimitValue) {
      if (current <= target * 0.5) return 'Basso';
      if (current <= target) return 'OK';
      return 'Eccesso';
    } else {
      if (current >= target) return 'OK';
      if (current >= target * 0.7) return 'Quasi';
      return 'Basso';
    }
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.wb_sunny;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
      case MealType.snack:
        return Icons.fastfood;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Oggi';
    if (difference == 1) return 'Ieri';
    if (difference == -1) return 'Domani';

    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.tangerinePrimary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadDiaryEntry();
    }
  }

  void _addWater(double amount) {
    final state = context.read<DiaryBloc>().state;
    if (state is DiaryLoaded) {
      final currentWater = state.diaryEntry.waterIntake ?? 0.0;
      context.read<DiaryBloc>().add(
        UpdateWaterIntake(selectedDate, currentWater + amount),
      );
    }
  }
}

class CalorieRingPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;

  CalorieRingPainter({required this.percentage, this.strokeWidth = 12.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = AppColors.inputBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (percentage > 0) {
      final gradient = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + (2 * math.pi * percentage),
        colors: [
          AppColors.tangerinePrimary,
          AppColors.mintSecondary,
          AppColors.coralAccent,
        ],
        stops: [0.0, 0.6, 1.0],
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * percentage;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CalorieRingPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

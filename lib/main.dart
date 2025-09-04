import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/diary_repository.dart';
import 'data/repositories/food_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/sample_data.dart';
import 'logic/blocs/diary_bloc.dart';
import 'logic/cubits/settings_cubit.dart';
import 'presentation/screens/home_screen.dart';

import 'data/models/food.dart';
import 'data/models/diary_entry.dart';
import 'data/models/recipe.dart';
import 'data/models/measurement.dart';
import 'data/models/user_profile.dart';
import 'data/models/fast_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(DiaryEntryAdapter());
  Hive.registerAdapter(MealEntryAdapter());
  Hive.registerAdapter(FoodEntryAdapter());
  Hive.registerAdapter(MealTypeAdapter());
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(MeasurementAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(FastSessionAdapter());

  await _initializeSampleData();

  runApp(const CaloriesTrackerApp());
}

Future<void> _initializeSampleData() async {
  try {
    final foodRepository = FoodRepository();

    final existingFoods = await foodRepository.getAll();
    if (existingFoods.isEmpty) {
      final sampleFoods = SampleData.getSampleFoods();
      for (final food in sampleFoods) {
        await foodRepository.add(food.id, food);
      }
    }
  } catch (e) {
    debugPrint('Error initializing sample data: $e');
  }
}

class CaloriesTrackerApp extends StatelessWidget {
  const CaloriesTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DiaryRepository>(
          create: (context) => DiaryRepository(),
        ),
        RepositoryProvider<FoodRepository>(
          create: (context) => FoodRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>(
            create: (context) => SettingsCubit()..loadSettings(),
          ),
          BlocProvider<DiaryBloc>(
            create: (context) => DiaryBloc(context.read<DiaryRepository>()),
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            return MaterialApp(
              title: 'Calories Tracker',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settingsState.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}

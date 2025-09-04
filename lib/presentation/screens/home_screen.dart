import 'package:calories_tracker/presentation/screens/diary/diary_food_screen.dart';
import 'package:flutter/material.dart';
import 'fasting/fasting_screen.dart';
import 'progress/progress_screen.dart';
import 'recipes/recipes_screen.dart';
import 'settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DiaryScreen(),
    const FastingScreen(),
    const ProgressScreen(),
    const RecipesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Diario'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Digiuno'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Progressi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Ricette',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Impostazioni',
          ),
        ],
      ),
    );
  }
}

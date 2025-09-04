import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTimeRange = 0; // 0: Week, 1: Month, 2: Year

  final List<double> weeklyWeights = [70.5, 70.3, 70.1, 69.9, 69.8, 69.6, 69.4];
  final List<double> weeklyCalories = [
    2100,
    1950,
    2200,
    1800,
    2050,
    2300,
    1900,
  ];
  final List<int> weeklyFastingHours = [16, 18, 16, 20, 16, 16, 18];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progressi'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.onSecondary,
          unselectedLabelColor: Theme.of(
            context,
          ).colorScheme.onSecondary.withOpacity(0.7),
          indicatorColor: Theme.of(context).colorScheme.onSecondary,
          tabs: const [
            Tab(text: 'Peso', icon: Icon(Icons.monitor_weight)),
            Tab(text: 'Calorie', icon: Icon(Icons.local_fire_department)),
            Tab(text: 'Digiuno', icon: Icon(Icons.timer)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildWeightTab(), _buildCaloriesTab(), _buildFastingTab()],
      ),
    );
  }

  Widget _buildWeightTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTimeRangeSelector(),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.monitor_weight,
                    size: 40,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Peso Attuale',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '69.4 kg',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        '-1.1 kg questa settimana',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Andamento Peso',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final days = [
                                    'Lun',
                                    'Mar',
                                    'Mer',
                                    'Gio',
                                    'Ven',
                                    'Sab',
                                    'Dom',
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < days.length) {
                                    return Text(days[value.toInt()]);
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) =>
                                    Text('${value.toInt()}kg'),
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: weeklyWeights
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                                  .toList(),
                              isCurved: true,
                              color: Theme.of(context).colorScheme.secondary,
                              barWidth: 3,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTimeRangeSelector(),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Media Settimanale',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '2043 kcal',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'Obiettivo: 2000 kcal',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calorie Giornaliere',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final days = [
                                    'L',
                                    'M',
                                    'M',
                                    'G',
                                    'V',
                                    'S',
                                    'D',
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < days.length) {
                                    return Text(days[value.toInt()]);
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) =>
                                    Text('${value.toInt()}'),
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          barGroups: weeklyCalories
                              .asMap()
                              .entries
                              .map(
                                (e) => BarChartGroupData(
                                  x: e.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: e.value,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 20,
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFastingTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTimeRangeSelector(),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Media Settimanale',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '17h',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'Obiettivo: 16h',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ore di Digiuno',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final days = [
                                    'L',
                                    'M',
                                    'M',
                                    'G',
                                    'V',
                                    'S',
                                    'D',
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < days.length) {
                                    return Text(days[value.toInt()]);
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) =>
                                    Text('${value.toInt()}h'),
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          barGroups: weeklyFastingHours
                              .asMap()
                              .entries
                              .map(
                                (e) => BarChartGroupData(
                                  x: e.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: e.value.toDouble(),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 20,
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(child: _buildTimeRangeButton('7G', 0)),
            Expanded(child: _buildTimeRangeButton('30G', 1)),
            Expanded(child: _buildTimeRangeButton('1A', 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeButton(String label, int index) {
    final isSelected = _selectedTimeRange == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedTimeRange = index;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onSecondary
              : Theme.of(context).colorScheme.onSurface,
        ),
        child: Text(label),
      ),
    );
  }
}

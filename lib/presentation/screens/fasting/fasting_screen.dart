import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/app_logo.dart';

class FastingScreen extends StatefulWidget {
  const FastingScreen({super.key});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  Timer? _timer;
  bool _isFasting = false;
  DateTime? _startTime;
  Duration _fastingDuration = Duration.zero;
  int _selectedFastingHours = 16; // Default: 16:8

  final List<int> _fastingOptions = [12, 14, 16, 18, 20, 24];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startFasting() {
    setState(() {
      _isFasting = true;
      _startTime = DateTime.now();
      _fastingDuration = Duration.zero;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        setState(() {
          _fastingDuration = DateTime.now().difference(_startTime!);
        });
      }
    });
  }

  void _stopFasting() {
    setState(() {
      _isFasting = false;
      _startTime = null;
      _fastingDuration = Duration.zero;
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogo(width: 32, height: 32),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Digiuno Intermittente',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
  backgroundColor: Theme.of(context).colorScheme.primary,
  foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!_isFasting) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seleziona Tipo di Digiuno',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: _fastingOptions.length,
                          itemBuilder: (context, index) {
                            final hours = _fastingOptions[index];
                            final isSelected = hours == _selectedFastingHours;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFastingHours = hours;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                  color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '$hours:${24 - hours}',
                                    style: TextStyle(
                    color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: Stack(
                          children: [
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              ),
                            ),
                            if (_isFasting)
                              SizedBox(
                                width: 180,
                                height: 180,
                                child: CircularProgressIndicator(
                                  value:
                                      _fastingDuration.inHours /
                                      _selectedFastingHours,
                                  strokeWidth: 8,
                                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _fastingDuration.inHours >=
                                            _selectedFastingHours
                                        ? Theme.of(context).colorScheme.secondary
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            Positioned.fill(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _formatDuration(_fastingDuration),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _isFasting ? 'In corso' : 'Pronto',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      if (_isFasting) ...[
                        Text(
                          'Obiettivo: $_selectedFastingHours ore',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Rimanenti: ${_selectedFastingHours - _fastingDuration.inHours}h ${60 - _fastingDuration.inMinutes % 60}m',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Digiuno $_selectedFastingHours:${24 - _selectedFastingHours}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Digiuni per $_selectedFastingHours ore, mangia per ${24 - _selectedFastingHours} ore',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isFasting ? _stopFasting : _startFasting,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFasting ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isFasting ? 'Interrompi Digiuno' : 'Inizia Digiuno',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}

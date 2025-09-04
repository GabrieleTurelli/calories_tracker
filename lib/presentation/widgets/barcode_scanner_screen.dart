import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/models/food.dart';
import '../../data/repositories/food_repository.dart';
import '../../core/theme/app_theme.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final Function(Food)? onFoodFound;

  const BarcodeScannerScreen({super.key, this.onFoodFound});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _initializeScanner() async {
    try {
      await cameraController.start();
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> _onBarcodeDetected(BarcodeCapture barcodeCapture) async {
    if (_isLoading) return;

    final barcode = barcodeCapture.barcodes.first.rawValue;
    if (barcode == null || barcode.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repo = FoodRepository();
      final food = await repo.getByBarcode(barcode);

      if (food != null) {
        if (widget.onFoodFound != null) {
          widget.onFoodFound!(food);
        }
        Navigator.of(context).pop(food);
      } else {
        _showProductNotFoundDialog(barcode);
      }
    } catch (e) {
      _showErrorDialog('Errore durante la ricerca del prodotto: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showProductNotFoundDialog(String barcode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prodotto non trovato'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Il prodotto con barcode $barcode non è stato trovato nel database.',
            ),
            const SizedBox(height: 16),
            const Text('Vuoi aggiungerlo manualmente?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showManualEntryDialog(barcode);
            },
            child: const Text('Aggiungi manualmente'),
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog(String barcode) {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aggiungi prodotto manualmente'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome prodotto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calorie per 100g',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Proteine per 100g',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: carbsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Carboidrati per 100g',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: fatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Grassi per 100g',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final food = Food(
                  id: barcode,
                  name: nameController.text,
                  calories: double.tryParse(caloriesController.text) ?? 0,
                  protein: double.tryParse(proteinController.text) ?? 0,
                  carbs: double.tryParse(carbsController.text) ?? 0,
                  fat: double.tryParse(fatController.text) ?? 0,
                  barcode: barcode,
                );
                final repo = FoodRepository();
                await repo.add(food.id, food);
                if (widget.onFoodFound != null) {
                  widget.onFoodFound!(food);
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop(food);
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Errore'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner Barcode'),
        backgroundColor: AppColors.tangerinePrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.camera_rear),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onBarcodeDetected,
            errorBuilder: (context, error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 64,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Errore fotocamera: ${error.errorDetails?.message ?? 'Sconosciuto'}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await cameraController.start();
                        } catch (e) {
                          print('Errore restart camera: $e');
                        }
                      },
                      child: const Text('Riprova'),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTextStylesHelper.textPrimary(
                  context,
                ).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Inquadra il barcode del prodotto alimentare',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: AppTextStylesHelper.textPrimary(
                context,
              ).withValues(alpha: 0.8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.tangerinePrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ricerca prodotto...',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

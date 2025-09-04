import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/models/food.dart';
import '../../data/services/open_food_facts_service.dart';
import '../../core/theme/app_theme.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final Function(Food)? onFoodFound;

  const BarcodeScannerScreen({super.key, this.onFoodFound});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late MobileScannerController cameraController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeDetected(BarcodeCapture barcodeCapture) async {
    if (_isLoading) return;

    final barcode = barcodeCapture.barcodes.first.rawValue;
    if (barcode == null || barcode.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final food = await OpenFoodFactsService.getProductByBarcode(barcode);

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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showAddProductDialog(barcode);
            },
            child: const Text('Aggiungi'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(String barcode) {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aggiungi Prodotto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Barcode: $barcode'),
              const SizedBox(height: 16),
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
                decoration: const InputDecoration(
                  labelText: 'Calorie (per 100g)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: proteinController,
                      decoration: const InputDecoration(
                        labelText: 'Proteine (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: carbsController,
                      decoration: const InputDecoration(
                        labelText: 'Carbs (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: fatController,
                      decoration: const InputDecoration(
                        labelText: 'Grassi (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final food = Food(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  calories: double.tryParse(caloriesController.text) ?? 0,
                  protein: double.tryParse(proteinController.text) ?? 0,
                  carbs: double.tryParse(carbsController.text) ?? 0,
                  fat: double.tryParse(fatController.text) ?? 0,
                  barcode: barcode,
                );

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner Barcode'),
        backgroundColor: AppColors.tangerinePrimary,
        foregroundColor: AppColors.cardBackground,
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
              child: const Text(
                'Punta la fotocamera verso un codice a barre',
                style: TextStyle(
                  color: AppColors.cardBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.tangerinePrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cercando prodotto...',
                      style: TextStyle(
                        color: AppColors.cardBackground,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Center(
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.tangerinePrimary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

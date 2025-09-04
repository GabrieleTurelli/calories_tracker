import 'package:flutter/material.dart';
import '../../data/models/food.dart';
import 'barcode_scanner_screen.dart';

class AddFoodDialog extends StatefulWidget {
  final Function(Food, double)? onFoodAdded;

  const AddFoodDialog({super.key, this.onFoodAdded});

  @override
  State<AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '100',
  );

  final List<Food> _availableFoods = [
    Food(
      id: '1',
      name: 'Pollo petto',
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
    ),
    Food(
      id: '2',
      name: 'Riso integrale',
      calories: 111,
      protein: 2.6,
      carbs: 23,
      fat: 0.9,
    ),
    Food(
      id: '3',
      name: 'Broccoli',
      calories: 34,
      protein: 2.8,
      carbs: 7,
      fat: 0.4,
    ),
    Food(
      id: '4',
      name: 'Banana',
      calories: 89,
      protein: 1.1,
      carbs: 23,
      fat: 0.3,
    ),
    Food(
      id: '5',
      name: 'Salmone',
      calories: 208,
      protein: 20,
      carbs: 0,
      fat: 13,
    ),
    Food(
      id: '6',
      name: 'Avocado',
      calories: 160,
      protein: 2,
      carbs: 9,
      fat: 15,
    ),
    Food(
      id: '7',
      name: 'Uova',
      calories: 155,
      protein: 13,
      carbs: 1.1,
      fat: 11,
    ),
    Food(
      id: '8',
      name: 'Spinaci',
      calories: 23,
      protein: 2.9,
      carbs: 3.6,
      fat: 0.4,
    ),
    Food(
      id: '9',
      name: 'Yogurt greco',
      calories: 59,
      protein: 10,
      carbs: 3.6,
      fat: 0.4,
    ),
    Food(
      id: '10',
      name: 'Mandorle',
      calories: 579,
      protein: 21,
      carbs: 22,
      fat: 50,
    ),
    Food(
      id: '11',
      name: 'Pane integrale',
      calories: 247,
      protein: 13,
      carbs: 41,
      fat: 4.2,
    ),
    Food(
      id: '12',
      name: 'Pasta integrale',
      calories: 124,
      protein: 5,
      carbs: 25,
      fat: 1.1,
    ),
    Food(
      id: '13',
      name: 'Olio extravergine',
      calories: 884,
      protein: 0,
      carbs: 0,
      fat: 100,
    ),
    Food(
      id: '14',
      name: 'Mela',
      calories: 52,
      protein: 0.3,
      carbs: 14,
      fat: 0.2,
    ),
    Food(
      id: '15',
      name: 'Tonno in scatola',
      calories: 116,
      protein: 25.5,
      carbs: 0,
      fat: 0.8,
    ),
  ];

  List<Food> _filteredFoods = [];
  Food? _selectedFood;

  @override
  void initState() {
    super.initState();
    _filteredFoods = _availableFoods;
    _searchController.addListener(_filterFoods);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _filterFoods() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFoods = _availableFoods
          .where((food) => food.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _openBarcodeScanner() async {
    try {
      final result = await Navigator.of(context).push<Food>(
        MaterialPageRoute(
          builder: (context) => BarcodeScannerScreen(
            onFoodFound: (food) {
            },
          ),
        ),
      );

      if (result != null) {
        bool foodExists = _availableFoods.any((f) => f.id == result.id);
        if (!foodExists) {
          setState(() {
            _availableFoods.add(result);
            _filteredFoods = _availableFoods;
            _selectedFood = result;
          });
        } else {
          setState(() {
            _selectedFood = result;
          });
        }

        _searchController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore durante la scansione: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Aggiungi Cibo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: _openBarcodeScanner,
                  tooltip: 'Scansiona barcode',
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca cibo...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _filteredFoods.length,
                itemBuilder: (context, index) {
                  final food = _filteredFoods[index];
                  final isSelected = _selectedFood?.id == food.id;

                  return Card(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : null,
                    child: ListTile(
                      title: Text(food.name),
                      subtitle: Text('${food.calories} kcal per 100g'),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedFood = food;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            if (_selectedFood != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Quantità (g): '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedFood != null ? _addFoodToDiary : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Aggiungi al Diario'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addFoodToDiary() {
    if (_selectedFood == null) return;

    final quantity = double.tryParse(_quantityController.text) ?? 100;

    if (widget.onFoodAdded != null) {
      widget.onFoodAdded!(_selectedFood!, quantity);
    }

    Navigator.of(context).pop();
  }
}

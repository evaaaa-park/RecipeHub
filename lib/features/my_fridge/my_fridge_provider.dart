import 'package:flutter/foundation.dart';
import 'package:recipehub/data/models/models.dart';
import 'package:recipehub/data/repositories/repositories.dart';

class MyFridgeProvider extends ChangeNotifier {
  MyFridgeProvider({
    required FridgeItemRepository fridgeRepository,
  }) : _fridgeRepository = fridgeRepository;

  final FridgeItemRepository _fridgeRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<FridgeItem> _items = const <FridgeItem>[];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<FridgeItem> get items => _items;

  Future<void> loadFridgeItems() async {
    _setLoading(true);
    try {
      _items = await _fridgeRepository.getAllFridgeItems();
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'Failed to load fridge items.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addIngredient(Ingredient ingredient) async {
    await _fridgeRepository.addIngredientToFridge(
      ingredientId: ingredient.id,
      ingredientName: ingredient.name,
    );
    await loadFridgeItems();
  }

  Future<void> updateItem({
    required int ingredientId,
    String? quantity,
    String? expiryDate,
    bool? isSelected,
  }) async {
    await _fridgeRepository.updateFridgeItem(
      ingredientId: ingredientId,
      quantity: quantity,
      expiryDate: expiryDate,
      isSelected: isSelected,
    );
    await loadFridgeItems();
  }

  Future<void> toggleSelection(FridgeItem item, bool value) async {
    await updateItem(ingredientId: item.ingredientId, isSelected: value);
  }

  Future<void> deleteItem(int ingredientId) async {
    await _fridgeRepository.deleteIngredientFromFridge(ingredientId);
    await loadFridgeItems();
  }

  List<FridgeItem> get selectedItems =>
      _items.where((item) => item.isSelected).toList(growable: false);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

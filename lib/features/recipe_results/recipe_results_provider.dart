import 'package:flutter/foundation.dart';
import 'package:recipehub/data/repositories/repositories.dart';
import 'package:recipehub/data/services/recipe_match_service.dart';

class RecipeResultsProvider extends ChangeNotifier {
  RecipeResultsProvider({
    required RecipeRepository recipeRepository,
    required FridgeItemRepository fridgeRepository,
  }) : _recipeRepository = recipeRepository,
       _fridgeRepository = fridgeRepository;

  final RecipeRepository _recipeRepository;
  final FridgeItemRepository _fridgeRepository;

  bool _isLoading = false;
  String? _errorMessage;
  bool _noSelection = false;
  List<RecipeMatchResult> _results = const <RecipeMatchResult>[];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get noSelection => _noSelection;
  List<RecipeMatchResult> get results => _results;

  Future<void> searchFromSelectedFridgeIngredients() async {
    _setLoading(true);
    try {
      final selectedItems = await _fridgeRepository.getSelectedFridgeItems();
      final List<String> selectedIngredients = selectedItems
          .map((item) => item.ingredientName)
          .where((name) => name.trim().isNotEmpty)
          .toList(growable: false);

      if (selectedIngredients.isEmpty) {
        _noSelection = true;
        _results = const <RecipeMatchResult>[];
        _errorMessage = null;
      } else {
        _noSelection = false;
        _results = await _recipeRepository.searchRecipesBySelectedIngredients(
          selectedIngredients,
        );
        _errorMessage = null;
      }
    } catch (_) {
      _errorMessage = 'Failed to search recipes.';
    } finally {
      _setLoading(false);
    }
  }

  void clearState() {
    _results = const <RecipeMatchResult>[];
    _noSelection = false;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

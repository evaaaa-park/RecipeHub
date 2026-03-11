import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:recipehub/data/models/models.dart';
import 'package:recipehub/data/repositories/repositories.dart';

class IngredientsProvider extends ChangeNotifier {
  IngredientsProvider({
    required IngredientRepository ingredientRepository,
    required CategoryRepository categoryRepository,
  }) : _ingredientRepository = ingredientRepository,
       _categoryRepository = categoryRepository;

  final IngredientRepository _ingredientRepository;
  final CategoryRepository _categoryRepository;

  bool _isLoading = false;
  String _searchQuery = '';
  String? _errorMessage;
  List<Ingredient> _ingredients = const <Ingredient>[];
  List<Category> _categories = const <Category>[];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  List<Ingredient> get ingredients => _ingredients;
  List<Category> get categories => _categories;

  Future<void> loadInitialData() async {
    _setLoading(true);
    try {
      _categories = await _categoryRepository.getAllCategories();
      _ingredients = await _ingredientRepository.getAllIngredients();
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'Failed to load ingredients.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    _setLoading(true);
    try {
      _ingredients = await _ingredientRepository.searchIngredients(query);
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'Failed to search ingredients.';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:recipehub/data/models/models.dart';
import 'package:recipehub/data/repositories/repositories.dart';

class SavedRecipesProvider extends ChangeNotifier {
  SavedRecipesProvider({
    required SavedRecipeRepository savedRecipeRepository,
  }) : _savedRecipeRepository = savedRecipeRepository;

  final SavedRecipeRepository _savedRecipeRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<SavedRecipe> _savedRecipes = const <SavedRecipe>[];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<SavedRecipe> get savedRecipes => _savedRecipes;

  Future<void> loadSavedRecipes() async {
    _setLoading(true);
    try {
      _savedRecipes = await _savedRecipeRepository.getSavedRecipes();
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'Failed to load saved recipes.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveRecipe(Recipe recipe) async {
    await _savedRecipeRepository.saveRecipe(
      recipeId: recipe.id,
      recipeTitle: recipe.title,
    );
    await loadSavedRecipes();
  }

  Future<void> unsaveRecipe(int recipeId) async {
    await _savedRecipeRepository.unsaveRecipe(recipeId);
    await loadSavedRecipes();
  }

  bool isSaved(int recipeId) {
    return _savedRecipes.any((recipe) => recipe.recipeId == recipeId);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

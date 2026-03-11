import 'package:recipehub/data/database/app_database.dart';
import 'package:recipehub/data/database/db_tables.dart';
import 'package:recipehub/data/models/recipe.dart';
import 'package:recipehub/data/services/recipe_match_service.dart';

class RecipeRepository {
  RecipeRepository({
    AppDatabase? database,
    RecipeMatchService? matchService,
  }) : _database = database ?? AppDatabase.instance,
       _matchService = matchService ?? const RecipeMatchService();

  final AppDatabase _database;
  final RecipeMatchService _matchService;

  Future<List<Recipe>> getAllRecipes() async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.recipes,
      orderBy: 'title COLLATE NOCASE ASC',
    );
    return rows.map(Recipe.fromMap).toList();
  }

  Future<Recipe?> getRecipeById(int recipeId) async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.recipes,
      where: 'id = ?',
      whereArgs: <Object?>[recipeId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return Recipe.fromMap(rows.first);
  }

  Future<List<RecipeMatchResult>> searchRecipesBySelectedIngredients(
    List<String> selectedIngredients,
  ) async {
    final List<Recipe> allRecipes = await getAllRecipes();
    return _matchService.matchRecipes(
      recipes: allRecipes,
      selectedIngredients: selectedIngredients,
    );
  }
}

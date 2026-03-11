import 'package:recipehub/data/database/app_database.dart';
import 'package:recipehub/data/database/db_tables.dart';
import 'package:recipehub/data/models/saved_recipe.dart';

class SavedRecipeRepository {
  SavedRecipeRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<List<SavedRecipe>> getSavedRecipes() async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.savedRecipes,
      orderBy: 'saved_at DESC',
    );
    return rows.map(SavedRecipe.fromMap).toList();
  }

  Future<bool> isRecipeSaved(int recipeId) async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.savedRecipes,
      columns: <String>['id'],
      where: 'recipe_id = ?',
      whereArgs: <Object?>[recipeId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
}

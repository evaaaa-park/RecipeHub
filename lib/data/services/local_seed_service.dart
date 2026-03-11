import 'package:recipehub/core/constants/app_preferences_keys.dart';
import 'package:recipehub/data/database/app_database.dart';
import 'package:recipehub/data/database/db_tables.dart';
import 'package:recipehub/data/models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'csv_seed_parser_service.dart';

class LocalSeedService {
  LocalSeedService({
    AppDatabase? database,
    CsvSeedParserService? parserService,
  }) : _database = database ?? AppDatabase.instance,
       _parserService = parserService ?? const CsvSeedParserService();

  final AppDatabase _database;
  final CsvSeedParserService _parserService;

  Future<bool> seedIfNeeded() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(AppPreferenceKeys.seedCompleted) ?? false) {
      return false;
    }

    final List<Category> categories = await _parserService.parseCategories();
    final List<Ingredient> ingredients = await _parserService.parseIngredients();
    final List<Recipe> recipes = await _parserService.parseRecipes();
    final db = await _database.database;

    await db.transaction((txn) async {
      final Batch batch = txn.batch();

      batch.delete(DbTables.categories);
      batch.delete(DbTables.ingredients);
      batch.delete(DbTables.recipes);

      for (final Category category in categories) {
        batch.insert(
          DbTables.categories,
          <String, Object?>{'name': category.name},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      for (final Ingredient ingredient in ingredients) {
        batch.insert(
          DbTables.ingredients,
          <String, Object?>{
            'name': ingredient.name,
            'category_name': ingredient.category,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      for (final Recipe recipe in recipes) {
        batch.insert(
          DbTables.recipes,
          recipe.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    });

    await prefs.setBool(AppPreferenceKeys.seedCompleted, true);
    return true;
  }
}

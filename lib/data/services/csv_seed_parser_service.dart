import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:recipehub/core/constants/app_assets.dart';
import 'package:recipehub/data/models/models.dart';

class CsvSeedParserService {
  const CsvSeedParserService();

  Future<List<Category>> parseCategories() async {
    final List<List<dynamic>> rows = await _loadCsvRows(AppAssets.categoriesCsv);
    if (rows.isEmpty) {
      return const <Category>[];
    }

    final List<Category> categories = <Category>[];
    final Set<String> seenNames = <String>{};
    int id = 1;

    for (int i = 1; i < rows.length; i++) {
      final List<dynamic> row = rows[i];
      final String name = _clean(row.isNotEmpty ? row.first : null);
      if (name.isEmpty || seenNames.contains(name.toLowerCase())) {
        continue;
      }

      seenNames.add(name.toLowerCase());
      categories.add(Category(id: id, name: name));
      id++;
    }
    return categories;
  }

  Future<List<Ingredient>> parseIngredients() async {
    final List<List<dynamic>> rows = await _loadCsvRows(AppAssets.ingredientsCsv);
    if (rows.length < 2) {
      return const <Ingredient>[];
    }

    final Map<String, int> headers = _headerIndex(rows.first);
    final int ingredientIndex = headers['ingredient'] ?? 0;
    final int categoryIndex = headers['category'] ?? 1;

    final List<Ingredient> ingredients = <Ingredient>[];
    final Set<String> seenNames = <String>{};
    int id = 1;

    for (int i = 1; i < rows.length; i++) {
      final List<dynamic> row = rows[i];
      final String name = _clean(_safeGet(row, ingredientIndex));
      final String category = _clean(_safeGet(row, categoryIndex));
      if (name.isEmpty || category.isEmpty) {
        continue;
      }

      final String key = name.toLowerCase();
      if (seenNames.contains(key)) {
        continue;
      }
      seenNames.add(key);
      ingredients.add(Ingredient(id: id, name: name, category: category));
      id++;
    }
    return ingredients;
  }

  Future<List<Recipe>> parseRecipes() async {
    final List<List<dynamic>> rows = await _loadCsvRows(AppAssets.recipesCsv);
    if (rows.length < 2) {
      return const <Recipe>[];
    }

    final Map<String, int> headers = _headerIndex(rows.first);
    final int idIndex = headers['id'] ?? 0;
    final int titleIndex = headers['title'] ?? 1;
    final int ingredientsIndex = headers['ingredients'] ?? 2;
    final int instructionsIndex = headers['instructions'] ?? 3;
    final int imageIndex = headers['image_name'] ?? 4;
    final int cleanedIndex = headers['cleaned_ingredients'] ?? 5;

    final List<Recipe> recipes = <Recipe>[];
    final Set<int> seenIds = <int>{};

    for (int i = 1; i < rows.length; i++) {
      final List<dynamic> row = rows[i];
      final int? id = _tryParseInt(_safeGet(row, idIndex));
      final String title = _clean(_safeGet(row, titleIndex));
      final String ingredientsRaw = _clean(_safeGet(row, ingredientsIndex));
      final String instructions = _clean(_safeGet(row, instructionsIndex));
      final String imageName = _clean(_safeGet(row, imageIndex));
      String cleanedIngredients = _clean(_safeGet(row, cleanedIndex));

      if (id == null ||
          title.isEmpty ||
          ingredientsRaw.isEmpty ||
          instructions.isEmpty) {
        continue;
      }

      if (seenIds.contains(id)) {
        continue;
      }
      seenIds.add(id);

      if (cleanedIngredients.isEmpty) {
        cleanedIngredients = ingredientsRaw;
      }

      recipes.add(
        Recipe(
          id: id,
          title: title,
          ingredientsRaw: ingredientsRaw,
          instructions: instructions,
          imageName: imageName,
          cleanedIngredients: cleanedIngredients,
        ),
      );
    }
    return recipes;
  }

  Future<List<List<dynamic>>> _loadCsvRows(String path) async {
    final String csvContent = await rootBundle.loadString(path);
    final List<List<dynamic>> rows = const CsvDecoder(
      dynamicTyping: false,
      skipEmptyLines: true,
    ).convert(csvContent);
    return rows;
  }

  Map<String, int> _headerIndex(List<dynamic> headerRow) {
    final Map<String, int> index = <String, int>{};
    for (int i = 0; i < headerRow.length; i++) {
      final String raw = _clean(headerRow[i]).toLowerCase();
      final String normalized = raw
          .replaceAll(' ', '_')
          .replaceAll('-', '_')
          .replaceAll('__', '_');
      if (normalized.isNotEmpty) {
        index[normalized] = i;
      }
    }
    return index;
  }

  dynamic _safeGet(List<dynamic> row, int index) {
    if (index < 0 || index >= row.length) {
      return null;
    }
    return row[index];
  }

  int? _tryParseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    final String raw = _clean(value);
    return int.tryParse(raw);
  }

  String _clean(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:recipehub/data/services/csv_seed_parser_service.dart';

void main() {
  const CsvSeedParserService parser = CsvSeedParserService();

  group('CsvSeedParserService', () {
    test('parseCategoriesFromRows skips empty values and duplicates', () {
      final rows = <List<dynamic>>[
        <dynamic>['Category List'],
        <dynamic>['Vegetables'],
        <dynamic>[''],
        <dynamic>['vegetables'],
        <dynamic>['Dairy & Eggs'],
      ];

      final categories = parser.parseCategoriesFromRows(rows);

      expect(categories.length, 2);
      expect(categories.first.name, 'Vegetables');
      expect(categories.last.name, 'Dairy & Eggs');
    });

    test('parseIngredientsFromRows handles malformed and extra columns', () {
      final rows = <List<dynamic>>[
        <dynamic>['Ingredient', 'Category', 'Extra'],
        <dynamic>['Carrot', 'Vegetables', 'x'],
        <dynamic>['', 'Vegetables', 'x'],
        <dynamic>['Milk', 'Dairy & Eggs', null],
        <dynamic>['carrot', 'Vegetables', 'duplicate'],
      ];

      final ingredients = parser.parseIngredientsFromRows(rows);

      expect(ingredients.length, 2);
      expect(ingredients[0].name, 'Carrot');
      expect(ingredients[1].name, 'Milk');
    });

    test('parseRecipesFromRows skips invalid ids and fills missing cleaned list', () {
      final rows = <List<dynamic>>[
        <dynamic>[
          'id',
          'Title',
          'Ingredients',
          'Instructions',
          'Image_Name',
          'Cleaned_Ingredients',
          'Column 1',
        ],
        <dynamic>['1', 'Pasta', '[tomato]', 'Cook', 'pasta-image', '', null],
        <dynamic>['bad-id', 'Skip Me', '[x]', 'Cook', 'img', '[x]'],
        <dynamic>['2', 'Salad', '[lettuce]', 'Mix', 'salad-image', '[lettuce]'],
      ];

      final recipes = parser.parseRecipesFromRows(rows);

      expect(recipes.length, 2);
      expect(recipes.first.id, 1);
      expect(recipes.first.cleanedIngredients, '[tomato]');
      expect(recipes.last.id, 2);
    });
  });
}

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.ingredientsRaw,
    required this.instructions,
    required this.imageName,
    required this.cleanedIngredients,
  });

  final int id;
  final String title;
  final String ingredientsRaw;
  final String instructions;
  final String imageName;
  final String cleanedIngredients;

  factory Recipe.fromMap(Map<String, Object?> map) {
    return Recipe(
      id: _toInt(map['id']),
      title: (map['title'] ?? '').toString(),
      ingredientsRaw: (map['ingredients_raw'] ?? '').toString(),
      instructions: (map['instructions'] ?? '').toString(),
      imageName: (map['image_name'] ?? '').toString(),
      cleanedIngredients: (map['cleaned_ingredients'] ?? '').toString(),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'ingredients_raw': ingredientsRaw,
      'instructions': instructions,
      'image_name': imageName,
      'cleaned_ingredients': cleanedIngredients,
    };
  }
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }
  return int.tryParse((value ?? '0').toString()) ?? 0;
}

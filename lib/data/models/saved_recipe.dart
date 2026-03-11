class SavedRecipe {
  const SavedRecipe({
    required this.id,
    required this.recipeId,
    required this.recipeTitle,
    required this.savedAt,
  });

  final int id;
  final int recipeId;
  final String recipeTitle;
  final String savedAt;

  factory SavedRecipe.fromMap(Map<String, Object?> map) {
    return SavedRecipe(
      id: _toInt(map['id']),
      recipeId: _toInt(map['recipe_id']),
      recipeTitle: (map['recipe_title'] ?? '').toString(),
      savedAt: (map['saved_at'] ?? '').toString(),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id == 0 ? null : id,
      'recipe_id': recipeId,
      'recipe_title': recipeTitle,
      'saved_at': savedAt,
    };
  }
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }
  return int.tryParse((value ?? '0').toString()) ?? 0;
}

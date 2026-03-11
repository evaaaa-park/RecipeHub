class Ingredient {
  const Ingredient({
    required this.id,
    required this.name,
    required this.category,
  });

  final int id;
  final String name;
  final String category;

  factory Ingredient.fromMap(Map<String, Object?> map) {
    return Ingredient(
      id: _toInt(map['id']),
      name: (map['name'] ?? '').toString(),
      category: (map['category_name'] ?? map['category'] ?? '').toString(),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'category_name': category,
    };
  }
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }
  return int.tryParse((value ?? '0').toString()) ?? 0;
}

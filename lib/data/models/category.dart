class Category {
  const Category({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Category.fromMap(Map<String, Object?> map) {
    return Category(
      id: _toInt(map['id']),
      name: (map['name'] ?? '').toString(),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'name': name,
    };
  }
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }
  return int.tryParse((value ?? '0').toString()) ?? 0;
}

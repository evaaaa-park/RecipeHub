class FridgeItem {
  const FridgeItem({
    required this.id,
    required this.ingredientId,
    required this.ingredientName,
    required this.quantity,
    required this.expiryDate,
    required this.isSelected,
    required this.addedAt,
  });

  final int id;
  final int ingredientId;
  final String ingredientName;
  final String? quantity;
  final String? expiryDate;
  final bool isSelected;
  final String addedAt;

  factory FridgeItem.fromMap(Map<String, Object?> map) {
    return FridgeItem(
      id: _toInt(map['id']),
      ingredientId: _toInt(map['ingredient_id']),
      ingredientName: (map['ingredient_name'] ?? '').toString(),
      quantity: _toNullableString(map['quantity']),
      expiryDate: _toNullableString(map['expiry_date']),
      isSelected: _toInt(map['is_selected']) == 1,
      addedAt: (map['added_at'] ?? '').toString(),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id == 0 ? null : id,
      'ingredient_id': ingredientId,
      'ingredient_name': ingredientName,
      'quantity': quantity,
      'expiry_date': expiryDate,
      'is_selected': isSelected ? 1 : 0,
      'added_at': addedAt,
    };
  }

  FridgeItem copyWith({
    int? id,
    int? ingredientId,
    String? ingredientName,
    String? quantity,
    String? expiryDate,
    bool? isSelected,
    String? addedAt,
  }) {
    return FridgeItem(
      id: id ?? this.id,
      ingredientId: ingredientId ?? this.ingredientId,
      ingredientName: ingredientName ?? this.ingredientName,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      isSelected: isSelected ?? this.isSelected,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

String? _toNullableString(Object? value) {
  if (value == null) {
    return null;
  }
  final String parsed = value.toString().trim();
  return parsed.isEmpty ? null : parsed;
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }
  return int.tryParse((value ?? '0').toString()) ?? 0;
}

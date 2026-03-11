import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipehub/app/routes.dart';
import 'package:recipehub/data/models/fridge_item.dart';
import 'package:recipehub/features/my_fridge/my_fridge_provider.dart';

class MyFridgeScreen extends StatelessWidget {
  const MyFridgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Fridge'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.recipeResults);
            },
          ),
        ],
      ),
      body: Consumer<MyFridgeProvider>(
        builder: (context, fridgeProvider, _) {
          if (fridgeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (fridgeProvider.errorMessage != null) {
            return Center(child: Text(fridgeProvider.errorMessage!));
          }
          if (fridgeProvider.items.isEmpty) {
            return const Center(child: Text('No ingredients in My Fridge yet'));
          }

          return ListView.builder(
            itemCount: fridgeProvider.items.length,
            itemBuilder: (context, index) {
              final FridgeItem item = fridgeProvider.items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text(item.ingredientName),
                  subtitle: Text(
                    'Qty: ${item.quantity ?? '-'}  |  Expiry: ${item.expiryDate ?? '-'}',
                  ),
                  leading: Checkbox(
                    value: item.isSelected,
                    onChanged: (value) async {
                      await fridgeProvider.toggleSelection(item, value ?? false);
                    },
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) async {
                      if (action == 'edit') {
                        await _showEditDialog(context, fridgeProvider, item);
                      } else if (action == 'delete') {
                        await fridgeProvider.deleteItem(item.ingredientId);
                      }
                    },
                    itemBuilder: (context) => const <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                      PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    MyFridgeProvider provider,
    FridgeItem item,
  ) async {
    final TextEditingController quantityController = TextEditingController(
      text: item.quantity ?? '',
    );
    final TextEditingController expiryController = TextEditingController(
      text: item.expiryDate ?? '',
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${item.ingredientName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: expiryController,
                decoration: const InputDecoration(
                  labelText: 'Expiry date (YYYY-MM-DD)',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                await provider.updateItem(
                  ingredientId: item.ingredientId,
                  quantity: quantityController.text,
                  expiryDate: expiryController.text,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class MyFridgeScreen extends StatelessWidget {
  const MyFridgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Fridge')),
      body: const Center(
        child: Text('My Fridge screen shell'),
      ),
    );
  }
}

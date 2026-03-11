import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipehub/features/settings/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          if (settings.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Dark mode'),
                value: settings.isDarkMode,
                onChanged: settings.setDarkMode,
              ),
            ],
          );
        },
      ),
    );
  }
}

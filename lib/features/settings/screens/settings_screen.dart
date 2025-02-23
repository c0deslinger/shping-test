// lib/app/modules/settings/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/text_styles.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  static const route = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings',
          style: AppTextStyle.titleLarge,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Settings Section
          Text(
            'language',
            style: AppTextStyle.titleLarge,
          ),
          const SizedBox(height: 8),
          // Theme Settings Section
          Text(
            'theme',
            style: AppTextStyle.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(
                    'lightMode',
                    style: AppTextStyle.bodyMedium,
                  ),
                  value: ThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(
                    'darkMode',
                    style: AppTextStyle.bodyMedium,
                  ),
                  value: ThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(
                    'systemDefault',
                    style: AppTextStyle.bodyMedium,
                  ),
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Image Source Settings Section
          Text(
            'imageSource',
            style: AppTextStyle.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<ImageSource>(
                  title: Text(
                    'unsplash',
                    style: AppTextStyle.bodyMedium,
                  ),
                  subtitle: Text(
                    'highQualityFreeImages',
                    style: AppTextStyle.bodySmall,
                  ),
                  value: ImageSource.unsplash,
                  groupValue: settingsProvider.imageSource,
                  onChanged: (ImageSource? value) {
                    if (value != null) {
                      settingsProvider.setImageSource(value);
                    }
                  },
                ),
                RadioListTile<ImageSource>(
                  title: Text(
                    'pixabay',
                    style: AppTextStyle.bodyMedium,
                  ),
                  subtitle: Text(
                    'communityDrivenPlatform',
                    style: AppTextStyle.bodySmall,
                  ),
                  value: ImageSource.pixabay,
                  groupValue: settingsProvider.imageSource,
                  onChanged: (ImageSource? value) {
                    if (value != null) {
                      settingsProvider.setImageSource(value);
                    }
                  },
                ),
              ],
            ),
          ),

          // Version Info
          const SizedBox(height: 24),
          Center(
            child: Text(
              'version 1.0.0',
              style: AppTextStyle.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/text_styles.dart';
import '../providers/settings_provider.dart';

/// A screen widget that displays various app settings including language, theme and image source options
class SettingsScreen extends StatelessWidget {
  static const route = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  /// Changes the app's language to the specified language code
  void _changeLanguage(BuildContext context, String languageCode) async {
    await context.setLocale(Locale(languageCode));
  }

  /// Builds a section title widget with consistent styling
  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.tr(), style: AppTextStyle.titleLarge),
        const SizedBox(height: 8),
      ],
    );
  }

  /// Builds the language selection section with supported languages
  Widget _buildLanguageSection(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'languages.en'},
      {'code': 'id', 'name': 'languages.id'},
      {'code': 'ja', 'name': 'languages.ja'},
      {'code': 'zh', 'name': 'languages.zh'},
    ];

    return Card(
      child: Column(
        children: languages
            .map((lang) => ListTile(
                  title: Text(lang['name']!.tr()),
                  onTap: () => _changeLanguage(context, lang['code']!),
                  trailing: context.locale.languageCode == lang['code']
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                ))
            .toList(),
      ),
    );
  }

  /// Builds the theme selection section with light, dark and system theme options
  Widget _buildThemeSection(ThemeProvider themeProvider) {
    final themeOptions = [
      {'mode': ThemeMode.light, 'title': 'settings.theme_mode.light'},
      {'mode': ThemeMode.dark, 'title': 'settings.theme_mode.dark'},
      {'mode': ThemeMode.system, 'title': 'settings.theme_mode.system'},
    ];

    return Card(
      child: Column(
        children: themeOptions
            .map((option) => RadioListTile<ThemeMode>(
                  title: Text(option['title'].toString().tr(),
                      style: AppTextStyle.bodyMedium),
                  value: option['mode'] as ThemeMode,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) =>
                      value != null ? themeProvider.setThemeMode(value) : null,
                ))
            .toList(),
      ),
    );
  }

  /// Builds the image source selection section with Unsplash and Pixabay options
  Widget _buildImageSourceSection(SettingsProvider settingsProvider) {
    final sourceOptions = [
      {
        'source': ImageSource.unsplash,
        'title': 'settings.image_source_options.unsplash',
        'desc': 'settings.image_source_options.unsplash_desc'
      },
      {
        'source': ImageSource.pixabay,
        'title': 'settings.image_source_options.pixabay',
        'desc': 'settings.image_source_options.pixabay_desc'
      },
    ];

    return Card(
      child: Column(
        children: sourceOptions
            .map((option) => RadioListTile<ImageSource>(
                  title: Text(option['title'].toString().tr(),
                      style: AppTextStyle.bodyMedium),
                  subtitle: Text(option['desc'].toString().tr(),
                      style: AppTextStyle.bodySmall),
                  value: option['source'] as ImageSource,
                  groupValue: settingsProvider.imageSource,
                  onChanged: (value) => value != null
                      ? settingsProvider.setImageSource(value)
                      : null,
                ))
            .toList(),
      ),
    );
  }

  /// Builds the main settings screen layout with all settings sections
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings.title'.tr(), style: AppTextStyle.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('settings.language'),
          _buildLanguageSection(context),
          const SizedBox(height: 24),
          _buildSectionTitle('settings.theme'),
          _buildThemeSection(themeProvider),
          const SizedBox(height: 24),
          _buildSectionTitle('settings.image_source'),
          _buildImageSourceSection(settingsProvider),
          const SizedBox(height: 24),
          Center(
            child: Text('version 1.0.0', style: AppTextStyle.bodySmall),
          ),
        ],
      ),
    );
  }
}

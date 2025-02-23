import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../providers/settings_provider.dart';

/// A settings screen that displays language, theme and image source options
class SettingsScreen extends StatelessWidget {
  static const String route = '/settings';

  const SettingsScreen({super.key});

  /// Updates app language based on selected language code
  Future<void> _changeLanguage(BuildContext context, String langCode) async {
    await context.setLocale(Locale(langCode));
  }

  /// Builds a section title with consistent styling
  Widget _buildSectionTitle(String title, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 24),
      child: Text(
        title.tr(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  /// Builds language selection section
  Widget _buildLanguageSection(BuildContext context, ColorScheme colors) {
    final languages = [
      {
        'code': 'en',
        'name': 'languages.en',
        'icon': Icons.language,
      },
      {
        'code': 'id',
        'name': 'languages.id',
        'icon': Icons.language,
      },
      {
        'code': 'ja',
        'name': 'languages.ja',
        'icon': Icons.language,
      },
      {
        'code': 'zh',
        'name': 'languages.zh',
        'icon': Icons.language,
      },
    ];

    return Material(
      color: colors.surface,
      child: Column(
        children: languages
            .map((lang) => ListTile(
                  leading: Icon(
                    lang['icon'] as IconData,
                    size: 22,
                  ),
                  title: Text(
                    lang['name'].toString().tr(),
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () =>
                      _changeLanguage(context, lang['code'].toString()),
                  trailing: context.locale.languageCode == lang['code']
                      ? const Icon(
                          Icons.check_rounded,
                          size: 20,
                        )
                      : null,
                  dense: true,
                  horizontalTitleGap: 12,
                ))
            .toList(),
      ),
    );
  }

  /// Builds theme selection section
  Widget _buildThemeSection(ThemeProvider provider, ColorScheme colors) {
    final themes = [
      {
        'mode': ThemeMode.light,
        'title': 'settings.theme_mode.light',
        'icon': Icons.light_mode_rounded
      },
      {
        'mode': ThemeMode.dark,
        'title': 'settings.theme_mode.dark',
        'icon': Icons.dark_mode_rounded
      },
      {
        'mode': ThemeMode.system,
        'title': 'settings.theme_mode.system',
        'icon': Icons.brightness_auto_rounded
      },
    ];

    return Material(
      color: colors.surface,
      child: Column(
        children: themes
            .map((theme) => ListTile(
                  leading: Icon(
                    theme['icon'] as IconData,
                    size: 22,
                  ),
                  title: Text(
                    theme['title'].toString().tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: Radio<ThemeMode>(
                    value: theme['mode'] as ThemeMode,
                    groupValue: provider.themeMode,
                    onChanged: (value) => provider.setThemeMode(value!),
                  ),
                  onTap: () =>
                      provider.setThemeMode(theme['mode'] as ThemeMode),
                  dense: true,
                  horizontalTitleGap: 12,
                ))
            .toList(),
      ),
    );
  }

  /// Builds image source selection section
  Widget _buildImageSourceSection(
    SettingsProvider provider,
    ColorScheme colors,
  ) {
    final sources = [
      {
        'source': ImageSource.unsplash,
        'title': 'settings.image_source_options.unsplash',
        'desc': 'settings.image_source_options.unsplash_desc',
        'icon': Icons.image_rounded
      },
      {
        'source': ImageSource.pixabay,
        'title': 'settings.image_source_options.pixabay',
        'desc': 'settings.image_source_options.pixabay_desc',
        'icon': Icons.photo_library_rounded
      },
    ];

    return Material(
      color: colors.surface,
      child: Column(
        children: sources
            .map((source) => ListTile(
                  leading: Icon(
                    source['icon'] as IconData,
                    size: 22,
                  ),
                  title: Text(
                    source['title'].toString().tr(),
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: Text(
                    source['desc'].toString().tr(),
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Radio<ImageSource>(
                    value: source['source'] as ImageSource,
                    groupValue: provider.imageSource,
                    onChanged: (value) => provider.setImageSource(value!),
                  ),
                  onTap: () =>
                      provider.setImageSource(source['source'] as ImageSource),
                  dense: true,
                  horizontalTitleGap: 12,
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings.title'.tr(),
        ),
        elevation: 0,
        backgroundColor: colors.surface,
      ),
      body: ListView(
        children: [
          _buildSectionTitle('settings.language', colors),
          _buildLanguageSection(context, colors),
          _buildSectionTitle('settings.theme', colors),
          _buildThemeSection(themeProvider, colors),
          _buildSectionTitle('settings.image_source', colors),
          _buildImageSourceSection(settingsProvider, colors),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

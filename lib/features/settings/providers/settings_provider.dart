// lib/app/modules/global/providers/settings_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ImageSource { unsplash, pixabay }

/// Provider for managing application settings, focusing on image source
class SettingsProvider with ChangeNotifier {
  static const String _imageSourceKey = 'image_source';

  /// Currently selected image source
  ImageSource _imageSource = ImageSource.unsplash;
  SharedPreferences? _prefs;
  VoidCallback? onImageSourceChanged;

  /// Constructor initializes preferences and loads saved settings
  SettingsProvider() {
    _loadPreferences();
  }

  /// Getter for current image source
  ImageSource get imageSource => _imageSource;

  /// Loads saved image source preference from SharedPreferences
  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final sourceIndex = _prefs?.getInt(_imageSourceKey) ?? 0;
    _imageSource = ImageSource.values[sourceIndex];
    notifyListeners();
  }

  /// Updates and persists the selected image source
  Future<void> setImageSource(ImageSource source) async {
    if (_imageSource != source) {
      _imageSource = source;
      await _prefs?.setInt(_imageSourceKey, source.index);
      notifyListeners();
      onImageSourceChanged?.call();
    }
  }
}

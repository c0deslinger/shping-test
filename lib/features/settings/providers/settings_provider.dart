// lib/app/modules/global/providers/settings_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ImageSource { unsplash, pixabay }

class SettingsProvider with ChangeNotifier {
  static const String _imageSourceKey = 'image_source';

  ImageSource _imageSource = ImageSource.unsplash;
  SharedPreferences? _prefs;
  VoidCallback? onImageSourceChanged;

  SettingsProvider() {
    _loadPreferences();
  }

  ImageSource get imageSource => _imageSource;

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final sourceIndex = _prefs?.getInt(_imageSourceKey) ?? 0;
    _imageSource = ImageSource.values[sourceIndex];
    notifyListeners();
  }

  Future<void> setImageSource(ImageSource source) async {
    if (_imageSource != source) {
      _imageSource = source;
      await _prefs?.setInt(_imageSourceKey, source.index);
      notifyListeners();
      onImageSourceChanged?.call();
    }
  }
}

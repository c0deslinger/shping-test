import 'package:flutter/foundation.dart';
import 'package:shping_test/core/services/db_helper.dart';
import 'package:shping_test/core/utils/logger.dart';
import '../../home/data/entities/photo.dart';

class FavoriteProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper;
  List<Photo> _favorites = [];

  FavoriteProvider(this._databaseHelper) {
    LoggerUtil.i('Initializing FavoriteProvider');
    _loadFavorites();
  }

  List<Photo> get favorites => _favorites;

  Future<void> _loadFavorites() async {
    try {
      LoggerUtil.d('Loading favorites from database');
      _favorites = await _databaseHelper.getAllFavorites();
      LoggerUtil.i('Loaded ${_favorites.length} favorites from database');
      notifyListeners();
    } catch (e, stackTrace) {
      LoggerUtil.e('Failed to load favorites from database', e, stackTrace);
      _favorites = [];
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Photo photo) async {
    try {
      final isFavorite = await _databaseHelper.isFavorite(photo.id);

      if (isFavorite) {
        LoggerUtil.d('Removing photo ${photo.id} from favorites');
        await _databaseHelper.removeFavorite(photo.id);
        photo.isFavorite = false;
        _favorites.removeWhere((p) => p.id == photo.id);
        LoggerUtil.i(
            'Successfully removed photo ${photo.id} from favorites. Remaining: ${_favorites.length}');
      } else {
        LoggerUtil.d('Adding photo ${photo.id} to favorites');
        final updatedPhoto = await _databaseHelper.insertFavorite(photo);
        _favorites.add(updatedPhoto);
        LoggerUtil.i(
            'Successfully added photo ${photo.id} to favorites. Total: ${_favorites.length}');
      }

      notifyListeners();
    } catch (e, stackTrace) {
      LoggerUtil.e(
        'Error toggling favorite status for photo ${photo.id}',
        e,
        stackTrace,
      );
      // Optionally rethrow the exception if you want to handle it in the UI
      // rethrow;
    }
  }

  Future<bool> checkIsFavorite(String photoId) async {
    try {
      LoggerUtil.d('Checking favorite status for photo $photoId');
      final isFavorite = await _databaseHelper.isFavorite(photoId);
      LoggerUtil.v('Photo $photoId is${isFavorite ? '' : ' not'} in favorites');
      return isFavorite;
    } catch (e, stackTrace) {
      LoggerUtil.e(
        'Error checking favorite status for photo $photoId',
        e,
        stackTrace,
      );
      return false;
    }
  }

  // Optional: Add method to refresh favorites
  Future<void> refreshFavorites() async {
    LoggerUtil.d('Refreshing favorites list');
    await _loadFavorites();
  }
}

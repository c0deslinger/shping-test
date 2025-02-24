import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:shping_test/features/settings/providers/settings_provider.dart';

/// Defines local storage operations for caching photo data
abstract class PhotoLocalDataSource {
  /// Retrieves cached photos for a specific source
  Future<List<Photo>> getPhotos(ImageSource imagesource);

  /// Caches a list of photos with support for pagination
  Future<void> cachePhotos(ImageSource sourceKey, List<Photo> photos,
      {required int page});

  /// Retrieves cached search results for a specific query
  Future<List<Photo>> getSearchResults(ImageSource sourceKey, String query);

  /// Caches search results with support for pagination
  Future<void> cacheSearchResults(
      ImageSource sourceKey, String query, List<Photo> photos,
      {required int page});

  /// Retrieves a specific photo's details from cache
  Future<Photo?> getPhotoDetails(ImageSource sourceKey, String id);

  /// Caches details of a specific photo
  Future<void> cachePhotoDetails(ImageSource sourceKey, Photo photo);

  /// Clears all cached photo data
  Future<void> clearCache();
}

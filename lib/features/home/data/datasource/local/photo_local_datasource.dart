import 'package:shping_test/features/home/data/entities/photo.dart';

abstract class PhotoLocalDataSource {
  Future<List<Photo>> getPhotos(String sourceKey);
  Future<void> cachePhotos(String sourceKey, List<Photo> photos,
      {required int page});

  Future<List<Photo>> getSearchResults(String sourceKey, String query);
  Future<void> cacheSearchResults(
      String sourceKey, String query, List<Photo> photos,
      {required int page});

  Future<Photo?> getPhotoDetails(String sourceKey, String id);
  Future<void> cachePhotoDetails(String sourceKey, Photo photo);

  Future<void> clearCache();
}

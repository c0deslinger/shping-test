import 'package:shping_test/features/home/data/entities/photo.dart';

/// Defines API operations for fetching photo data from remote sources.
/// Provides methods for retrieving paginated photo lists and photo details.
abstract class PhotoApiDataSource {
  Future<List<Photo>> getPhotos({int page = 1, int perPage = 20});
  Future<List<Photo>> searchPhotos(String query,
      {int page = 1, int perPage = 20});
  Future<Photo> getPhotoDetails(String id);
}

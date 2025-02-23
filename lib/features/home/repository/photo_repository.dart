import '../data/entities/photo.dart';

/// Defines contract for photo-related operations
abstract class PhotoRepository {
  /// Retrieves a list of photos with optional pagination
  Future<List<Photo>> getPhotos({int page = 1, int perPage = 20});

  /// Searches photos based on a query with optional pagination
  Future<List<Photo>> searchPhotos(String query,
      {int page = 1, int perPage = 20});

  /// Fetches details of a specific photo by its ID
  Future<Photo> getPhotoDetails(String id);
}

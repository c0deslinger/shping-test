import 'package:shping_test/features/home/data/entities/photo.dart';

abstract class PhotoApiDataSource {
  Future<List<Photo>> getPhotos({int page = 1, int perPage = 20});
  Future<List<Photo>> searchPhotos(String query,
      {int page = 1, int perPage = 20});
  Future<Photo> getPhotoDetails(String id);
}

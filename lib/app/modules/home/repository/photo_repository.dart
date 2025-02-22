import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shping_test/app/global/services/cache_service.dart';
import 'package:shping_test/utils/config_reader.dart';
import '../models/photo.dart';

abstract class PhotoRepository {
  Future<List<Photo>> getPhotos({int page = 1, int perPage = 20});
  Future<List<Photo>> searchPhotos(String query,
      {int page = 1, int perPage = 20});
  Future<Photo> getPhotoDetails(String id);
}

class UnsplashPhotoRepository implements PhotoRepository {
  final String _baseUrl = ConfigReader.getApiUrl();
  final String _accessKey = ConfigReader.getApiKey();
  final CacheService _cacheService;

  UnsplashPhotoRepository(this._cacheService);

  @override
  Future<List<Photo>> getPhotos({int page = 1, int perPage = 20}) async {
    try {
      // Check connectivity
      final isConnected = await _cacheService.isConnected();

      if (!isConnected) {
        // If offline, return cached data
        final cachedPhotos = await _cacheService.getCachedPhotos();
        if (cachedPhotos.isNotEmpty) {
          return cachedPhotos;
        }
        throw Exception('No internet connection and no cached data available');
      }

      // If online, fetch from API
      final response = await http.get(
        Uri.parse('$_baseUrl/photos?page=$page&per_page=$perPage'),
        headers: {'Authorization': 'Client-ID $_accessKey'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final photos = data.map((json) => Photo.fromJson(json)).toList();

        // Cache the results
        await _cacheService.cachePhotos(photos, page: page);

        return photos;
      } else {
        // If API call fails, try to return cached data
        final cachedPhotos = await _cacheService.getCachedPhotos();
        if (cachedPhotos.isNotEmpty) {
          return cachedPhotos;
        }
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      // Try to return cached data on any error
      final cachedPhotos = await _cacheService.getCachedPhotos();
      if (cachedPhotos.isNotEmpty) {
        return cachedPhotos;
      }
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<List<Photo>> searchPhotos(String query,
      {int page = 1, int perPage = 20}) async {
    try {
      // Check connectivity
      final isConnected = await _cacheService.isConnected();

      if (!isConnected) {
        // If offline, return cached data
        final cachedResults = await _cacheService.getCachedSearchResults(query);
        if (cachedResults.isNotEmpty) {
          return cachedResults;
        }
        throw Exception('No internet connection and no cached data available');
      }

      // If online, fetch from API
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/search/photos?query=$query&page=$page&per_page=$perPage'),
        headers: {'Authorization': 'Client-ID $_accessKey'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final photos = results.map((json) => Photo.fromJson(json)).toList();

        // Cache the results
        await _cacheService.cacheSearchResults(query, photos, page: page);

        return photos;
      } else {
        // If API call fails, try to return cached data
        final cachedResults = await _cacheService.getCachedSearchResults(query);
        if (cachedResults.isNotEmpty) {
          return cachedResults;
        }
        throw Exception('Failed to search photos: ${response.statusCode}');
      }
    } catch (e) {
      // Try to return cached data on any error
      final cachedResults = await _cacheService.getCachedSearchResults(query);
      if (cachedResults.isNotEmpty) {
        return cachedResults;
      }
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<Photo> getPhotoDetails(String id) async {
    try {
      // Check connectivity
      final isConnected = await _cacheService.isConnected();

      if (!isConnected) {
        // If offline, return cached data
        final cachedPhoto = await _cacheService.getCachedPhotoDetails(id);
        if (cachedPhoto != null) {
          return cachedPhoto;
        }
        throw Exception('No internet connection and no cached data available');
      }

      // If online, fetch from API
      final response = await http.get(
        Uri.parse('$_baseUrl/photos/$id'),
        headers: {'Authorization': 'Client-ID $_accessKey'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final photo = Photo.fromJson(data);

        // Cache the photo details
        await _cacheService.cachePhotoDetails(photo);

        return photo;
      } else {
        // If API call fails, try to return cached data
        final cachedPhoto = await _cacheService.getCachedPhotoDetails(id);
        if (cachedPhoto != null) {
          return cachedPhoto;
        }
        throw Exception('Failed to load photo details: ${response.statusCode}');
      }
    } catch (e) {
      // Try to return cached data on any error
      final cachedPhoto = await _cacheService.getCachedPhotoDetails(id);
      if (cachedPhoto != null) {
        return cachedPhoto;
      }
      throw Exception('Network error: $e');
    }
  }
}

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../modules/home/models/photo.dart';

class CacheService {
  late Box<String> _photosBox;
  final String _mainPhotosKey = 'main_photos';
  final String _searchResultsPrefix = 'search_';
  final String _photoDetailsPrefix = 'photo_';

  Future<void> init() async {
    await Hive.initFlutter();
    _photosBox = await Hive.openBox<String>('photos_cache');
  }

  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Cache main photos list
  Future<void> cachePhotos(List<Photo> photos, {int page = 1}) async {
    if (page == 1) {
      // Replace cache for first page
      await _photosBox.put(_mainPhotosKey,
          jsonEncode(photos.map((photo) => photo.toJson()).toList()));
    } else {
      // Append to cache for pagination
      final existingDataStr = _photosBox.get(_mainPhotosKey);
      if (existingDataStr != null) {
        final existingData = jsonDecode(existingDataStr) as List;
        final existingPhotos = existingData
            .map((item) => Photo.fromJson(item as Map<String, dynamic>))
            .toList();

        final List<Photo> mergedList = [...existingPhotos, ...photos];
        await _photosBox.put(_mainPhotosKey,
            jsonEncode(mergedList.map((photo) => photo.toJson()).toList()));
      } else {
        await _photosBox.put(_mainPhotosKey,
            jsonEncode(photos.map((photo) => photo.toJson()).toList()));
      }
    }
  }

  // Get cached main photos
  Future<List<Photo>> getCachedPhotos() async {
    final cachedData = _photosBox.get(_mainPhotosKey);
    if (cachedData != null) {
      final List<dynamic> decodedData = jsonDecode(cachedData);
      return decodedData
          .map((item) => Photo.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // Cache search results
  Future<void> cacheSearchResults(String query, List<Photo> photos,
      {int page = 1}) async {
    final key = '$_searchResultsPrefix$query';
    if (page == 1) {
      // Replace cache for first page
      await _photosBox.put(
          key, jsonEncode(photos.map((photo) => photo.toJson()).toList()));
    } else {
      // Append to cache for pagination
      final existingDataStr = _photosBox.get(key);
      if (existingDataStr != null) {
        final existingData = jsonDecode(existingDataStr) as List;
        final existingPhotos = existingData
            .map((item) => Photo.fromJson(item as Map<String, dynamic>))
            .toList();

        final List<Photo> mergedList = [...existingPhotos, ...photos];
        await _photosBox.put(key,
            jsonEncode(mergedList.map((photo) => photo.toJson()).toList()));
      } else {
        await _photosBox.put(
            key, jsonEncode(photos.map((photo) => photo.toJson()).toList()));
      }
    }
  }

  // Get cached search results
  Future<List<Photo>> getCachedSearchResults(String query) async {
    final key = '$_searchResultsPrefix$query';
    final cachedData = _photosBox.get(key);
    if (cachedData != null) {
      final List<dynamic> decodedData = jsonDecode(cachedData);
      return decodedData
          .map((item) => Photo.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // Cache photo details
  Future<void> cachePhotoDetails(Photo photo) async {
    final key = '$_photoDetailsPrefix${photo.id}';
    await _photosBox.put(key, jsonEncode(photo.toJson()));
  }

  // Get cached photo details
  Future<Photo?> getCachedPhotoDetails(String id) async {
    final key = '$_photoDetailsPrefix$id';
    final cachedData = _photosBox.get(key);
    if (cachedData != null) {
      final Map<String, dynamic> decodedData = jsonDecode(cachedData);
      return Photo.fromJson(decodedData);
    }
    return null;
  }

  // Clear all cache
  Future<void> clearCache() async {
    await _photosBox.clear();
  }
}

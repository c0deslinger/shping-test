import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shping_test/features/home/data/datasource/local/photo_local_datasource.dart';
import 'package:shping_test/features/home/data/entities/photo.dart';

class HiveLocalDataSource implements PhotoLocalDataSource {
  late Box<String> _photosBox;

  HiveLocalDataSource() {
    _initBox();
  }

  Future<void> _initBox() async {
    _photosBox = await Hive.openBox<String>('photos_cache');
  }

  @override
  Future<List<Photo>> getPhotos(String sourceKey) async {
    final key = '${sourceKey}_main_photos'; // contoh penamaan
    try {
      final cachedData = _photosBox.get(key);
      if (cachedData != null) {
        final List<dynamic> decodedData = jsonDecode(cachedData);
        return decodedData
            .map((item) => Photo.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting cached photos: $e');
      return [];
    }
  }

  @override
  Future<void> cachePhotos(
    String sourceKey,
    List<Photo> photos, {
    required int page,
  }) async {
    final key = '${sourceKey}_main_photos';
    try {
      if (page == 1) {
        // Replace cache untuk page pertama
        await _photosBox.put(
          key,
          jsonEncode(photos.map((photo) => photo.toJson()).toList()),
        );
      } else {
        // Append cache untuk pagination
        final existingDataStr = _photosBox.get(key);
        if (existingDataStr != null) {
          final existingData = jsonDecode(existingDataStr) as List;
          final existingPhotos = existingData
              .map((item) => Photo.fromJson(item as Map<String, dynamic>))
              .toList();

          final mergedList = [...existingPhotos, ...photos];
          await _photosBox.put(
            key,
            jsonEncode(mergedList.map((photo) => photo.toJson()).toList()),
          );
        } else {
          await _photosBox.put(
            key,
            jsonEncode(photos.map((photo) => photo.toJson()).toList()),
          );
        }
      }
    } catch (e) {
      print('Error caching photos: $e');
    }
  }

  @override
  Future<List<Photo>> getSearchResults(String sourceKey, String query) async {
    final key = '${sourceKey}_search_$query';
    try {
      final cachedData = _photosBox.get(key);
      if (cachedData != null) {
        final List<dynamic> decodedData = jsonDecode(cachedData);
        return decodedData
            .map((item) => Photo.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting cached search results: $e');
      return [];
    }
  }

  @override
  Future<void> cacheSearchResults(
    String sourceKey,
    String query,
    List<Photo> photos, {
    required int page,
  }) async {
    final key = '${sourceKey}_search_$query';
    try {
      if (page == 1) {
        // Replace cache untuk page pertama
        await _photosBox.put(
          key,
          jsonEncode(photos.map((photo) => photo.toJson()).toList()),
        );
      } else {
        // Append cache untuk pagination
        final existingDataStr = _photosBox.get(key);
        if (existingDataStr != null) {
          final existingData = jsonDecode(existingDataStr) as List;
          final existingPhotos = existingData
              .map((item) => Photo.fromJson(item as Map<String, dynamic>))
              .toList();

          final mergedList = [...existingPhotos, ...photos];
          await _photosBox.put(
            key,
            jsonEncode(mergedList.map((photo) => photo.toJson()).toList()),
          );
        } else {
          await _photosBox.put(
            key,
            jsonEncode(photos.map((photo) => photo.toJson()).toList()),
          );
        }
      }
    } catch (e) {
      print('Error caching search results: $e');
    }
  }

  @override
  Future<Photo?> getPhotoDetails(String sourceKey, String id) async {
    final key = '${sourceKey}_photo_$id';
    try {
      final cachedData = _photosBox.get(key);
      if (cachedData != null) {
        final Map<String, dynamic> decodedData = jsonDecode(cachedData);
        return Photo.fromJson(decodedData);
      }
      return null;
    } catch (e) {
      print('Error getting cached photo details: $e');
      return null;
    }
  }

  @override
  Future<void> cachePhotoDetails(String sourceKey, Photo photo) async {
    final key = '${sourceKey}_photo_${photo.id}';
    try {
      await _photosBox.put(key, jsonEncode(photo.toJson()));
    } catch (e) {
      print('Error caching photo details: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _photosBox.clear();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}

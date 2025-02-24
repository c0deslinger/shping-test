import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shping_test/utils/logger.dart';
import 'package:shping_test/features/home/data/datasource/local/photo_local_datasource.dart';
import 'package:shping_test/features/home/data/entities/photo.dart';

class HiveLocalDataSource implements PhotoLocalDataSource {
  late Box<String> _photosBox;

  HiveLocalDataSource() {
    _initBox();
  }

  Future<void> _initBox() async {
    _photosBox = await Hive.openBox<String>('photos_cache');
    LoggerUtil.i('[HiveDataSource] Initialized photos cache box');
  }

  @override
  Future<List<Photo>> getPhotos(String sourceKey) async {
    final key = '${sourceKey}_main_photos';
    try {
      final cachedData = _photosBox.get(key);
      if (cachedData != null) {
        final List<dynamic> decodedData = jsonDecode(cachedData);
        final photos = decodedData
            .map((item) => Photo.fromJson(item as Map<String, dynamic>))
            .toList();
        LoggerUtil.d(
            '[HiveDataSource] Retrieved ${photos.length} cached photos for $sourceKey');
        return photos;
      }
      LoggerUtil.w('[HiveDataSource] No cached photos found for $sourceKey');
      return [];
    } catch (e, stackTrace) {
      LoggerUtil.e(
          '[HiveDataSource] Error getting cached photos for $sourceKey',
          e,
          stackTrace);
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
        await _photosBox.put(
          key,
          jsonEncode(photos.map((photo) => photo.toJson()).toList()),
        );
        LoggerUtil.i(
            '[HiveDataSource] Cached ${photos.length} new photos for $sourceKey');
      } else {
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
          LoggerUtil.i(
              '[HiveDataSource] Appended ${photos.length} photos to cache for $sourceKey. Total: ${mergedList.length}');
        } else {
          await _photosBox.put(
            key,
            jsonEncode(photos.map((photo) => photo.toJson()).toList()),
          );
          LoggerUtil.i(
              '[HiveDataSource] Created new cache with ${photos.length} photos for $sourceKey');
        }
      }
    } catch (e, stackTrace) {
      LoggerUtil.e('[HiveDataSource] Error caching photos for $sourceKey', e,
          stackTrace);
    }
  }

  @override
  Future<List<Photo>> getSearchResults(String sourceKey, String query) async {
    final key = '${sourceKey}_search_$query';
    try {
      final cachedData = _photosBox.get(key);
      if (cachedData != null) {
        final List<dynamic> decodedData = jsonDecode(cachedData);
        final photos = decodedData
            .map((item) => Photo.fromJson(item as Map<String, dynamic>))
            .toList();
        LoggerUtil.d(
            '[HiveDataSource] Retrieved ${photos.length} cached search results for query: $query');
        return photos;
      }
      LoggerUtil.w(
          '[HiveDataSource] No cached search results found for query: $query');
      return [];
    } catch (e, stackTrace) {
      LoggerUtil.e(
          '[HiveDataSource] Error getting cached search results for query: $query',
          e,
          stackTrace);
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
        await _photosBox.put(
          key,
          jsonEncode(photos.map((photo) => photo.toJson()).toList()),
        );
        LoggerUtil.i(
            '[HiveDataSource] Cached ${photos.length} new search results for query: $query');
      } else {
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
          LoggerUtil.i(
              '[HiveDataSource] Appended ${photos.length} search results to cache for query: $query. Total: ${mergedList.length}');
        } else {
          await _photosBox.put(
            key,
            jsonEncode(photos.map((photo) => photo.toJson()).toList()),
          );
          LoggerUtil.i(
              '[HiveDataSource] Created new cache with ${photos.length} search results for query: $query');
        }
      }
    } catch (e, stackTrace) {
      LoggerUtil.e(
          '[HiveDataSource] Error caching search results for query: $query',
          e,
          stackTrace);
    }
  }

  @override
  Future<Photo?> getPhotoDetails(String sourceKey, String id) async {
    final key = '${sourceKey}_photo_$id';
    try {
      final cachedData = _photosBox.get(key);
      if (cachedData != null) {
        final Map<String, dynamic> decodedData = jsonDecode(cachedData);
        final photo = Photo.fromJson(decodedData);
        LoggerUtil.d(
            '[HiveDataSource] Retrieved cached photo details for ID: $id');
        return photo;
      }
      LoggerUtil.w(
          '[HiveDataSource] No cached photo details found for ID: $id');
      return null;
    } catch (e, stackTrace) {
      LoggerUtil.e(
          '[HiveDataSource] Error getting cached photo details for ID: $id',
          e,
          stackTrace);
      return null;
    }
  }

  @override
  Future<void> cachePhotoDetails(String sourceKey, Photo photo) async {
    final key = '${sourceKey}_photo_${photo.id}';
    try {
      await _photosBox.put(key, jsonEncode(photo.toJson()));
      LoggerUtil.i('[HiveDataSource] Cached photo details for ID: ${photo.id}');
    } catch (e, stackTrace) {
      LoggerUtil.e(
          '[HiveDataSource] Error caching photo details for ID: ${photo.id}',
          e,
          stackTrace);
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _photosBox.clear();
      LoggerUtil.i('[HiveDataSource] Cache cleared successfully');
    } catch (e, stackTrace) {
      LoggerUtil.e('[HiveDataSource] Error clearing cache', e, stackTrace);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:shping_test/features/home/data/datasource/local/photo_local_datasource.dart';
import 'package:shping_test/features/home/data/datasource/remote/photo_api_datasource.dart';
import 'package:shping_test/core/services/connectivity_service.dart';
import 'package:shping_test/features/home/data/datasource/remote/unsplash_api_datasource.dart';
import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:shping_test/features/settings/providers/settings_provider.dart';
import 'photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoApiDataSource _apiDataSource;
  final PhotoLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;
  late ImageSource _sourceKey;

  /// Constructor initializes data sources and determines image source key
  PhotoRepositoryImpl({
    required PhotoApiDataSource apiDataSource,
    required PhotoLocalDataSource localDataSource,
    required ConnectivityService connectivityService,
  })  : _apiDataSource = apiDataSource,
        _localDataSource = localDataSource,
        _connectivityService = connectivityService {
    _sourceKey = _apiDataSource is UnsplashApiDataSource
        ? ImageSource.unsplash
        : ImageSource.pixabay;
  }

  /// Retrieves photos with fallback to local cache and supports pagination
  @override
  Future<List<Photo>> getPhotos({int page = 1, int perPage = 20}) async {
    return _getFromApiWithFallback(
      apiCall: () => _apiDataSource.getPhotos(page: page, perPage: perPage),
      localCall: () => _localDataSource.getPhotos(_sourceKey),
      cacheCall: (photos) =>
          _localDataSource.cachePhotos(_sourceKey, photos, page: page),
    );
  }

  /// Searches photos with fallback to local cache and supports pagination
  @override
  Future<List<Photo>> searchPhotos(
    String query, {
    int page = 1,
    int perPage = 20,
  }) async {
    return _getFromApiWithFallback(
      apiCall: () =>
          _apiDataSource.searchPhotos(query, page: page, perPage: perPage),
      localCall: () => _localDataSource.getSearchResults(_sourceKey, query),
      cacheCall: (photos) => _localDataSource.cacheSearchResults(
        _sourceKey,
        query,
        photos,
        page: page,
      ),
    );
  }

  /// Retrieves photo details with fallback to cached data
  @override
  Future<Photo> getPhotoDetails(String id) async {
    try {
      final isConnected = await _connectivityService.checkCurrentConnectivity();
      if (isConnected) {
        final photo = await _apiDataSource.getPhotoDetails(id);
        await _localDataSource.cachePhotoDetails(_sourceKey, photo);
        return photo;
      }
      final cachedPhoto =
          await _localDataSource.getPhotoDetails(_sourceKey, id);
      if (cachedPhoto != null) return cachedPhoto;
      throw Exception('No internet connection and no cached data available');
    } catch (e) {
      final cachedPhoto =
          await _localDataSource.getPhotoDetails(_sourceKey, id);
      if (cachedPhoto != null) return cachedPhoto;
      rethrow;
    }
  }

  /// Helper method to handle API calls with local cache fallback
  Future<List<Photo>> _getFromApiWithFallback({
    required Future<List<Photo>> Function() apiCall,
    required Future<List<Photo>> Function() localCall,
    required Future<void> Function(List<Photo>) cacheCall,
  }) async {
    try {
      final isConnected = await _connectivityService.checkCurrentConnectivity();
      if (isConnected) {
        final photos = await apiCall();
        await cacheCall(photos);
        return photos;
      }
      return await localCall();
    } catch (e) {
      debugPrint('Repository error: $e');
      final cachedPhotos = await localCall();
      if (cachedPhotos.isNotEmpty) {
        return cachedPhotos;
      }
      rethrow;
    }
  }
}

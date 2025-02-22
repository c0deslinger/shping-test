import 'package:flutter/foundation.dart';
import 'package:shping_test/app/global/services/connectivity_service.dart';
import '../models/photo.dart';
import '../repository/photo_repository.dart';

enum LoadingStatus { initial, loading, loaded, error }

class PhotoProvider with ChangeNotifier {
  final PhotoRepository _repository;

  List<Photo> _photos = [];
  List<Photo> _searchResults = [];
  LoadingStatus _status = LoadingStatus.initial;
  String _errorMessage = '';
  int _currentPage = 1;
  String _currentQuery = '';
  bool _hasMore = true;
  bool _isOffline = false;

  PhotoProvider(this._repository) {
    _checkConnectivity();
    _setupConnectivityListener();
  }

  List<Photo> get photos => _currentQuery.isEmpty ? _photos : _searchResults;
  LoadingStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isOffline => _isOffline;
  String get currentQuery => _currentQuery;

  void _setupConnectivityListener() {
    ConnectivityService().connectivityStream.listen((isConnected) {
      _isOffline = !isConnected;
      notifyListeners();

      // If we're back online and had no data, try to fetch
      if (isConnected && _photos.isEmpty && _status != LoadingStatus.loading) {
        fetchPhotos(refresh: true);
      }
    });
  }

  Future<void> _checkConnectivity() async {
    _isOffline = !(await ConnectivityService().isConnected());
    notifyListeners();
  }

  void loadMorePhotos() {
    if (_currentQuery.isEmpty) {
      fetchPhotos();
    } else {
      searchPhotos(_currentQuery);
    }
  }

  Future<void> refreshPhotos() async {
    if (_currentQuery.isEmpty) {
      await fetchPhotos(refresh: true);
    } else {
      await searchPhotos(_currentQuery, refresh: true);
    }
  }

  Future<void> fetchPhotos({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _photos = [];
      _hasMore = true;
    }

    if (!_hasMore || _status == LoadingStatus.loading) return;

    try {
      _status = LoadingStatus.loading;
      notifyListeners();

      final newPhotos = await _repository.getPhotos(page: _currentPage);

      if (newPhotos.isEmpty) {
        _hasMore = false;
      } else {
        _photos.addAll(newPhotos);
        _currentPage++;
      }

      _status = LoadingStatus.loaded;
    } catch (e) {
      _status = LoadingStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> searchPhotos(String query, {bool refresh = false}) async {
    if (query.isEmpty) {
      _currentQuery = '';
      notifyListeners();
      return;
    }

    if (refresh || query != _currentQuery) {
      _currentPage = 1;
      _searchResults = [];
      _hasMore = true;
      _currentQuery = query;
    }

    if (!_hasMore || _status == LoadingStatus.loading) return;

    try {
      _status = LoadingStatus.loading;
      notifyListeners();

      final results = await _repository.searchPhotos(query, page: _currentPage);

      if (results.isEmpty) {
        _hasMore = false;
      } else {
        _searchResults.addAll(results);
        _currentPage++;
      }

      _status = LoadingStatus.loaded;
    } catch (e) {
      _status = LoadingStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<Photo> getPhotoDetails(String id) async {
    try {
      return await _repository.getPhotoDetails(id);
    } catch (e) {
      _errorMessage = e.toString();
      throw Exception(_errorMessage);
    }
  }

  void clearSearch() {
    _currentQuery = '';
    notifyListeners();
  }
}

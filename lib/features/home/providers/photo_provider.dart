import 'package:flutter/foundation.dart';
import 'package:shping_test/features/settings/providers/settings_provider.dart';
import '../data/entities/photo.dart';
import '../repository/photo_repository.dart';

/// Manages photos and search logic, including pagination,
/// online/offline states, and switching image sources.
enum LoadingStatus { initial, loading, loaded, error }

class PhotoProvider with ChangeNotifier {
  final PhotoRepository _unsplashRepository;
  final PhotoRepository _pixabayRepository;
  final SettingsProvider _settingsProvider;

  List<Photo> _photos = [];
  List<Photo> _searchResults = [];
  Photo? detailedPhoto;

  LoadingStatus _status = LoadingStatus.initial;
  bool _isLoadMore = false;
  String _errorMessage = '';
  int _currentPage = 1;
  String _currentQuery = '';
  bool _hasMore = true;

  PhotoProvider(
    this._unsplashRepository,
    this._pixabayRepository,
    this._settingsProvider,
  ) {
    _setupImageSourceListener();
  }

  /// Chooses the active repository based on the selected image source.
  PhotoRepository get _currentRepository =>
      _settingsProvider.imageSource == ImageSource.unsplash
          ? _unsplashRepository
          : _pixabayRepository;

  /// Returns photos for display (search results if a query is set).
  List<Photo> get photos => _currentQuery.isEmpty ? _photos : _searchResults;

  LoadingStatus get status => _status;
  bool get isLoadMore => _isLoadMore;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  String get currentQuery => _currentQuery;

  /// Called when the image source changes.
  void _setupImageSourceListener() {
    _settingsProvider.onImageSourceChanged = () {
      _currentPage = 1;
      _photos.clear();
      _searchResults.clear();
      _hasMore = true;

      if (_currentQuery.isNotEmpty) {
        searchPhotos(_currentQuery, refresh: true);
      } else {
        fetchPhotos(refresh: true);
      }
    };
  }

  /// Loads the next page of results or search results.
  void loadMorePhotos() {
    if (_currentQuery.isEmpty) {
      fetchPhotos();
    } else {
      searchPhotos(_currentQuery);
    }
  }

  /// Refreshes all data or search results from page 1.
  Future<void> refreshPhotos() async {
    if (_currentQuery.isEmpty) {
      await fetchPhotos(refresh: true);
    } else {
      await searchPhotos(_currentQuery, refresh: true);
    }
  }

  /// Fetches photos with optional refresh. Handles pagination as well.
  Future<void> fetchPhotos({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _photos = [];
      _hasMore = true;
      _status = LoadingStatus.loading;
      notifyListeners();
    } else if (_photos.isEmpty && _status != LoadingStatus.loading) {
      _status = LoadingStatus.loading;
      notifyListeners();
    } else {
      _isLoadMore = true;
      notifyListeners();
    }

    if (!_hasMore) return;

    try {
      final newPhotos = await _currentRepository.getPhotos(page: _currentPage);

      if (newPhotos.isEmpty) {
        _hasMore = false;
      } else {
        _photos.addAll(newPhotos);
        _currentPage++;
      }

      if (_status == LoadingStatus.loading) {
        _status = LoadingStatus.loaded;
      }
      _isLoadMore = false;
    } catch (e) {
      _status = LoadingStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Searches photos by [query], with optional refresh or pagination.
  Future<void> searchPhotos(String query, {bool refresh = false}) async {
    if (query.isEmpty) {
      _currentQuery = '';
      _searchResults = [];
      notifyListeners();
      return;
    }

    if (refresh || query != _currentQuery) {
      _currentPage = 1;
      _searchResults = [];
      _hasMore = true;
      _currentQuery = query;
      _status = LoadingStatus.loading;
      notifyListeners();
    } else if (_searchResults.isNotEmpty && !_isLoadMore) {
      _isLoadMore = true;
      notifyListeners();
    }

    if (!_hasMore) return;

    try {
      final results = await _currentRepository.searchPhotos(
        query,
        page: _currentPage,
      );

      if (results.isEmpty) {
        _hasMore = false;
      } else {
        _searchResults.addAll(results);
        _currentPage++;
      }

      if (_status == LoadingStatus.loading) {
        _status = LoadingStatus.loaded;
      }
      _isLoadMore = false;
    } catch (e) {
      _status = LoadingStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Fetches details of a single photo by [id].
  Future<void> getPhotoDetails(String id) async {
    _status = LoadingStatus.loading;
    notifyListeners();
    try {
      detailedPhoto = null;
      detailedPhoto = await _currentRepository.getPhotoDetails(id);
    } catch (e) {
      _errorMessage = e.toString();
      _status = LoadingStatus.error;
    } finally {
      _status = LoadingStatus.loaded;
      notifyListeners();
    }
  }

  /// Clears the search query.
  void clearSearch() {
    _currentQuery = '';
    notifyListeners();
  }
}

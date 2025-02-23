// lib/app/modules/home/data/datasource/remote/unsplash_api_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shping_test/features/home/data/datasource/remote/photo_api_datasource.dart';
import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:shping_test/features/home/data/models/unsplash/unsplash_list_photo_response.dart';
import 'package:shping_test/features/home/data/models/unsplash/unsplash_photo_detail_response.dart';
import 'package:shping_test/core/utils/config_reader.dart';
import 'package:shping_test/core/utils/logger.dart';

class UnsplashApiDataSource implements PhotoApiDataSource {
  final String _baseUrl = ConfigReader.getUnsplashApiUrl();
  final String _accessKey = ConfigReader.getUnsplashApiKey();

  @override
  Future<List<Photo>> getPhotos({int page = 1, int perPage = 20}) async {
    const methodName = 'getPhotos';
    final stopwatch = Stopwatch()..start();

    try {
      final url = Uri.parse('$_baseUrl/photos?page=$page&per_page=$perPage');
      LoggerUtil.i(
          '[$methodName] Making request to: ${url.toString().replaceAll(_accessKey, 'API_KEY')}');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Client-ID $_accessKey'},
      );

      stopwatch.stop();
      LoggerUtil.d(
          '[$methodName] Response received in ${stopwatch.elapsedMilliseconds}ms');
      LoggerUtil.d('[$methodName] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final photos = jsonData
            .map((json) => UnsplashListPhotoResponse.fromJson(json).toPhoto())
            .toList();

        LoggerUtil.i(
            '[$methodName] Successfully retrieved ${photos.length} photos');
        return photos;
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      LoggerUtil.e('[$methodName] Error occurred', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<Photo>> searchPhotos(String query,
      {int page = 1, int perPage = 20}) async {
    const methodName = 'searchPhotos';
    final stopwatch = Stopwatch()..start();

    try {
      final url = Uri.parse(
          '$_baseUrl/search/photos?query=$query&page=$page&per_page=$perPage');
      LoggerUtil.i(
          '[$methodName] Making request to: ${url.toString().replaceAll(_accessKey, 'API_KEY')}');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Client-ID $_accessKey'},
      );

      stopwatch.stop();
      LoggerUtil.d(
          '[$methodName] Response received in ${stopwatch.elapsedMilliseconds}ms');
      LoggerUtil.d('[$methodName] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final photos = results
            .map((json) => UnsplashListPhotoResponse.fromJson(json).toPhoto())
            .toList();

        LoggerUtil.i(
            '[$methodName] Successfully retrieved ${photos.length} photos');
        return photos;
      } else {
        throw Exception('Failed to search photos: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      LoggerUtil.e('[$methodName] Error occurred', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Photo> getPhotoDetails(String id) async {
    const methodName = 'getPhotoDetails';
    final stopwatch = Stopwatch()..start();

    try {
      final url = Uri.parse('$_baseUrl/photos/$id');
      LoggerUtil.i(
          '[$methodName] Making request to: ${url.toString().replaceAll(_accessKey, 'API_KEY')}');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Client-ID $_accessKey'},
      );

      stopwatch.stop();
      LoggerUtil.d(
          '[$methodName] Response received in ${stopwatch.elapsedMilliseconds}ms');
      LoggerUtil.d('[$methodName] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final photoResponse =
            UnsplashPhotoDetailResponse.fromJson(json.decode(response.body));
        return photoResponse.toPhoto();
      } else {
        throw Exception('Failed to load photo details: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      LoggerUtil.e('[$methodName] Error occurred', e, stackTrace);
      rethrow;
    }
  }
}

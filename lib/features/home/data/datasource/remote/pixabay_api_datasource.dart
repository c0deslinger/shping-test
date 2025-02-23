// lib/app/modules/home/data/datasource/remote/pixabay_api_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shping_test/features/home/data/datasource/remote/photo_api_datasource.dart';
import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:shping_test/features/home/data/models/pixabay/pixabay_list_photo_response.dart';
import 'package:shping_test/features/home/data/models/pixabay/pixabay_photo_detail_response.dart';
import 'package:shping_test/core/utils/config_reader.dart';
import 'package:shping_test/core/utils/logger.dart';

class PixabayApiDataSource implements PhotoApiDataSource {
  final String _baseUrl = ConfigReader.getPixabayApiUrl();
  final String _apiKey = ConfigReader.getPixabayApiKey();

  @override
  Future<List<Photo>> getPhotos({int page = 1, int perPage = 20}) async {
    const methodName = 'getPhotos';
    final stopwatch = Stopwatch()..start();

    try {
      final url = Uri.parse(
          '$_baseUrl?key=$_apiKey&page=$page&per_page=$perPage&image_type=photo');
      LoggerUtil.i(
          '[$methodName] Making request to: ${url.toString().replaceAll(_apiKey, 'API_KEY')}');

      final response = await http.get(url);

      stopwatch.stop();
      LoggerUtil.d(
          '[$methodName] Response received in ${stopwatch.elapsedMilliseconds}ms');
      LoggerUtil.d('[$methodName] Status code: ${response.statusCode}');
      LoggerUtil.d('[$methodName] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final pixabayResponse =
            PixabayListPhotoResponse.fromJson(json.decode(response.body));
        final photos =
            pixabayResponse.hits?.map((hit) => hit.toPhoto()).toList() ?? [];

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
          '$_baseUrl?key=$_apiKey&q=${Uri.encodeComponent(query)}&page=$page&per_page=$perPage&image_type=photo');
      LoggerUtil.i(
          '[$methodName] Making request to: ${url.toString().replaceAll(_apiKey, 'API_KEY')}');

      final response = await http.get(url);

      stopwatch.stop();
      LoggerUtil.d(
          '[$methodName] Response received in ${stopwatch.elapsedMilliseconds}ms');
      LoggerUtil.d('[$methodName] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final pixabayResponse =
            PixabayListPhotoResponse.fromJson(json.decode(response.body));
        final photos =
            pixabayResponse.hits?.map((hit) => hit.toPhoto()).toList() ?? [];

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
      final url = Uri.parse('$_baseUrl?key=$_apiKey&id=$id');
      LoggerUtil.i(
          '[$methodName] Making request to: ${url.toString().replaceAll(_apiKey, 'API_KEY')}');

      final response = await http.get(url);

      stopwatch.stop();
      LoggerUtil.d(
          '[$methodName] Response received in ${stopwatch.elapsedMilliseconds}ms');
      LoggerUtil.d('[$methodName] Status code: ${response.statusCode}');
      LoggerUtil.d('[$methodName] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final pixabayResponse =
            PixabayPhotoDetailResponse.fromJson(json.decode(response.body));
        if (pixabayResponse.hits?.isEmpty ?? true) {
          throw Exception('Photo not found');
        }
        return pixabayResponse.hits!.first.toPhoto();
      } else {
        throw Exception('Failed to load photo details: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      LoggerUtil.e('[$methodName] Error occurred', e, stackTrace);
      rethrow;
    }
  }
}

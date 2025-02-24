import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shping_test/core/services/connectivity_service.dart';
import 'package:shping_test/features/home/data/datasource/local/photo_local_datasource.dart';
import 'package:shping_test/features/home/data/datasource/remote/photo_api_datasource.dart';
import 'package:shping_test/features/home/data/datasource/remote/unsplash_api_datasource.dart';
import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:shping_test/features/home/repository/photo_repository_impl.dart';
import 'package:shping_test/features/settings/providers/settings_provider.dart';

import 'photo_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PhotoApiDataSource>(),
  MockSpec<UnsplashApiDataSource>(),
  MockSpec<PhotoLocalDataSource>(),
  MockSpec<ConnectivityService>(),
])
void main() {
  late PhotoRepositoryImpl repository;
  late MockPhotoApiDataSource mockApiDataSource;
  late MockPhotoLocalDataSource mockLocalDataSource;
  late MockConnectivityService mockConnectivityService;

  // Test data
  final testDateTime = DateTime(2024, 1, 1);

  final testPhotos = [
    Photo(
      id: '1',
      url: 'https://example.com/photo1.jpg',
      smallUrl: 'https://example.com/photo1_small.jpg',
      photoProfile: 'https://example.com/photo2_small.jpg',
      title: 'Test Photo 1',
      photographer: 'John Doe',
      createdAt: testDateTime,
    ),
    Photo(
      id: '2',
      url: 'https://example.com/photo2.jpg',
      smallUrl: 'https://example.com/photo2_small.jpg',
      photoProfile: 'https://example.com/photo2_small.jpg',
      title: 'Test Photo 2',
      photographer: 'Jane Smith',
      createdAt: testDateTime,
    ),
  ];

  setUp(() {
    mockApiDataSource = MockPhotoApiDataSource();
    mockLocalDataSource = MockPhotoLocalDataSource();
    mockConnectivityService = MockConnectivityService();
  });

  group('PhotoRepositoryImpl', () {
    group('getPhotos', () {
      setUp(() {
        repository = PhotoRepositoryImpl(
          apiDataSource: mockApiDataSource,
          localDataSource: mockLocalDataSource,
          connectivityService: mockConnectivityService,
        );
      });

      test('should return photos from API when online', () async {
        // Arrange
        when(mockConnectivityService.checkCurrentConnectivity())
            .thenAnswer((_) async => true);
        when(mockApiDataSource.getPhotos(page: 1, perPage: 20))
            .thenAnswer((_) async => testPhotos);
        when(mockLocalDataSource.cachePhotos(ImageSource.pixabay, testPhotos,
                page: 1))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.getPhotos();

        // Assert
        expect(result, equals(testPhotos));
        verify(mockConnectivityService.checkCurrentConnectivity()).called(1);
        verify(mockApiDataSource.getPhotos(page: 1, perPage: 20)).called(1);
        verify(mockLocalDataSource.cachePhotos(ImageSource.pixabay, testPhotos,
                page: 1))
            .called(1);
      });

      test('should return cached photos when offline', () async {
        // Arrange
        when(mockConnectivityService.checkCurrentConnectivity())
            .thenAnswer((_) async => false);
        when(mockLocalDataSource.getPhotos(ImageSource.pixabay))
            .thenAnswer((_) async => testPhotos);

        // Act
        final result = await repository.getPhotos();

        // Assert
        expect(result, equals(testPhotos));
        verify(mockConnectivityService.checkCurrentConnectivity()).called(1);
        verify(mockLocalDataSource.getPhotos(ImageSource.pixabay)).called(1);
        verifyNever(mockApiDataSource.getPhotos());
      });

      test('should return cached photos when API fails', () async {
        // Arrange
        when(mockConnectivityService.checkCurrentConnectivity())
            .thenAnswer((_) async => true);
        when(mockApiDataSource.getPhotos(page: 1, perPage: 20))
            .thenThrow(Exception('API Error'));
        when(mockLocalDataSource.getPhotos(ImageSource.pixabay))
            .thenAnswer((_) async => testPhotos);

        // Act
        final result = await repository.getPhotos();

        // Assert
        expect(result, equals(testPhotos));
        verify(mockApiDataSource.getPhotos(page: 1, perPage: 20)).called(1);
        verify(mockLocalDataSource.getPhotos(ImageSource.pixabay)).called(1);
      });

      test('should throw exception when both API and cache fail', () async {
        // Arrange
        when(mockConnectivityService.checkCurrentConnectivity())
            .thenAnswer((_) async => true);
        when(mockApiDataSource.getPhotos(page: 1, perPage: 20))
            .thenThrow(Exception('API Error'));
        when(mockLocalDataSource.getPhotos(ImageSource.pixabay))
            .thenAnswer((_) async => []);

        // Act & Assert
        expect(() => repository.getPhotos(), throwsException);
      });
    });

    group('searchPhotos', () {
      const testQuery = 'nature';

      setUp(() {
        repository = PhotoRepositoryImpl(
          apiDataSource: mockApiDataSource,
          localDataSource: mockLocalDataSource,
          connectivityService: mockConnectivityService,
        );
      });

      test('should return search results from API when online', () async {
        // Arrange
        when(mockConnectivityService.checkCurrentConnectivity())
            .thenAnswer((_) async => true);
        when(mockApiDataSource.searchPhotos(testQuery, page: 1, perPage: 20))
            .thenAnswer((_) async => testPhotos);
        when(mockLocalDataSource.cacheSearchResults(
          ImageSource.pixabay,
          testQuery,
          testPhotos,
          page: 1,
        )).thenAnswer((_) async => {});

        // Act
        final result = await repository.searchPhotos(testQuery);

        // Assert
        expect(result, equals(testPhotos));
        verify(mockApiDataSource.searchPhotos(testQuery, page: 1, perPage: 20))
            .called(1);
        verify(mockLocalDataSource.cacheSearchResults(
          ImageSource.pixabay,
          testQuery,
          testPhotos,
          page: 1,
        )).called(1);
      });

      test('should return cached results when offline', () async {
        // Arrange
        when(mockConnectivityService.checkCurrentConnectivity())
            .thenAnswer((_) async => false);
        when(mockLocalDataSource.getSearchResults(
                ImageSource.pixabay, testQuery))
            .thenAnswer((_) async => testPhotos);

        // Act
        final result = await repository.searchPhotos(testQuery);

        // Assert
        expect(result, equals(testPhotos));
        verify(mockLocalDataSource.getSearchResults(
                ImageSource.pixabay, testQuery))
            .called(1);
        verifyNever(mockApiDataSource.searchPhotos(any));
      });
    });

    group('getPhotoDetails', () {
      final testPhoto = Photo(
        id: '1',
        url: 'https://example.com/photo1.jpg',
        smallUrl: 'https://example.com/photo1_small.jpg',
        photoProfile: 'https://example.com/photo2_small.jpg',
        title: 'Test Photo 1',
        photographer: 'John Doe',
        createdAt: testDateTime,
      );

      setUp(() {
        repository = PhotoRepositoryImpl(
          apiDataSource: mockApiDataSource,
          localDataSource: mockLocalDataSource,
          connectivityService: mockConnectivityService,
        );
      });

      test('should return photo details from API when online', () async {
        // Arrange
        when(mockConnectivityService.checkCurrentConnectivity())
            .thenAnswer((_) async => true);
        when(mockApiDataSource.getPhotoDetails('1'))
            .thenAnswer((_) async => testPhoto);
        when(mockLocalDataSource.cachePhotoDetails(
                ImageSource.pixabay, testPhoto))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.getPhotoDetails('1');

        // Assert
        expect(result, equals(testPhoto));
        verify(mockApiDataSource.getPhotoDetails('1')).called(1);
        verify(mockLocalDataSource.cachePhotoDetails(
                ImageSource.pixabay, testPhoto))
            .called(1);
      });

      test('should return cached details when offline', () async {
        // Arrange
        when(mockConnectivityService.checkCurrentConnectivity())
            .thenAnswer((_) async => false);
        when(mockLocalDataSource.getPhotoDetails(ImageSource.pixabay, '1'))
            .thenAnswer((_) async => testPhoto);

        // Act
        final result = await repository.getPhotoDetails('1');

        // Assert
        expect(result, equals(testPhoto));
        verify(mockLocalDataSource.getPhotoDetails(ImageSource.pixabay, '1'))
            .called(1);
        verifyNever(mockApiDataSource.getPhotoDetails(any));
      });
    });
  });
}

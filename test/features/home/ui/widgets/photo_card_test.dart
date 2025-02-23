import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:shping_test/features/home/ui/widgets/photo_card.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  final testPhoto = Photo(
    id: '1',
    url: 'https://example.com/photo.jpg',
    smallUrl: 'https://example.com/photo_small.jpg',
    title: 'Test Photo',
    photographer: 'John Doe',
    description: 'A test photo',
    likes: 100,
    createdAt: DateTime.now(),
    tags: ['nature', 'landscape'],
  );

  group('PhotoCard Widget', () {
    testWidgets('should display photo information correctly',
        (WidgetTester tester) async {
      // Mock network images
      await mockNetworkImagesFor(() async {
        // Build widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PhotoCard(photo: testPhoto, source: 'home'),
            ),
          ),
        );

        // Wait for animations
        await tester.pumpAndSettle();

        // Verify title is displayed
        expect(find.text('Test Photo'), findsOneWidget);

        // Verify photographer is displayed
        expect(find.text('John Doe'), findsOneWidget);

        // Verify camera icon is displayed
        expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
      });
    });

    testWidgets('should handle long title and photographer name',
        (WidgetTester tester) async {
      final longPhoto = Photo(
        id: '1',
        url: 'https://example.com/photo.jpg',
        smallUrl: 'https://example.com/photo_small.jpg',
        title:
            'This is a very long title that should be truncated with ellipsis',
        photographer:
            'This is a very long photographer name that should be truncated',
        description: 'A test photo',
        likes: 100,
        createdAt: DateTime.now(),
        tags: ['nature', 'landscape'],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PhotoCard(photo: longPhoto, source: 'home'),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Get title text widget
        final titleFinder = find.text(longPhoto.title);
        final Text titleWidget = tester.widget(titleFinder);

        // Verify maxLines is set to 1
        expect(titleWidget.maxLines, 1);
        expect(titleWidget.overflow, TextOverflow.ellipsis);

        // Get photographer text widget
        final photographerFinder = find.text(longPhoto.photographer);
        final Text photographerWidget = tester.widget(photographerFinder);

        // Verify maxLines is set to 1
        expect(photographerWidget.maxLines, 1);
        expect(photographerWidget.overflow, TextOverflow.ellipsis);
      });
    });

    testWidgets('should show error icon when image fails to load',
        (WidgetTester tester) async {
      final errorPhoto = Photo(
        id: '1',
        url: 'https://invalid-url.com/photo.jpg',
        smallUrl: 'https://invalid-url.com/photo_small.jpg',
        title: 'Test Photo',
        photographer: 'John Doe',
        description: 'A test photo',
        likes: 100,
        createdAt: DateTime.now(),
        tags: ['nature', 'landscape'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoCard(photo: errorPhoto, source: 'home'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error icon is displayed
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}

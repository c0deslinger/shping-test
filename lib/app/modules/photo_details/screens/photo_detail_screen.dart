import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shping_test/app/modules/home/widgets/shimmer_loading.dart';
import '../../home/models/photo.dart';
import '../../home/providers/photo_provider.dart';

class PhotoDetailScreen extends StatelessWidget {
  final Photo photo;

  const PhotoDetailScreen({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Share functionality would go here')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Photo>(
        future: Provider.of<PhotoProvider>(context, listen: false)
            .getPhotoDetails(photo.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerDetail(context);
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final detailedPhoto = snapshot.data ?? photo;
          return _buildPhotoDetail(context, detailedPhoto);
        },
      ),
    );
  }

  Widget _buildShimmerDetail(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              const ShimmerLoading.rectangular(height: 400),
              Hero(
                tag: 'photo_${photo.id}',
                child: Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                const ShimmerLoading.rectangular(height: 24),
                const SizedBox(height: 16),

                // Photographer shimmer
                const Row(
                  children: [
                    ShimmerLoading.rectangular(width: 16, height: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: ShimmerLoading.rectangular(height: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Date & Likes shimmer
                const Row(
                  children: [
                    ShimmerLoading.rectangular(width: 16, height: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: ShimmerLoading.rectangular(height: 16),
                    ),
                    SizedBox(width: 16),
                    ShimmerLoading.rectangular(width: 16, height: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: ShimmerLoading.rectangular(height: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description shimmer
                const ShimmerLoading.rectangular(height: 16),
                const SizedBox(height: 8),
                const ShimmerLoading.rectangular(height: 16),
                const SizedBox(height: 8),
                const ShimmerLoading.rectangular(height: 16),
                const SizedBox(height: 24),

                // Tags shimmer
                const ShimmerLoading.rectangular(height: 20),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    5,
                    (index) => const ShimmerLoading.rectangular(
                      width: 80,
                      height: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoDetail(BuildContext context, Photo detailedPhoto) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image with loading indicator
          Hero(
            tag: 'photo_${detailedPhoto.id}',
            child: Stack(
              children: [
                const ShimmerLoading.rectangular(height: 400),
                Image.network(
                  detailedPhoto.url,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: child,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 400,
                      child: Center(
                        child: Icon(Icons.error_outline,
                            color: Colors.red, size: 48),
                      ),
                    );
                  },
                ),
                // Gradient overlay for better text visibility
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  detailedPhoto.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),

                // Photographer
                Row(
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'By ${detailedPhoto.photographer}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Date & Likes
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(DateFormat.yMMMMd().format(detailedPhoto.createdAt)),
                    const SizedBox(width: 16),
                    const Icon(Icons.favorite, size: 16),
                    const SizedBox(width: 4),
                    Text('${detailedPhoto.likes} likes'),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                if (detailedPhoto.description.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(detailedPhoto.description),
                  const SizedBox(height: 16),
                ],

                // Tags
                if (detailedPhoto.tags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: detailedPhoto.tags.map((tag) {
                      return Chip(label: Text(tag));
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

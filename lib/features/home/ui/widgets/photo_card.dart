import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:shping_test/features/home/ui/screens/photo_detail_screen.dart';
import 'package:shping_test/core/widgets/shimmer_loading.dart';

class PhotoCard extends StatelessWidget {
  final Photo photo;

  const PhotoCard({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push("${PhotoDetailScreen.route}?photoId=${photo.id}");
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with shimmer loading
            Expanded(
              child: Hero(
                tag: 'photo_${photo.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Shimmer background
                    const ShimmerLoading.rectangular(
                      height: double.infinity,
                    ),
                    // Actual image
                    Image.network(
                      photo.smallUrl,
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
                        return const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Info with shimmer loading
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    photo.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Photographer
                  Text(
                    'By ${photo.photographer}',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

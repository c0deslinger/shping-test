import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shping_test/core/theme/text_styles.dart';
import 'package:shping_test/core/widgets/offline_banner_widget.dart';
import 'package:shping_test/core/widgets/shimmer_loading.dart';
import 'package:shping_test/features/home/ui/widgets/shimmer_photo_detail.dart';
import '../../data/entities/photo.dart';
import '../../providers/photo_provider.dart';

class PhotoDetailScreen extends StatelessWidget {
  static const route = '/details';

  const PhotoDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? photoId =
        GoRouterState.of(context).uri.queryParameters['photoId'];

    debugPrint("id $photoId");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Photo>(
        future: Provider.of<PhotoProvider>(context, listen: false)
            .getPhotoDetails(photoId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return const ShimmerPhotoDetail();
          }
          final detailedPhoto = snapshot.data;
          return _buildPhotoDetail(context, detailedPhoto!);
        },
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
                CachedNetworkImage(
                  imageUrl: detailedPhoto.url,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  fadeInCurve: Curves.easeOut,
                  placeholder: (context, url) => const SizedBox(),
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 400,
                    child: Center(
                      child: Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                    ),
                  ),
                ),
                // Gradient overlay for better text visibility
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const OfflineBannerWidget(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  detailedPhoto.title,
                  style: AppTextStyle.headlineSmall,
                ),
                const SizedBox(height: 8),

                // Photographer
                Row(
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'By ${detailedPhoto.photographer}',
                      style: AppTextStyle.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Date & Likes
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat.yMMMMd().format(detailedPhoto.createdAt),
                      style: AppTextStyle.bodyMedium,
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.favorite, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${detailedPhoto.likes} likes',
                      style: AppTextStyle.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                if (detailedPhoto.description.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: AppTextStyle.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detailedPhoto.description,
                    style: AppTextStyle.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                ],

                // Tags
                if (detailedPhoto.tags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: AppTextStyle.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: detailedPhoto.tags.map((tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: AppTextStyle.bodyMedium,
                        ),
                      );
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

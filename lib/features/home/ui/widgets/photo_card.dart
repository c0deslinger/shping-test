import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shping_test/core/widgets/glass_container.dart';
import 'package:shping_test/features/favorite/provider/favorite_provider.dart';
import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:shping_test/features/home/ui/screens/photo_detail_screen.dart';
import 'package:shping_test/core/widgets/shimmer_loading.dart';

class PhotoCard extends StatefulWidget {
  final Photo photo;
  final String source;

  const PhotoCard({Key? key, required this.photo, required this.source})
      : super(key: key);

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: () {
          context.push(
              "${PhotoDetailScreen.route}?photoId=${widget.photo.id}&source=${widget.source}");
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Background Image
                // Add source to prevent duplicate tag ID from list photo screen and favorite screen
                Hero(
                  tag: 'photo_${widget.photo.id}_${widget.source}',
                  child: CachedNetworkImage(
                    imageUrl: widget.photo.smallUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeInCurve: Curves.easeOut,
                    placeholder: (context, url) =>
                        const ShimmerLoading.rectangular(
                      height: double.infinity,
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 0,
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      bool isFavorited = favoriteProvider
                          .checkIsFavoriteOnList(widget.photo.id);
                      return IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        onPressed: () {
                          favoriteProvider.toggleFavorite(widget.photo);
                        },
                      );
                    },
                  ),
                ),
                // Glass Info Container
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GlassContainer(
                    blur: 2,
                    opacity: 0.1,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.photo.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Photographer
                        Row(
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              size: 14,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.photo.photographer,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

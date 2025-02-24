import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shping_test/core/services/image_downloader.dart';
import 'package:shping_test/core/services/share_image_service.dart';
import 'package:shping_test/theme/text_styles.dart';
import 'package:shping_test/core/widgets/error_retry_widget.dart';
import 'package:shping_test/core/widgets/glass_container.dart';
import 'package:shping_test/core/widgets/shimmer_loading.dart';
import 'package:shping_test/features/favorite/provider/favorite_provider.dart';
import 'package:shping_test/features/home/ui/widgets/shimmer_photo_detail.dart';
import 'package:shping_test/utils/logger.dart';
import '../../data/entities/photo.dart';
import '../../providers/photo_provider.dart';

class PhotoDetailScreen extends StatefulWidget {
  static const route = '/details';

  const PhotoDetailScreen({Key? key}) : super(key: key);

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  // Use late and final to ensure initialization and prevent repeated instantiation
  final FileShareService _fileShareService = FileShareService();
  final FileDownloderService _fileDownloaderService = FileDownloderService();
  late PhotoProvider _photoProvider;
  String? _photoId;
  String? _source;

  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to safely access context after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _photoId = GoRouterState.of(context).uri.queryParameters['photoId'];
      _source = GoRouterState.of(context).uri.queryParameters['source'];

      _photoProvider = Provider.of<PhotoProvider>(context, listen: false);

      // Fetch photo details if photo ID is available
      if (_photoId != null && _source != null) {
        _photoProvider.getPhotoDetails(_photoId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 4,
              )
            ],
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              return Consumer<PhotoProvider>(
                builder: (context, photoProvider, child) {
                  final detailedPhoto = photoProvider.detailedPhoto;

                  if (detailedPhoto == null) {
                    return const SizedBox.shrink();
                  }

                  bool isFavorited =
                      favoriteProvider.checkIsFavoriteOnList(detailedPhoto.id);

                  LoggerUtil.d(
                      'is favorited: ${favoriteProvider.favorites.length}');

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
                      debugPrint('set favorite ${detailedPhoto.id}');
                      favoriteProvider.toggleFavorite(detailedPhoto);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<PhotoProvider>(
        builder: (context, provider, child) {
          final isInitialOrRefreshing =
              (provider.status == LoadingStatus.initial ||
                  provider.status == LoadingStatus.loading ||
                  _source == null);

          if (isInitialOrRefreshing) {
            return const ShimmerPhotoDetail();
          }

          Photo? detailedPhoto = provider.detailedPhoto;

          if (provider.status == LoadingStatus.error || detailedPhoto == null) {
            return ErrorRetryWidget(
                message: provider.errorMessage,
                onRetry: () {
                  // Use null-aware operator to prevent null errors
                  (_photoId != null && _source != null)
                      ? provider.getPhotoDetails(_photoId!)
                      : null;
                });
          }

          return RefreshIndicator(
            onRefresh: provider.refreshPhotos,
            child: _buildPhotoDetail(context, detailedPhoto, _source!,
                _fileShareService, _fileDownloaderService),
          );
        },
      ),
    );
  }

  // Method for building detailed photo view
  Widget _buildPhotoDetail(
      BuildContext context,
      Photo detailedPhoto,
      String source,
      FileShareService fileShareService,
      FileDownloderService fileDownloaderService) {
    return Stack(
      children: [
        Hero(
          tag: 'photo_${detailedPhoto.id}_$source',
          child: CachedNetworkImage(
            imageUrl: detailedPhoto.url,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 300),
            fadeInCurve: Curves.easeOut,
            placeholder: (context, url) => const ShimmerLoading.rectangular(
              height: double.infinity,
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
            ),
          ),
        ),

        // Bottom info panel
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: GlassContainer(
            blur: 20,
            opacity: 0.2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  _buildTitleSection(detailedPhoto),

                  // Description (if available)
                  if (detailedPhoto.description.isNotEmpty)
                    _buildDescriptionSection(detailedPhoto),

                  const SizedBox(height: 16),

                  // Stats row
                  _buildStatsRow(detailedPhoto),

                  const SizedBox(height: 16),

                  // Tags
                  _buildTagsSection(detailedPhoto),

                  const SizedBox(height: 16),

                  // Action buttons
                  _buildActionButtons(context, detailedPhoto, fileShareService,
                      fileDownloaderService),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Extracted method for title section
  Widget _buildTitleSection(Photo detailedPhoto) {
    return Text(
      detailedPhoto.title,
      style: AppTextStyle.headlineSmall.copyWith(
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Extracted method for description section
  Widget _buildDescriptionSection(Photo detailedPhoto) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          detailedPhoto.description,
          style: AppTextStyle.bodySmall
              .copyWith(color: Colors.white70, fontSize: 11),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Stats row of image info
  Widget _buildStatsRow(Photo detailedPhoto) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    detailedPhoto.smallUrl,
                  )),
            ),
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            Icons.person_outline,
            detailedPhoto.photographer,
            'photo.by'.tr(),
          ),
          const SizedBox(width: 16),
        ]),
        Row(
          children: [
            Container(
              width: 1,
              height: 40,
              color: Colors.white70,
            ),
            const SizedBox(width: 16),
            _buildStatItem(
              Icons.favorite_outline,
              NumberFormat.compact().format(detailedPhoto.likes),
              'photo.likes'.tr(),
            ),
          ],
        ),
      ],
    );
  }

  // List of tags
  Widget _buildTagsSection(Photo detailedPhoto) {
    if (detailedPhoto.tags.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: detailedPhoto.tags.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tag = detailedPhoto.tags[index];
          return GlassContainer(
            blur: 5,
            opacity: 0.15,
            borderRadius: BorderRadius.circular(20),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              tag,
              style: AppTextStyle.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  // Action buttons
  Widget _buildActionButtons(
      BuildContext context,
      Photo detailedPhoto,
      FileShareService fileShareService,
      FileDownloderService fileDownloaderService) {
    return Row(
      children: [
        Expanded(
          child: _buildDownloadButton(
              context, detailedPhoto, fileDownloaderService),
        ),
        const SizedBox(width: 16),
        _buildShareButton(context, detailedPhoto, fileShareService),
      ],
    );
  }

  // Download button
  Widget _buildDownloadButton(BuildContext context, Photo detailedPhoto,
      FileDownloderService fileDownloaderService) {
    return GestureDetector(
      onTap: () =>
          fileDownloaderService.downloadImage(context, detailedPhoto.url),
      child: GlassContainer(
        blur: 5,
        opacity: 0.15,
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download, color: Colors.white70),
            const SizedBox(width: 8),
            Text(
              'photo.download_image'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Share button
  Widget _buildShareButton(BuildContext context, Photo detailedPhoto,
      FileShareService fileShareService) {
    return GestureDetector(
      onTap: () => fileShareService.shareImage(
          context, detailedPhoto.url, detailedPhoto.title),
      child: GlassContainer(
        blur: 5,
        opacity: 0.15,
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.all(12),
        child: const Icon(Icons.share, color: Colors.white),
      ),
    );
  }

  // Stat items
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodySmall.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTextStyle.titleMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shping_test/core/theme/text_styles.dart';
import 'package:shping_test/core/widgets/error_retry_widget.dart';
import 'package:shping_test/core/widgets/no_data_available_widget.dart';
import 'package:shping_test/core/widgets/offline_banner_widget.dart';
import 'package:shping_test/features/home/ui/widgets/shimmer_photo_grid.dart';
import '../../providers/photo_provider.dart';
import '../widgets/photo_grid.dart';
import '../widgets/search_bar.dart';

/// Displays a photo gallery with search functionality and infinite scroll
class HomeScreen extends StatefulWidget {
  /// Route for navigation
  static const route = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Controller to manage scroll events and infinite scrolling
  final ScrollController _scrollController = ScrollController();

  /// Store PhotoProvider to avoid repeated Provider.of calls
  late PhotoProvider _photoProvider;

  @override
  void initState() {
    super.initState();
    // Fetch initial photos after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Store the provider once for multiple uses
      _photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      _photoProvider.fetchPhotos();
    });
    // Set up scroll listener for infinite scrolling
    _scrollController.addListener(_scrollListener);
  }

  /// Triggers loading more photos when user scrolls near bottom of the list
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      // Use the stored provider instead of calling Provider.of multiple times
      if (!_photoProvider.isLoadMore &&
          _photoProvider.status != LoadingStatus.loading &&
          _photoProvider.hasMore) {
        _photoProvider.loadMorePhotos();
      }
    }
  }

  @override
  void dispose() {
    // Clean up scroll controller to prevent memory leaks
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure UI rebuilds on language changes
    context.locale;

    return Scaffold(
      // App bar with title and settings icon
      appBar: AppBar(
        title: Text('home.title'.tr(), style: AppTextStyle.titleLarge),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Offline connectivity banner
          const OfflineBannerWidget(),
          // Search bar for photo search
          const CustomSearchBar(),
          // Expandable area for photo grid
          Expanded(
            child: Consumer<PhotoProvider>(
              builder: (context, provider, child) {
                // Handle different loading and error states
                final noDataYet = provider.photos.isEmpty;
                final isInitialOrRefreshing =
                    (provider.status == LoadingStatus.initial ||
                            provider.status == LoadingStatus.loading) &&
                        noDataYet;

                if (isInitialOrRefreshing) {
                  return const ShimmerPhotoGrid();
                }
                if (provider.status == LoadingStatus.error) {
                  return ErrorRetryWidget(
                      message: provider.errorMessage,
                      onRetry: provider.refreshPhotos);
                }
                if (provider.photos.isEmpty) {
                  return NoDataAvailableWidget(
                    message: provider.currentQuery.isEmpty
                        ? 'home.no_photos'.tr()
                        : 'home.no_results'.tr(args: [provider.currentQuery]),
                  );
                }
                return RefreshIndicator(
                  onRefresh: provider.refreshPhotos,
                  child: PhotoGrid(
                    photos: provider.photos,
                    source: 'home',
                    scrollController: _scrollController,
                    isLoading: provider.isLoadMore,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

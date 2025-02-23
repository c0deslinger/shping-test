import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shping_test/core/theme/text_styles.dart';
import 'package:shping_test/core/widgets/error_retry_widget.dart';
import 'package:shping_test/core/widgets/no_data_available_widget.dart';
import 'package:shping_test/core/widgets/offline_banner_widget.dart';
import 'package:shping_test/features/home/ui/widgets/shimmer_photo_grid.dart';
import 'package:shping_test/features/settings/screens/settings_screen.dart';
import '../../providers/photo_provider.dart';
import '../widgets/photo_grid.dart';
import '../widgets/search_bar.dart';

/// Displays a photo gallery with search functionality and infinite scroll.
/// Also shows an offline indicator and a link to the Settings screen.
class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial data after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PhotoProvider>(context, listen: false).fetchPhotos();
    });
    // Listen for scroll events to handle infinite scrolling.
    _scrollController.addListener(_scrollListener);
  }

  /// Loads more photos when the user scrolls near the bottom.
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      final provider = Provider.of<PhotoProvider>(context, listen: false);

      // Only load more if not already loading, not in the middle of a refresh,
      // and more data is available.
      if (!provider.isLoadMore &&
          provider.status != LoadingStatus.loading &&
          provider.hasMore) {
        provider.loadMorePhotos();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery', style: AppTextStyle.titleLarge),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push(SettingsScreen.route);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline banner
          const OfflineBannerWidget(),
          // Search bar
          const CustomSearchBar(),
          // Main content
          Expanded(
            child: Consumer<PhotoProvider>(
              builder: (context, provider, child) {
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
                      message: ' ${provider.errorMessage}',
                      onRetry: provider.refreshPhotos);
                }
                if (provider.photos.isEmpty) {
                  return NoDataAvailableWidget(
                    message: provider.currentQuery.isEmpty
                        ? 'No photos available'
                        : 'No results found for "${provider.currentQuery}"',
                  );
                }
                return RefreshIndicator(
                  onRefresh: provider.refreshPhotos,
                  child: PhotoGrid(
                    photos: provider.photos,
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

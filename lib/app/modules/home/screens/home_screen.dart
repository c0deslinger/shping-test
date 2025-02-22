import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shping_test/app/global/providers/theme_provider.dart';
import 'package:shping_test/app/modules/home/widgets/shimmer_grid_loading.dart';
import '../providers/photo_provider.dart';
import '../widgets/photo_grid.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial photos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PhotoProvider>(context, listen: false).fetchPhotos();
    });

    // Setup scroll listener for infinite scrolling
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      final provider = Provider.of<PhotoProvider>(context, listen: false);
      if (provider.status != LoadingStatus.loading && provider.hasMore) {
        provider.loadMorePhotos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        elevation: 0,
        actions: [
          // Network status indicator
          Consumer<PhotoProvider>(
            builder: (context, provider, child) {
              return provider.isOffline
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.cloud_off, color: Colors.orange),
                    )
                  : const SizedBox.shrink();
            },
          ),
          // Theme toggle
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline banner
          Consumer<PhotoProvider>(
            builder: (context, provider, child) {
              return provider.isOffline
                  ? Container(
                      width: double.infinity,
                      color: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text(
                        'Offline Mode - Showing cached data',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),

          // Search Bar
          const CustomSearchBar(),

          // Main Content
          Expanded(
            child: Consumer<PhotoProvider>(
              builder: (context, provider, child) {
                if (provider.status == LoadingStatus.initial ||
                    provider.status == LoadingStatus.loading) {
                  return const ShimmerGridLoading();
                }

                if (provider.status == LoadingStatus.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${provider.errorMessage}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.refreshPhotos(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.photos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.photo_album_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          provider.currentQuery.isEmpty
                              ? 'No photos available'
                              : 'No results found for "${provider.currentQuery}"',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.refreshPhotos();
                  },
                  child: PhotoGrid(
                    photos: provider.photos,
                    scrollController: _scrollController,
                    isLoading: provider.status == LoadingStatus.loading,
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

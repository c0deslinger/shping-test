import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shping_test/core/providers/network_provider.dart';
import 'package:shping_test/core/providers/theme_provider.dart';
import 'package:shping_test/core/services/connectivity_service.dart';
import 'package:shping_test/core/services/db_helper.dart';
import 'package:shping_test/features/home/data/datasource/local/hive_local_datasource.dart';
import 'package:shping_test/features/home/data/datasource/remote/pixabay_api_datasource.dart';
import 'package:shping_test/features/home/data/datasource/remote/unsplash_api_datasource.dart';
import 'package:shping_test/features/favorite/provider/favorite_provider.dart';
import 'package:shping_test/features/home/providers/photo_provider.dart';
import 'package:shping_test/features/home/repository/photo_repository_impl.dart';
import 'package:shping_test/features/settings/providers/settings_provider.dart';

class ProviderList {
  static List<SingleChildWidget> getProviders() {
    // Initialize services
    final connectivityService = ConnectivityService();
    final localDataSource = HiveLocalDataSource();
    final unsplashApiDataSource = UnsplashApiDataSource();
    final pixabayApiDataSource = PixabayApiDataSource();

    // Initialize repositories
    final unsplashRepository = PhotoRepositoryImpl(
      apiDataSource: unsplashApiDataSource,
      localDataSource: localDataSource,
      connectivityService: connectivityService,
    );

    final pixabayRepository = PhotoRepositoryImpl(
      apiDataSource: pixabayApiDataSource,
      localDataSource: localDataSource,
      connectivityService: connectivityService,
    );

    return [
      // Services
      Provider.value(value: connectivityService),

      // Core Providers
      ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),

      // Feature Providers
      ChangeNotifierProvider(
        create: (_) => FavoriteProvider(DatabaseHelper.instance),
      ),

      // Photo Provider with multiple repositories
      ChangeNotifierProxyProvider<SettingsProvider, PhotoProvider>(
        create: (context) => PhotoProvider(
          unsplashRepository,
          pixabayRepository,
          Provider.of<SettingsProvider>(context, listen: false),
        ),
        update: (context, settings, previous) {
          if (previous == null) {
            return PhotoProvider(
              unsplashRepository,
              pixabayRepository,
              settings,
            );
          }
          return previous;
        },
      ),
    ];
  }
}

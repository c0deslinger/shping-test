import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shping_test/core/providers/network_provider.dart';
import 'package:shping_test/core/providers/theme_provider.dart';
import 'package:shping_test/core/routes/app_router.dart';
import 'package:shping_test/core/services/connectivity_service.dart';
import 'package:shping_test/core/theme/app_themes.dart';
import 'package:shping_test/features/home/data/datasource/local/hive_local_datasource.dart';
import 'package:shping_test/features/home/data/datasource/remote/pixabay_api_datasource.dart';
import 'package:shping_test/features/home/data/datasource/remote/unsplash_api_datasource.dart';
import 'package:shping_test/features/home/providers/photo_provider.dart';
import 'package:shping_test/features/home/repository/photo_repository_impl.dart';
import 'package:shping_test/features/settings/providers/settings_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2. Inisialisasi ConnectivityService
    final connectivityService = ConnectivityService();

    // 3. Inisialisasi data sources
    final localDataSource = HiveLocalDataSource();
    final unsplashApiDataSource = UnsplashApiDataSource();
    final pixabayApiDataSource = PixabayApiDataSource();

    // 4. Buat repository terpisah untuk Unsplash & Pixabay
    //    Perhatikan kita tambah parameter 'sourceKey' agar cache beda.
    final unsplashRepository = PhotoRepositoryImpl(
        apiDataSource: unsplashApiDataSource,
        localDataSource: localDataSource,
        connectivityService: connectivityService);

    final pixabayRepository = PhotoRepositoryImpl(
        apiDataSource: pixabayApiDataSource,
        localDataSource: localDataSource,
        connectivityService: connectivityService);

    return MultiProvider(
      providers: [
        // Services
        Provider.value(value: connectivityService),

        // Providers
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        // Inject PhotoProvider yang memegang 2 repository (Unsplash, Pixabay)
        ChangeNotifierProvider(
          create: (context) => PhotoProvider(
            unsplashRepository,
            pixabayRepository,
            Provider.of<SettingsProvider>(context, listen: false),
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Photo Gallery'.tr(),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }
}

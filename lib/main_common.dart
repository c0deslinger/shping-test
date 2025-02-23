import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// Import kelas2 yang dibutuhkan
import 'package:shping_test/core/providers/network_provider.dart';
import 'package:shping_test/features/home/data/datasource/remote/unsplash_api_datasource.dart';
import 'package:shping_test/features/settings/providers/settings_provider.dart';
import 'package:shping_test/features/home/data/datasource/remote/pixabay_api_datasource.dart';
import 'package:shping_test/features/home/data/datasource/local/hive_local_datasource.dart';
import 'package:shping_test/features/home/repository/photo_repository_impl.dart';
import 'package:shping_test/my_app.dart';
import 'package:shping_test/core/providers/theme_provider.dart';
import 'package:shping_test/core/services/connectivity_service.dart';
import 'package:shping_test/core/utils/config_reader.dart';

import 'features/home/providers/photo_provider.dart';

Future<void> mainCommon(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigReader.initialize(env);

  // 1. Inisialisasi Hive
  await Hive.initFlutter();

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

  // 5. Jalankan App dengan MultiProvider
  runApp(
    MultiProvider(
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
      child: const MyApp(),
    ),
  );
}

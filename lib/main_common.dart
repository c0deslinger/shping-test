import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shping_test/app/my_app.dart';
import 'package:shping_test/app/global/providers/theme_provider.dart';
import 'package:shping_test/app/global/services/cache_service.dart';
import 'package:shping_test/utils/config_reader.dart';

import 'app/modules/home/providers/photo_provider.dart';
import 'app/modules/home/repository/photo_repository.dart';

Future<void> mainCommon(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigReader.initialize(env);

  // Initialize cache service
  final cacheService = CacheService();
  await cacheService.init();

  // Initialize repository with cache
  final photoRepository = UnsplashPhotoRepository(cacheService);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PhotoProvider(photoRepository)),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

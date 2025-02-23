import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/ui/screens/home_screen.dart';
import '../../features/home/ui/screens/photo_detail_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: HomeScreen.route,
    routes: [
      GoRoute(
        path: HomeScreen.route,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: PhotoDetailScreen.route,
        builder: (context, state) => const PhotoDetailScreen(),
      ),
      GoRoute(
        path: SettingsScreen.route,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

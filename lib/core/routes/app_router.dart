import 'package:go_router/go_router.dart';
import 'package:shping_test/features/favorite/ui/favorite_screen.dart';
import 'package:shping_test/features/home/ui/screens/photo_list_screen.dart';
import 'package:shping_test/features/settings/screens/settings_screen.dart';
import 'package:shping_test/features/home/ui/screens/photo_detail_screen.dart';
import 'package:shping_test/features/home/ui/screens/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: HomeScreen.route,
    routes: [
      GoRoute(
        path: HomeScreen.route,
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Your existing routes can be nested here
          GoRoute(
            path: 'home',
            builder: (context, state) => const PhotoListScreen(),
          ),
          GoRoute(
            path: 'favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: PhotoDetailScreen.route,
            builder: (context, state) => const PhotoDetailScreen(),
          ),
        ],
      ),
      GoRoute(
        path: PhotoDetailScreen.route,
        builder: (context, state) => const PhotoDetailScreen(),
      ),
    ],
  );
}

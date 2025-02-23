import 'package:go_router/go_router.dart';
import 'package:shping_test/features/home/ui/screens/home_screen.dart';
import 'package:shping_test/features/settings/screens/settings_screen.dart';
import 'package:shping_test/features/home/ui/screens/photo_detail_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: HomeScreen.route,
    routes: [
      GoRoute(
        path: HomeScreen.route,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: SettingsScreen.route,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: PhotoDetailScreen.route,
        builder: (context, state) => const PhotoDetailScreen(),
      ),
    ],
  );
}

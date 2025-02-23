import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shping_test/features/favorite/ui/favorite_screen.dart';
import 'package:shping_test/features/home/ui/screens/home_screen.dart';
import 'package:shping_test/features/settings/screens/settings_screen.dart';

import '../../core/widgets/glass_container.dart';

class MainNavigationScreen extends StatefulWidget {
  static const route = '/';

  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  MainNavigationScreenState createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Glassmorphic Bottom Navigation Bar
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Center(
              child: GlassContainer(
                // width: MediaQuery.of(context).size.width * 0.85,
                blur: 10,
                opacity: 0.2,
                borderRadius: BorderRadius.circular(32),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home,
                      label: 'home.title'.tr(),
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.favorite_border,
                      selectedIcon: Icons.favorite,
                      label: 'favorite'.tr(),
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.settings_outlined,
                      selectedIcon: Icons.settings,
                      label: 'settings.title'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

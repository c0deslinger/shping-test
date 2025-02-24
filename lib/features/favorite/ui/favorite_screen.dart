// lib/features/home/ui/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shping_test/features/settings/providers/settings_provider.dart';
import '../provider/favorite_provider.dart';
import '../../home/ui/widgets/photo_grid.dart';
import '../../../core/widgets/no_data_available_widget.dart';

class FavoritesScreen extends StatefulWidget {
  static const route = '/favorites';

  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  ImageSource? latestSource;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure UI rebuilds on language changes
    context.locale;
    return Scaffold(
      appBar: AppBar(
        title: Text('favorite'.tr()),
      ),
      body: Consumer<SettingsProvider>(
          builder: (context, settingProvider, child) {
        return Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            //only refresh if there is an update from imagesource setting
            if (settingProvider.imageSource != null &&
                settingProvider.imageSource != latestSource) {
              latestSource = settingProvider.imageSource;
              favoriteProvider.refreshFavorites(settingProvider.imageSource!);
            }
            if (favoriteProvider.favorites.isEmpty) {
              return NoDataAvailableWidget(
                message: 'home.no_photos'.tr(),
              );
            }

            return PhotoGrid(
              photos: favoriteProvider.favorites,
              source: 'favorite',
              scrollController: ScrollController(),
            );
          },
        );
      }),
    );
  }
}

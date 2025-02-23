// lib/features/home/ui/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../provider/favorite_provider.dart';
import '../../home/ui/widgets/photo_grid.dart';
import '../../../core/widgets/no_data_available_widget.dart';

class FavoritesScreen extends StatelessWidget {
  static const route = '/favorites';

  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure UI rebuilds on language changes
    context.locale;
    return Scaffold(
      appBar: AppBar(
        title: Text('favorite'.tr()),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
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
      ),
    );
  }
}

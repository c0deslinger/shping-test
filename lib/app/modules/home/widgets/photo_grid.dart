import 'package:flutter/material.dart';
import 'package:shping_test/app/modules/home/widgets/photo_card.dart';
import 'package:shping_test/app/modules/home/widgets/shimmer_card.dart';
import '../models/photo.dart';

class PhotoGrid extends StatelessWidget {
  final List<Photo> photos;
  final ScrollController scrollController;
  final bool isLoading;

  const PhotoGrid({
    Key? key,
    required this.photos,
    required this.scrollController,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: photos.length + (isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= photos.length) {
          return const ShimmerCard();
        }

        final photo = photos[index];
        return PhotoCard(photo: photo);
      },
    );
  }
}

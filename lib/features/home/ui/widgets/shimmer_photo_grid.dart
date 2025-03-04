import 'package:flutter/material.dart';
import 'package:shping_test/core/widgets/shimmer_loading.dart';

class ShimmerPhotoGrid extends StatelessWidget {
  const ShimmerPhotoGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 10, // Number of shimmer items to show
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              ShimmerLoading.rectangular(height: 150),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading.rectangular(height: 12),
                    SizedBox(height: 8),
                    ShimmerLoading.rectangular(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

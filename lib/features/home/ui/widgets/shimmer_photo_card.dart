import 'package:flutter/material.dart';
import 'package:shping_test/core/widgets/shimmer_loading.dart';

class ShimmerPhotoCard extends StatelessWidget {
  const ShimmerPhotoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const Stack(
          children: [
            // Background shimmer
            ShimmerLoading.rectangular(
              height: double.infinity,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading.rectangular(height: 14),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      ShimmerLoading.circular(width: 14, height: 14),
                      SizedBox(width: 4),
                      Expanded(
                        child: ShimmerLoading.rectangular(height: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shping_test/app/modules/home/widgets/shimmer_loading.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: ShimmerLoading.rectangular(
              height: double.infinity,
            ),
          ),

          // Info placeholders
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                ShimmerLoading.rectangular(height: 14),
                SizedBox(height: 8),
                // Author placeholder
                ShimmerLoading.rectangular(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shping_test/core/widgets/shimmer_loading.dart';

class ShimmerPhotoDetail extends StatelessWidget {
  const ShimmerPhotoDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              const ShimmerLoading.rectangular(height: 400),
              Hero(
                tag: 'photo',
                child: Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                const ShimmerLoading.rectangular(height: 24),
                const SizedBox(height: 16),

                // Photographer shimmer
                const Row(
                  children: [
                    ShimmerLoading.rectangular(width: 16, height: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: ShimmerLoading.rectangular(height: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Date & Likes shimmer
                const Row(
                  children: [
                    ShimmerLoading.rectangular(width: 16, height: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: ShimmerLoading.rectangular(height: 16),
                    ),
                    SizedBox(width: 16),
                    ShimmerLoading.rectangular(width: 16, height: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: ShimmerLoading.rectangular(height: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description shimmer
                const ShimmerLoading.rectangular(height: 16),
                const SizedBox(height: 8),
                const ShimmerLoading.rectangular(height: 16),
                const SizedBox(height: 8),
                const ShimmerLoading.rectangular(height: 16),
                const SizedBox(height: 24),

                // Tags shimmer
                const ShimmerLoading.rectangular(height: 20),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    5,
                    (index) => const ShimmerLoading.rectangular(
                      width: 80,
                      height: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shping_test/core/providers/network_provider.dart';

class OfflineBannerWidget extends StatelessWidget {
  const OfflineBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(builder: (context, provider, child) {
      if (!provider.isConnected) {
        return Container(
          width: double.infinity,
          color: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Text(
            'Offline Mode - Showing cached data',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

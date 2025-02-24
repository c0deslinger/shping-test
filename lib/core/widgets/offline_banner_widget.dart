import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shping_test/core/providers/network_provider.dart';

class OfflineBannerWidget extends StatelessWidget {
  const OfflineBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(builder: (context, network, child) {
      if (!network.isConnected) {
        return Container(
          width: double.infinity,
          color: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'home.offline_mode'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

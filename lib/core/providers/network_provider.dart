import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shping_test/core/services/connectivity_service.dart';

class NetworkProvider with ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();
  late final StreamSubscription<bool> _connectivitySubscription;
  bool _isConnected = false;

  NetworkProvider() {
    // Initialize with current connection status
    _isConnected = _connectivityService.isConnected;

    // Subscribe to connectivity changes
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((connected) {
      _isConnected = connected;
      notifyListeners();
    });
  }

  bool get isConnected => _isConnected;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  final _connectivityController = StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _connectivityController.stream;

  final Connectivity _connectivity = Connectivity();
  bool isConnected = false;

  ConnectivityService._internal() {
    init();
  }

  Future<void> init() async {
    // Check initial connectivity state
    final initialResult = await _connectivity.checkConnectivity();
    checkConnection(initialResult);

    // Then listen for subsequent changes
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> connectivityResult) {
      checkConnection(connectivityResult);
    });
  }

  void checkConnection(List<ConnectivityResult> connectivityResult) {
    final wasConnected = isConnected;
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      isConnected = true;
    } else {
      isConnected = false;
    }

    debugPrint('Connectivity changed: $isConnected');

    // Only emit if there's a change in connection status
    if (wasConnected != isConnected) {
      _connectivityController.add(isConnected);
    }
  }

  void dispose() {
    _connectivityController.close();
  }

  Future<bool> checkCurrentConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      checkConnection(result);
      return isConnected;
    } catch (e) {
      debugPrint('Check current connectivity error: $e');
      return false;
    }
  }
}

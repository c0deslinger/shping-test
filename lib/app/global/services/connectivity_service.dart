import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Singleton pattern
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal() {
    // Initialize connectivity checking
    // Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  final _connectivityController = StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _connectivityController.stream;

  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _connectivityController.add(result != ConnectivityResult.none);
  }

  void dispose() {
    _connectivityController.close();
  }
}

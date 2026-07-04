import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity connectivity;

  const NetworkInfo({
    required this.connectivity,
  });

  /// Checks the current internet connection.
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();

    return !results.contains(ConnectivityResult.none);
  }

  /// Emits connection changes.
  Stream<bool> get onConnectionChanged {
    return connectivity.onConnectivityChanged.map(
          (results) => !results.contains(ConnectivityResult.none),
    );
  }
}
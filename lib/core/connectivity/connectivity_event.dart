abstract class ConnectivityEvent {
  const ConnectivityEvent();
}

class ConnectivityStarted extends ConnectivityEvent {
  const ConnectivityStarted();
}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;

  const ConnectivityChanged({
    required this.isConnected,
  });
}
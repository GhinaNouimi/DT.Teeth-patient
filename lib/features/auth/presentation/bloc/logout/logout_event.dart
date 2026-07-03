abstract class LogoutEvent {
  const LogoutEvent();
}

class LogoutRequested extends LogoutEvent {
  final String languageCode;

  const LogoutRequested({
    required this.languageCode,
  });
}
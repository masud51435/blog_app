class SessionController {
  SessionController._internal();
  static final SessionController _sessionController =
      SessionController._internal();
  late String userId;
  late String img;
  late String name;
  factory SessionController() => _sessionController;
}

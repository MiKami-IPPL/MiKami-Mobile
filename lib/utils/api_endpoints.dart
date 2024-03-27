class ApiEndPoints {
  static final String baseUrl = 'http://10.0.2.2:8000/api/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String loginEmail = 'login';
  final String registerEmail = 'register';
}

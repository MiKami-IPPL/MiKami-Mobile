class ApiEndPoints {
  static final String baseUrl = 'http://10.0.2.2:8000/api/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String Login = 'login';
  final String Register = 'register';
  final String Genres = 'genre';
  final String Comics = 'comics';
  final String TopUpCoins = 'top-up';
  final String Coins = 'coins';
  final String Profile = 'profile';
  final String ForgotPassword = 'forgot-password';
  final String Withdrawal = 'coins/withdrawal';
  final String Report = 'comics/\$id/report';
  final String EditProfile = 'edit-profile';
  final String Upgrade = 'register-author';
}

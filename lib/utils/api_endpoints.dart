class ApiEndPoints {
  // static final String baseUrl = 'http://10.0.2.2:8000/api/';
  static final String baseUrl =
      'https://5a3c-2001-448a-6040-7a0a-6046-3979-81c3-8e03.ngrok-free.app/api/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String Login = 'login';
  final String Register = 'register';
  final String Genres = 'genre';
  final String Comics = 'comics';
  final String TopUpCoins = 'coins/top-up';
  final String Coins = 'coins';
  final String Profile = 'profile';
  final String ForgotPassword = 'forgot-password';
  final String Withdrawal = 'coins/withdrawal';
  final String Report = 'comics/\$id/report';
  final String EditProfile = 'edit-profile';
  final String EditPicture = 'edit-profile-picture';
  final String Upgrade = 'register-author';
  final String Price = 'coins/price';
  final String ComicsByAuthor = 'comics/author';
  final String DeleteComic = 'comics/\$id/delete';
}

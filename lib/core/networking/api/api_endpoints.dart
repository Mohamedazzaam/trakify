import 'package:trakify/core/networking/api/user_data.dart';

class ApiEndPoints {
  static const String apiBaseUrl =
      'https://trakify-production.up.railway.app/api/v1/';

  static const String login = 'auth/login/';
  static const String signup = 'auth/register/';
  static Future<String> profile() async {
    return 'users/${await getUserId()}/';
  }

  static const String changePassword = 'auth/change-password/';
}

class ApiKey {
  //! Errors keys
  static const String errorMessage = 'message';

  //! Response keys
  static const String message = 'message';

  //! Headers keys
  static const String acceptLanguage = 'Accept-Language';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer ';

  //! Auth keys
  static const String id = '_id';
  static const String name = 'name';
  static const String email = 'email';
  static const String password = 'password';
  static const String image = 'image';
  static const String user = 'user';

  //! Token keys
  static const String token = 'accessToken';

  //! Profile keys
  static const String oldPassword = 'oldPassword';
  static const String newPassword = 'newPassword';
}

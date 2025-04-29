import 'package:trakify/features/login/data/models/user_model.dart';

import '../../../../core/networking/api/api_endpoints.dart';

class LoginResponseModel {
  final UserModel user;
  final String token;

  LoginResponseModel({required this.user, required this.token});
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json[ApiKey.user]),
      token: json[ApiKey.token],
    );
  }
}

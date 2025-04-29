import 'package:trakify/core/networking/api/api_endpoints.dart';

class ChangePasswordRequestModel {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequestModel({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {ApiKey.oldPassword: oldPassword, ApiKey.newPassword: newPassword};
  }
}

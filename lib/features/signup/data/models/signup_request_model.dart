import '../../../../core/networking/api/api_endpoints.dart';

class SignupRequestModel {
  final String name;
  final String email;
  final String password;

  SignupRequestModel({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {ApiKey.name: name, ApiKey.email: email, ApiKey.password: password};
  }
}

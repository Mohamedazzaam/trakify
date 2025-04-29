import 'package:trakify/core/networking/api/api_endpoints.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  String? image;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[ApiKey.id],
      name: json[ApiKey.name],
      email: json[ApiKey.email],
      image: json[ApiKey.image],
    );
  }
}

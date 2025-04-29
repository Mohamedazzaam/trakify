import 'package:trakify/core/networking/api/api_endpoints.dart';

class UpdateUserRequestModel {
  final String? name;
  final String? email;
  final dynamic image;

  UpdateUserRequestModel({this.name, this.email, this.image});
  Map<String, dynamic> toJson() {
    return {ApiKey.name: name, ApiKey.email: email, ApiKey.image: image};
  }
}

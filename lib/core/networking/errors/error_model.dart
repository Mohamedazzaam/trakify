import '../api/api_endpoints.dart';

class ErrorModel {
  final String? errorMessage;

  ErrorModel({this.errorMessage});
  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(errorMessage: json[ApiKey.errorMessage]);
  }
}

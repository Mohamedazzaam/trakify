import 'package:dartz/dartz.dart';
import 'package:trakify/core/networking/api/user_data.dart';
import 'package:trakify/features/login/data/models/login_response_model.dart';

import '../../../../core/networking/api/api_consumer.dart';
import '../../../../core/networking/api/api_endpoints.dart';
import '../../../../core/networking/errors/error_handle_exeptions.dart';
import '../models/login_request_model.dart';

class LoginRepo {
  final ApiConsumer api;

  LoginRepo(this.api);

  Future<Either<String, LoginResponseModel>> login({
    required LoginRequestModel loginRequest,
  }) async {
    try {
      final response = await api.post(
        ApiEndPoints.login,
        data: loginRequest.toJson(),
        useHeaders: false,
      );
      final loginResponse = LoginResponseModel.fromJson(response);
      await saveToken(loginResponse.token);
      await saveUserId(loginResponse.user.id);

      return Right(loginResponse);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage!);
    }
  }
}

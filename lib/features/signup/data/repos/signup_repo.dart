import 'package:dartz/dartz.dart';

import '../../../../core/networking/api/api_consumer.dart';
import '../../../../core/networking/api/api_endpoints.dart';
import '../../../../core/networking/errors/error_handle_exeptions.dart';
import '../models/signup_request_model.dart';

class SignupRepo {
  final ApiConsumer api;
  SignupRepo(this.api);
  Future<Either<String, String>> signup({
    required SignupRequestModel signupRequest,
  }) async {
    try {
      await api.post(
        ApiEndPoints.signup,
        data: signupRequest.toJson(),
        useHeaders: false,
      );

      return const Right('User created successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage ?? 'Server Error');
    }
  }
}

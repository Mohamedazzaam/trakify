import 'package:dartz/dartz.dart';
import 'package:trakify/core/networking/api/api_consumer.dart';
import 'package:trakify/core/networking/api/api_endpoints.dart';
import 'package:trakify/core/networking/errors/error_handle_exeptions.dart';
import 'package:trakify/features/change_password/data/models/change_password_request_model.dart';

class ChangePasswordRepo {
  final ApiConsumer api;
  ChangePasswordRepo(this.api);

  Future<Either<String, String>> changePassword({
    required ChangePasswordRequestModel changePasswordModel,
  }) async {
    try {
      final response = await api.post(
        ApiEndPoints.changePassword,
        data: changePasswordModel.toJson(),
      );

      if (response == null || !response.containsKey(ApiKey.message)) {
        return Left("Unexpected response from the server");
      }

      return Right(response[ApiKey.message]);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage ?? "An unknown error occurred");
    } catch (e) {
      return Left("An unexpected error occurred: ${e.toString()}");
    }
  }
}

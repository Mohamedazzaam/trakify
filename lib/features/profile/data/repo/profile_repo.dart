import 'package:dartz/dartz.dart';
import 'package:trakify/core/networking/api/api_consumer.dart';
import 'package:trakify/core/networking/api/api_endpoints.dart';
import 'package:trakify/core/networking/errors/error_handle_exeptions.dart';
import 'package:trakify/features/login/data/models/user_model.dart';

class ProfileRepo {
  final ApiConsumer api;
  ProfileRepo(this.api);

  Future<Either<String, UserModel>> getUserProfile() async {
    final String profile = await ApiEndPoints.profile();

    try {
      final response = await api.get(profile);
      return Right(UserModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage!);
    }
  }
}

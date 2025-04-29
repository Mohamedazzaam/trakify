import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trakify/core/functions/upload_image_to_api.dart';
import 'package:trakify/core/networking/api/api_consumer.dart';
import 'package:trakify/core/networking/api/api_endpoints.dart';
import 'package:trakify/core/networking/errors/error_handle_exeptions.dart';

class EditProfileRepo {
  final ApiConsumer api;
  EditProfileRepo(this.api);

  Future<Either<String, String>> updateProfile({
    String? name,
    String? email,
    XFile? imageFile,
  }) async {
    final data = <String, dynamic>{
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (imageFile != null) 'image': await uploadImageToAPI(imageFile),
    };

    try {
      await api.patch(
        await ApiEndPoints.profile(),
        data: data,
        isFormData: true,
      );
      return Right("Profile updated successfully");
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage ?? "Unknown error");
    }
  }
}

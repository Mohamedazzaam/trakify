import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trakify/features/edit_profile/data/models/update_user_request_model.dart';
import 'package:trakify/features/edit_profile/data/repos/edit_profile_repo.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final EditProfileRepo editProfileRepo;

  EditProfileCubit(this.editProfileRepo) : super(EditProfileInitial());

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  XFile? profilePic;

  void uploadProfileImage(XFile image) {
    profilePic = image;
    emit(UploadProfileImage(image: image));
  }

  Future<void> updateProfile(
    UpdateUserRequestModel updateUserRequestModel,
  ) async {
    emit(EditProfileLoading());
    final response = await editProfileRepo.updateProfile(
      name: updateUserRequestModel.name,
      email: updateUserRequestModel.email,
      imageFile: updateUserRequestModel.image,
    );
    response.fold(
      (errorMessage) {
        emit(EditProfileFailure(errorMessage));
      },
      (message) {
        emit(EditProfileSuccess(message));
      },
    );
  }
}

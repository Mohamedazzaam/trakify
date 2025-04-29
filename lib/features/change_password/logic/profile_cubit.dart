import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/features/change_password/data/models/change_password_request_model.dart';
import 'package:trakify/features/change_password/data/repos/change_password_repo.dart';

part 'profile_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepo changePasswordRepo;

  ChangePasswordCubit(this.changePasswordRepo) : super(ChangePasswordInitial());

  GlobalKey<FormState> changePasswordFormKey = GlobalKey();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<void> changePassword() async {
    emit(ChangePasswordLoading());

    final changePasswordResponse = await changePasswordRepo.changePassword(
      changePasswordModel: ChangePasswordRequestModel(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      ),
    );

    changePasswordResponse.fold(
      (errorMessage) => emit(ChangePasswordFailure(errorMessage: errorMessage)),
      (success) => emit(ChangePasswordSuccess(success: success)),
    );
  }
}

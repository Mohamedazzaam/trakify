import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/signup_request_model.dart';
import '../../data/repos/signup_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.signupRepo) : super(SignupInitial());

  final SignupRepo signupRepo;

  GlobalKey<FormState> signupFormKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signup() async {
    emit(SignupLoading());

    final signupResponse = await signupRepo.signup(
      signupRequest: SignupRequestModel(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      ),
    );

    signupResponse.fold(
      (errorMessage) => emit(SignupFailure(message: errorMessage)),
      (signupResponse) {
        emit(SignupSuccess());
      },
    );
  }
}

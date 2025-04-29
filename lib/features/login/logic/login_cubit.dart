import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/login_request_model.dart';
import '../data/repos/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginRepo) : super(LoginInitial());

  final LoginRepo loginRepo;
  GlobalKey<FormState> loginFormKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    emit(LoginLoading());

    final loginResponse = await loginRepo.login(
      loginRequest: LoginRequestModel(
        email: emailController.text,
        password: passwordController.text,
      ),
    );

    loginResponse.fold(
      (errorMessage) => emit(LoginFailure(errorMessage: errorMessage)),
      (loginResponseModel) {
        emit(LoginSuccess());
      },
    );
  }
}

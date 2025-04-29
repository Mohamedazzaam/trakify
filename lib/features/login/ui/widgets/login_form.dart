import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/core/widgets/custom_text_field.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/helpers/validation.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../logic/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = context.read<LoginCubit>();

    return Form(
      key: loginCubit.loginFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          CustomTextField(
            title: 'Email',
            hintText: 'Enter your email',
            iconData: Icons.email,
            validator: (value) => validateEmail(context, value),
            controller: loginCubit.emailController,
          ),
          verticalSpace(20),
          CustomTextField(
            title: 'Password',
            hintText: 'Enter your password',
            iconData: Icons.lock,
            isPassword: true,
            validator: (value) => validatePassword(context, value),
            controller: loginCubit.passwordController,
          ),
          verticalSpace(15),
          CustomButton(
            text: 'Login',
            textStyle: AppStyles.font16w600White,
            backgroundColor: AppColors.primary,
            onPressed: () {
              validateThenDoLogin(context, loginCubit);
            },
          ),
        ],
      ),
    );
  }
}

void validateThenDoLogin(BuildContext context, LoginCubit loginCubit) async {
  bool formIsValid = loginCubit.loginFormKey.currentState!.validate();

  if (!formIsValid) {
    return;
  }

  loginCubit.loginFormKey.currentState!.save();

  await loginCubit.login();
}

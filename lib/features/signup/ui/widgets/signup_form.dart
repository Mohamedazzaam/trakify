import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/core/widgets/custom_text_field.dart';
import 'package:trakify/features/signup/logic/cubit/signup_cubit.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/helpers/validation.dart';
import '../../../../core/widgets/custom_button.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    SignupCubit signupCubit = context.read<SignupCubit>();

    return Form(
      key: signupCubit.signupFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          CustomTextField(
            title: 'Full Name',
            hintText: 'Enter your full name',
            iconData: Icons.person,
            validator: (value) => validateName(context, value),
            controller: signupCubit.nameController,
          ),
          verticalSpace(20),
          CustomTextField(
            title: 'Email',
            hintText: 'Enter your email',
            iconData: Icons.email,
            validator: (value) => validateEmail(context, value),
            controller: signupCubit.emailController,
          ),
          verticalSpace(20),
          CustomTextField(
            title: 'Password',
            hintText: 'Enter your password',
            iconData: Icons.lock,
            isPassword: true,
            validator: (value) => validatePassword(context, value),
            controller: signupCubit.passwordController,
          ),
          verticalSpace(20),
          CustomButton(
            text: 'Sign Up',
            textStyle: AppStyles.font16w600White,
            backgroundColor: AppColors.primary,
            onPressed: () {
              validateThenDoSignup(context, signupCubit);
            },
          ),
        ],
      ),
    );
  }
}

void validateThenDoSignup(BuildContext context, SignupCubit signupCubit) async {
  bool formIsValid = signupCubit.signupFormKey.currentState!.validate();

  if (!formIsValid) {
    return;
  }

  signupCubit.signupFormKey.currentState!.save();

  await signupCubit.signup();
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/core/widgets/custom_button.dart';
import 'package:trakify/core/widgets/custom_text_field.dart';
import 'package:trakify/features/change_password/logic/profile_cubit.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/helpers/validation.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    ChangePasswordCubit changePasswordCubit =
        context.read<ChangePasswordCubit>();

    return Form(
      key: changePasswordCubit.changePasswordFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: SingleChildScrollView(
        child: Column(
          children: [
            verticalSpace(5),

            CustomTextField(
              hintText: "Old Password",
              isPassword: true,
              validator: (value) => validatePassword(context, value),
              controller: changePasswordCubit.oldPasswordController,
              iconData: FontAwesomeIcons.lock,
            ),
            verticalSpace(15),
            CustomTextField(
              hintText: "New Password",
              isPassword: true,
              validator: (value) => validatePassword(context, value),
              controller: changePasswordCubit.newPasswordController,
              iconData: FontAwesomeIcons.lock,
            ),
            verticalSpace(30),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    textStyle: AppStyles.font16w500Red,
                    backgroundColor: AppColors.primaryLight,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: CustomButton(
                    text: 'Change Password',
                    textStyle: AppStyles.font16w600White,
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      validateThenDoChangePassword(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void validateThenDoChangePassword(BuildContext context) {
  if (context
      .read<ChangePasswordCubit>()
      .changePasswordFormKey
      .currentState!
      .validate()) {
    context.read<ChangePasswordCubit>().changePassword();
  }
}

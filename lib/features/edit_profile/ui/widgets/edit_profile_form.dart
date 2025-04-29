import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/helpers/validation.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/core/widgets/custom_button.dart';
import 'package:trakify/core/widgets/custom_text_field.dart';
import 'package:trakify/features/edit_profile/data/models/update_user_request_model.dart';
import 'package:trakify/features/edit_profile/logic/edit_profile_cubit.dart';
import 'package:trakify/features/login/data/models/user_model.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          CustomTextField(
            title: 'Name',
            hintText: 'Enter your name',
            iconData: Icons.person,
            validator: (value) => validateNameOptional(context, value),
            controller: cubit.nameController,
          ),
          verticalSpace(20),
          CustomTextField(
            title: 'Email',
            hintText: 'Enter your email',
            iconData: Icons.email,
            validator: (value) => validateEmailOptional(context, value),
            controller: cubit.emailController,
          ),
          verticalSpace(20),
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
                  text: 'Save Changes',
                  textStyle: AppStyles.font16w600White,
                  backgroundColor: AppColors.primary,
                  onPressed: () => _onSaveChanges(context, cubit, userModel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSaveChanges(
    BuildContext context,
    EditProfileCubit cubit,
    UserModel userModel,
  ) {
    if (cubit.formKey.currentState!.validate()) {
      final updatedName = cubit.nameController.text.trim();
      final updatedEmail = cubit.emailController.text.trim();

      final updateRequest = UpdateUserRequestModel(
        name: updatedName == userModel.name ? null : updatedName,
        email: updatedEmail == userModel.email ? null : updatedEmail,
        image: cubit.profilePic,
      );

      cubit.updateProfile(updateRequest);
    }
  }
}

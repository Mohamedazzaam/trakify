import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/widgets/bg_shape_scaffold.dart';
import 'package:trakify/core/widgets/custom_app_bar.dart';
import 'package:trakify/features/edit_profile/logic/edit_profile_cubit.dart';
import 'package:trakify/features/edit_profile/ui/widgets/edit_profile_bloc_builder.dart';
import 'package:trakify/features/edit_profile/ui/widgets/edit_profile_form.dart';
import 'package:trakify/features/login/data/models/user_model.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();

    cubit.nameController.text = userModel.name;
    cubit.emailController.text = userModel.email;

    return BgShapeScaffold(
      appBar: CustomAppBar(title: 'Edit Profile'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpace(40),
              EditProfileBlocBuilder(userModel: userModel),
              verticalSpace(40),
              EditProfileForm(userModel: userModel),
            ],
          ),
        ),
      ),
    );
  }
}

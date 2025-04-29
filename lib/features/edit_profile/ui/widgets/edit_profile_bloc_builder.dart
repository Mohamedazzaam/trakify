import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/core/di/dependency_injection.dart';
import 'package:trakify/core/widgets/custom_snack_bar.dart';
import 'package:trakify/core/widgets/loading_widget.dart';
import 'package:trakify/features/edit_profile/logic/edit_profile_cubit.dart';
import 'package:trakify/features/edit_profile/ui/widgets/profile_image.dart';
import 'package:trakify/features/login/data/models/user_model.dart';

class EditProfileBlocBuilder extends StatelessWidget {
  const EditProfileBlocBuilder({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final loadingService = getIt<LoadingWidgetService>();

    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        if (state is EditProfileLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            loadingService.showLoadingOverlay(context);
          });
        } else if (state is EditProfileFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            loadingService.hideLoading();
            customSnackBar(context, state.errorMessage);
          });
        } else if (state is EditProfileSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            loadingService.hideLoading();
            customSnackBar(context, 'Profile updated successfully!');
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            loadingService.hideLoading();
          });
        }

        return ProfileImage(userModel: userModel);
      },
    );
  }
}

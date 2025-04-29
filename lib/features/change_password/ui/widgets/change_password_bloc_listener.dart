import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/features/change_password/logic/profile_cubit.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../../core/widgets/loading_widget.dart';

class ChangePasswordBlocListener extends StatelessWidget {
  const ChangePasswordBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingService = getIt<LoadingWidgetService>();
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordLoading) {
          loadingService.showLoadingOverlay(context);
        }
        if (state is ChangePasswordSuccess) {
          loadingService.hideLoading();
          customSnackBar(context, state.success);
          context.pop();
        } else if (state is ChangePasswordFailure) {
          loadingService.hideLoading();
          customSnackBar(context, state.errorMessage);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}

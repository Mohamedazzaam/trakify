import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/features/signup/logic/cubit/signup_cubit.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../../core/widgets/loading_widget.dart';

class SignupBlocListener extends StatelessWidget {
  const SignupBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingService = getIt<LoadingWidgetService>();
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupLoading) {
          loadingService.showLoadingOverlay(context);
        }
        if (state is SignupSuccess) {
          loadingService.hideLoading();
          customSnackBar(context, 'Signup successful!');
          context.pop();
        } else if (state is SignupFailure) {
          loadingService.hideLoading();
          customSnackBar(context, state.message);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}

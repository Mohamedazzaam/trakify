import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/core/constants/app_constants.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../logic/login_cubit.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingService = getIt<LoadingWidgetService>();
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          loadingService.showLoadingOverlay(context);
        }
        if (state is LoginSuccess) {
          loadingService.hideLoading();
          customSnackBar(context, "User logged in successfully!");
          getIt<CacheHelper>().saveData(
            key: AppConstants.isUserLoggedIn,
            value: true,
          );
          context.pushReplacementNamed(Routes.bottomNavScaffold);
        } else if (state is LoginFailure) {
          loadingService.hideLoading();
          customSnackBar(context, state.errorMessage);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}

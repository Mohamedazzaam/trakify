import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/core/di/dependency_injection.dart';
import 'package:trakify/core/widgets/bottom_nav_bar.dart';
import 'package:trakify/features/add_habit/ui/add_habit_screen.dart';
import 'package:trakify/features/change_password/logic/profile_cubit.dart';
import 'package:trakify/features/change_password/ui/change_password_screen.dart';
import 'package:trakify/features/edit_profile/logic/edit_profile_cubit.dart';
import 'package:trakify/features/edit_profile/ui/edit_profile_screen.dart';
import 'package:trakify/features/login/data/models/user_model.dart';
import 'package:trakify/features/login/logic/login_cubit.dart';
import 'package:trakify/features/login/ui/login_screen.dart';
import 'package:trakify/features/onboarding/ui/onboarding_screen.dart';
import 'package:trakify/features/signup/logic/cubit/signup_cubit.dart';
import 'package:trakify/features/signup/ui/signup_screen.dart';

import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<LoginCubit>(),
                child: const LoginScreen(),
              ),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<SignupCubit>(),
                child: const SignupScreen(),
              ),
        );
      case Routes.bottomNavScaffold:
        return MaterialPageRoute(
          builder: (context) => const BottomNavScaffold(),
        );
      case Routes.addHabitScreen:
        return MaterialPageRoute(builder: (context) => const AddHabitScreen());
      case Routes.editProfile:
        arguments as UserModel;
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<EditProfileCubit>(),
                child: EditProfileScreen(userModel: arguments),
              ),
        );
      case Routes.changePassword:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<ChangePasswordCubit>(),
                child: const ChangePasswordScreen(),
              ),
        );
    }
    return null;
  }
}

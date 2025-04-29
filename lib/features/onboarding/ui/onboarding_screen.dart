import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakify/core/cache/cache_helper.dart';
import 'package:trakify/core/constants/app_constants.dart';
import 'package:trakify/core/di/dependency_injection.dart';
import 'package:trakify/core/helpers/extensions.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/routing/routes.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/features/onboarding/ui/widgets/onboarding_body.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpace(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => visitedAndRoute(context),
                    child: Text('Skip', style: AppStyles.font20w600Black),
                  ),
                ],
              ),
              Spacer(),
              OnBoardingBody(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

void visitedAndRoute(BuildContext context) {
  getIt<CacheHelper>().saveData(
    key: AppConstants.isOnBoardingVisited,
    value: true,
  );
  context.pushReplacementNamed(Routes.loginScreen);
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakify/core/cache/cache_helper.dart';
import 'package:trakify/core/constants/app_constants.dart';
import 'package:trakify/core/di/dependency_injection.dart';
import 'package:trakify/core/helpers/extensions.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/routing/routes.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/core/widgets/custom_button.dart';
import 'package:trakify/features/onboarding/data/onboarding_data_list.dart';
import 'package:trakify/features/onboarding/ui/widgets/onboarding_cards_pageview.dart';
import 'package:trakify/features/onboarding/ui/widgets/onboarding_indecator.dart';

class OnBoardingBody extends StatefulWidget {
  const OnBoardingBody({super.key});

  @override
  State<OnBoardingBody> createState() => _OnBoardingBodyState();
}

class _OnBoardingBodyState extends State<OnBoardingBody> {
  final PageController pageController = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OnboardingCardsPageview(
          pageController: pageController,
          onboardingDataList: onboardingDataList,
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
        OnBoardingIndecator(pageController: pageController),
        verticalSpace(40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20.w,
          children: [
            Expanded(
              child:
                  currentPageIndex > 0
                      ? CustomButton(
                        text: 'Previous',
                        textStyle: AppStyles.font16w600Primary,
                        backgroundColor: AppColors.primaryLight,
                        onPressed: onPreviousClick,
                      )
                      : SizedBox.shrink(),
            ),
            Expanded(
              child: CustomButton(
                text: 'Next',
                textStyle: AppStyles.font16w600White,
                backgroundColor: AppColors.primary,
                onPressed: onNextClick,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onNextClick() {
    if (currentPageIndex == onboardingDataList.length - 1) {
      visitedAndRoute(context);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void onPreviousClick() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
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

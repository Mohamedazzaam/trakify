import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/features/onboarding/data/onboarding_data_list.dart';

class OnBoardingIndecator extends StatelessWidget {
  const OnBoardingIndecator({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: onboardingDataList.length,
      effect: ScaleEffect(
        activeDotColor: AppColors.primary,
        dotColor: AppColors.primaryLight,
        dotHeight: 16.sp,
        dotWidth: 16.sp,
      ),
      onDotClicked: (index) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      },
    );
  }
}

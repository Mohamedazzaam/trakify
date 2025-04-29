import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakify/features/onboarding/data/models/onboarding_card_model.dart';
import 'package:trakify/features/onboarding/ui/widgets/onboarding_card.dart';

class OnboardingCardsPageview extends StatelessWidget {
  const OnboardingCardsPageview({
    super.key,
    required this.pageController,
    required this.onboardingDataList,
    this.onPageChanged,
  });

  final PageController pageController;
  final List<OnboardingCardModel> onboardingDataList;
  final Function(int)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: PageView.builder(
        itemCount: onboardingDataList.length,
        itemBuilder: (context, index) {
          return OnBoardingCard(
            imagePath: onboardingDataList[index].imagePath,
            title: onboardingDataList[index].title,
            description: onboardingDataList[index].description,
          );
        },
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}

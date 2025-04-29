import 'package:trakify/core/constants/assets.dart';
import 'package:trakify/features/onboarding/data/models/onboarding_card_model.dart';

final List<OnboardingCardModel> onboardingDataList = [
  OnboardingCardModel(
    title: 'Start Your Journey to Better Habits',
    description: 'Our app helps you achieve your daily goals effortlessly',
    imagePath: Assets.imagesOnboardingOnboarding1,
  ),
  OnboardingCardModel(
    title: 'Track Your Progress with Ease',
    description:
        'Log your daily habits and monitor your growth with a simple interface',
    imagePath: Assets.imagesOnboardingOnboarding2,
  ),
  OnboardingCardModel(
    title: 'Stay Motivated and Reminded',
    description: 'Get smart reminders and see your achievements at a glance',
    imagePath: Assets.imagesOnboardingOnboarding3,
  ),
];

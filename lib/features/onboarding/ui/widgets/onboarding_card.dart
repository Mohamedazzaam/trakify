import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/theming/app_styles.dart';

class OnBoardingCard extends StatelessWidget {
  const OnBoardingCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });
  final String imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 236.w, height: 236.h),
        Text(title, style: AppStyles.font20w600Black),
        verticalSpace(20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            description,
            style: AppStyles.font16w500Black,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

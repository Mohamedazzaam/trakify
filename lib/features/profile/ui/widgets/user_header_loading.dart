import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';

class UserHeaderLoading extends StatelessWidget {
  const UserHeaderLoading({super.key});
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 80.r,
            backgroundColor: Colors.grey[200],
            child: FaIcon(
              FontAwesomeIcons.user,
              color: AppColors.primary,
              size: 25.sp,
            ),
          ),
          verticalSpace(20),
          Text('User Name', style: AppStyles.font24w600Black),
        ],
      ),
    );
  }
}

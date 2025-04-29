import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trakify/core/helpers/extensions.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/routing/routes.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/core/widgets/custom_snack_bar.dart';
import 'package:trakify/features/profile/logic/profile_cubit.dart';
import 'package:trakify/features/profile/ui/widgets/logout_dialog.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.title,
    this.textStyle,
    required this.icon,
    required this.routeName,
    this.onTap,
  });

  final String title;
  final TextStyle? textStyle;
  final IconData icon;
  final String routeName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _handleOnTap(context),
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(15).r,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              FaIcon(icon, color: AppColors.primary, size: 25.sp),
              horizontalSpace(10),
              Text(title, style: textStyle ?? AppStyles.font16w500Black),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOnTap(BuildContext context) {
    if (routeName == Routes.editProfile) {
      final profileCubit = context.read<ProfileCubit>();
      final state = profileCubit.state;
      if (state is GetProfleDataSuccess) {
        context.pushNamed(routeName, arguments: state.userResponseModel);
      } else {
        customSnackBar(context, 'Profile data not loaded');
      }
    } else if (routeName == Routes.changePassword) {
      context.pushNamed(routeName);
    } else if (routeName == Routes.loginScreen) {
      logoutDialog(context);
    }
  }
}

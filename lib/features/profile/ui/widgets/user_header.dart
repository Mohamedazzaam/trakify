import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/features/login/data/models/user_model.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key, required this.userResponseModel});
  final UserModel userResponseModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        userResponseModel.image != null
            ? CircleAvatar(
              radius: 80.r,
              backgroundImage: CachedNetworkImageProvider(
                userResponseModel.image!,
              ),
            )
            : CircleAvatar(
              radius: 80.r,
              backgroundColor: Colors.grey[200],
              child: FaIcon(
                FontAwesomeIcons.user,
                color: AppColors.primary,
                size: 25.sp,
              ),
            ),
        verticalSpace(20),
        Text(userResponseModel.name, style: AppStyles.font24w600Black),
      ],
    );
  }
}

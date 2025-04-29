import 'package:flutter/material.dart';
import 'package:trakify/core/helpers/extensions.dart';
import 'package:trakify/core/networking/api/user_data.dart';
import 'package:trakify/core/routing/routes.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/core/widgets/custom_snack_bar.dart';

Future<dynamic> logoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.primaryLight,
        title: Text('Logout', style: AppStyles.font24w600Black),
        content: Text(
          'Are you sure you want to logout?',
          style: AppStyles.font16w500Black,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppStyles.font16w500Black),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await removeUserData();
              if (context.mounted) {
                context.pushNamed(Routes.loginScreen);
                customSnackBar(context, 'Logout successful');
              }
            },
            child: Text('Logout', style: AppStyles.font16w500Red),
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';

void customSnackBar(BuildContext context, String message) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text(message, style: AppStyles.font16w600White),
        ),
      );
  });
}

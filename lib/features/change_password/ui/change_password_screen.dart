import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/core/widgets/bg_shape_scaffold.dart';
import 'package:trakify/core/widgets/custom_app_bar.dart';
import 'package:trakify/features/change_password/ui/widgets/change_password_bloc_listener.dart';
import 'package:trakify/features/change_password/ui/widgets/change_password_form.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BgShapeScaffold(
      appBar: CustomAppBar(title: 'Change Password'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
          child: Column(
            children: [
              verticalSpace(100),
              Text(
                'Secure your account by updating your password.',
                style: AppStyles.font20w600Black,
              ),
              const ChangePasswordForm(),
              const ChangePasswordBlocListener(),
            ],
          ),
        ),
      ),
    );
  }
}

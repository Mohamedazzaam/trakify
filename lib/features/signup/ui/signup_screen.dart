import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakify/core/constants/assets.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/widgets/auth_message_and_navigate.dart';
import 'package:trakify/core/widgets/bg_shape_scaffold.dart';
import 'package:trakify/features/signup/ui/widgets/signup_bloc_listener.dart';
import 'package:trakify/features/signup/ui/widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BgShapeScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.imagesLogoFullLogo),
                verticalSpace(20),
                const SignupForm(),

                verticalSpace(10),
                AuthMessageAndNavigate(authMessageType: AuthMessageType.signup),
                const SignupBlocListener(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:trakify/core/theming/app_styles.dart';

import '../helpers/extensions.dart';
import '../routing/routes.dart';

enum AuthMessageType { login, signup }

class AuthMessageAndNavigate extends StatelessWidget {
  const AuthMessageAndNavigate({super.key, required this.authMessageType});
  final AuthMessageType authMessageType;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text:
                authMessageType == AuthMessageType.login
                    ? "don't have an account?"
                    : 'already have an account?',
            style: AppStyles.font16w500Black,
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: InkWell(
              onTap:
                  () =>
                      authMessageType == AuthMessageType.login
                          ? context.pushNamed(Routes.signUpScreen)
                          : context.pop(),
              child: Text(
                ' ${authMessageType == AuthMessageType.login ? 'sign up' : 'login'}',
                style: AppStyles.font16w600Primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

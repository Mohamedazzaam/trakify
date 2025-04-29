import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/routing/routes.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/features/profile/data/models/profile_button_data_model.dart';
import 'package:trakify/features/profile/ui/widgets/profile_button.dart';

class ProfileButtonsListView extends StatelessWidget {
  const ProfileButtonsListView({super.key, this.onEditProfileTap});

  final VoidCallback? onEditProfileTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: profileButtons.length,
      itemBuilder: (context, index) {
        final button = profileButtons[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileButton(
              title: button.title,
              icon: button.icon,
              textStyle: button.textStyle,
              routeName: button.routeName,
              onTap:
                  button.routeName == Routes.editProfile
                      ? onEditProfileTap
                      : null,
            ),
            verticalSpace(20),
          ],
        );
      },
    );
  }
}

List<ProfileButtonDataModel> profileButtons = [
  ProfileButtonDataModel(
    title: 'Edit Profile',
    icon: FontAwesomeIcons.penToSquare,
    routeName: Routes.editProfile,
    textStyle: null,
  ),
  ProfileButtonDataModel(
    title: 'Change Password',
    icon: FontAwesomeIcons.lock,
    routeName: Routes.changePassword,
    textStyle: null,
  ),
  ProfileButtonDataModel(
    title: 'Logout',
    icon: FontAwesomeIcons.rightFromBracket,
    textStyle: AppStyles.font16w500Red,
    routeName: Routes.loginScreen,
  ),
];

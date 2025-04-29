import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/features/edit_profile/logic/edit_profile_cubit.dart';
import 'package:trakify/features/login/data/models/user_model.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.userModel});
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 80.r,
          backgroundColor: Colors.grey[200],
          backgroundImage:
              cubit.profilePic != null
                  ? FileImage(File(cubit.profilePic!.path)) as ImageProvider
                  : userModel.image != null
                  ? NetworkImage(userModel.image!)
                  : null,
          child:
              (cubit.profilePic == null && userModel.image == null)
                  ? FaIcon(
                    FontAwesomeIcons.user,
                    color: AppColors.primary,
                    size: 25.sp,
                  )
                  : null,
        ),
        GestureDetector(
          onTap: () async {
            final pickedFile = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (pickedFile != null && context.mounted) {
              cubit.uploadProfileImage(pickedFile);
            }
          },
          child: CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.camera_alt, color: Colors.white, size: 20.sp),
          ),
        ),
      ],
    );
  }
}

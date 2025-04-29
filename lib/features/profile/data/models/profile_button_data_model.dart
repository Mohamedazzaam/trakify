import 'package:flutter/widgets.dart';

class ProfileButtonDataModel {
  final String title;
  final IconData icon;
  final TextStyle? textStyle;
  final String routeName;

  ProfileButtonDataModel({
    required this.title,
    required this.icon,
    this.textStyle,
    required this.routeName,
  });
}

import 'package:flutter/material.dart';
import 'package:trakify/core/theming/app_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.backgroundColor = Colors.transparent,
    this.elevation = 0,
    this.automaticallyImplyLeading = false,
  });

  final String title;
  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(child: Text(title, style: AppStyles.font24w600Black)),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

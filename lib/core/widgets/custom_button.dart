import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/spacing.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.textStyle,
    required this.backgroundColor,
    required this.onPressed,
    this.icon,
  });

  final String text;
  final Color backgroundColor;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: backgroundColor,
      elevation: 0,
      minWidth: 10.w,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      highlightElevation: 0,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, horizontalSpace(10)],
          Text(text, style: textStyle),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../features/areas/ui/area_screen.dart';

class AreaListTile extends StatelessWidget {
  const AreaListTile({
    super.key,
    required this.areaLeadingIcon,
    this.areaTrailingIcon,
    required this.leadingIconColor,
    this.trailingIconColor,
    required this.cardColor,
    required this.titleColor,
    required this.subTitleColor,
    required this.title,
    required this.subTitle,
    this.onTap,
    required this.enable, // أضف هذه الخاصية
  });

  final String title;
  final String subTitle;
  final IconData areaLeadingIcon;
  final IconData? areaTrailingIcon;
  final Color leadingIconColor;
  final Color? trailingIconColor;
  final Color cardColor;
  final Color titleColor;
  final Color subTitleColor;
  final bool enable;
  final VoidCallback? onTap; // أضف هذه الخاصية

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          enable
              ? (onTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AreaScreen(
                              title: title,
                              subTitle: subTitle,
                              areaLeadingIcon: areaLeadingIcon,
                            ),
                      ),
                    );
                  })
              : null,

      child: Card(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(areaLeadingIcon, color: leadingIconColor),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(subTitle, style: TextStyle(color: subTitleColor)),
          trailing:
              areaTrailingIcon != null
                  ? Icon(
                    areaTrailingIcon,
                    color: trailingIconColor ?? Colors.black,
                  )
                  : null,
        ),
      ),
    );
  }
}

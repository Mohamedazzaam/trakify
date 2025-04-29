import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:trakify/core/theming/app_colors.dart';

import '../constants/assets.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100.w,
        height: 90.h,
        color: AppColors.bgDarklow,
        child: Lottie.asset(
          Assets.animationLoading,
          reverse: true,
          repeat: true,
        ),
      ),
    );
  }
}

class LoadingWidgetService {
  OverlayEntry? _overlayEntry;

  void showLoadingOverlay(BuildContext context) {
    if (_overlayEntry == null) {
      OverlayState overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder:
            (context) => const Material(
              color: Colors.transparent,
              child: Center(child: LoadingWidget()),
            ),
      );

      overlayState.insert(_overlayEntry!);
    }
  }

  void hideLoading() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

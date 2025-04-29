import 'package:flutter/material.dart';
import 'package:trakify/core/constants/assets.dart';
import 'package:trakify/core/theming/app_colors.dart';

class BgShapeScaffold extends StatelessWidget {
  const BgShapeScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return BgShape(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

class BgShape extends StatelessWidget {
  const BgShape({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Container(color: AppColors.white),
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(Assets.imagesShapesTop),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(Assets.imagesShapesBottom),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

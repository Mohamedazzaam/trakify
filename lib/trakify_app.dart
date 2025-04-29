import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakify/core/constants/app_constants.dart';
import 'package:trakify/core/constants/app_fonts.dart';
import 'package:trakify/core/routing/app_router.dart';
import 'package:trakify/core/theming/app_colors.dart';

class TrakifyApp extends StatelessWidget {
  const TrakifyApp({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });
  final AppRouter appRouter;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          fontFamily: AppFonts.ibmPlexSans,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: initialRoute,
      ),
    );
  }
}

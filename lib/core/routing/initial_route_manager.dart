import 'package:trakify/core/constants/app_constants.dart';

import '../cache/cache_helper.dart';
import '../di/dependency_injection.dart';
import 'routes.dart';

class InitialRouteManager {
  static Future<String> determineInitialRoute() async {
    final isUserLoggedIn =
        await getIt<CacheHelper>().getData(key: AppConstants.isUserLoggedIn) ??
        false;
    final isOnBoardingVisited =
        await getIt<CacheHelper>().getData(
          key: AppConstants.isOnBoardingVisited,
        ) ??
        false;

    if (isUserLoggedIn) {
      return Routes.bottomNavScaffold;
    } else if (isOnBoardingVisited) {
      return Routes.loginScreen;
    } else {
      return Routes.onBoardingScreen;
    }
  }
}

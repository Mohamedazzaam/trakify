import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trakify/core/di/dependency_injection.dart';
import 'package:trakify/core/routing/app_router.dart';
import 'package:trakify/core/routing/initial_route_manager.dart';
import 'package:trakify/trakify_app.dart';

import 'features/add_habit/data/models/habit_model.dart';
import 'features/areas/data/models/area_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive
  await Hive.initFlutter();

  // تسجيل محول Habit
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(AreaAdapter()); // أضف هذا السطر

  // فتح صندوق لتخزين العادات
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<Area>('areas'); // أضف هذا السطر

  await setupGetIt();
  String initialRoute = await InitialRouteManager.determineInitialRoute();

  // To fix texts being hidden bug in flutter_screenutil in release mode.
  await ScreenUtil.ensureScreenSize();

  runApp(TrakifyApp(appRouter: AppRouter(), initialRoute: initialRoute));
}

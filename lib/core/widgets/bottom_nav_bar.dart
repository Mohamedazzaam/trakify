import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trakify/core/di/dependency_injection.dart';
import 'package:trakify/core/helpers/extensions.dart';
import 'package:trakify/core/helpers/spacing.dart';
import 'package:trakify/core/routing/routes.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/theming/app_styles.dart';
import 'package:trakify/features/areas/ui/areas_screen.dart';
import 'package:trakify/features/home/ui/home_screen.dart';
import 'package:trakify/features/profile/logic/profile_cubit.dart';
import 'package:trakify/features/profile/ui/profile_screen.dart';
import 'package:trakify/features/progress/ui/progress_screen.dart';

class BottomNavScaffold extends StatefulWidget {
  const BottomNavScaffold({super.key});
  @override
  State<BottomNavScaffold> createState() => _BottomNavScaffoldState();
}

class _BottomNavScaffoldState extends State<BottomNavScaffold> {
  int _bottomNavIndex = 0;

  // إنشاء مكون مخصص لعناصر التنقل
  Widget _buildNavItem(IconData icon, String label, Color color) {
    return SizedBox(
      height: 50.h, // تحديد ارتفاع ثابت
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // توسيط العناصر عموديًا
        children: [
          FaIcon(icon, size: 20.sp, color: color),
          SizedBox(height: 3.h), // تقليل المسافة العمودية
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: color),
            overflow: TextOverflow.ellipsis, // قطع النص إذا كان طويلًا
          ),
        ],
      ),
    );
  }

  final List<Widget> pageList = [
    HabitsScreen(),
    AreasScreen(),
    ProgressScreen(),
    BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getProfileData(),
      child: const ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(Routes.addHabitScreen),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30).r,
        ),
        child: Icon(Icons.add, size: 30.sp, color: AppColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        height: 85.h, // زيادة الارتفاع قليلاً
        splashColor: Colors.transparent,
        splashRadius: 0,
        scaleFactor: 0.2,
        splashSpeedInMilliseconds: 0,
        backgroundColor: AppColors.primary,
        itemCount: 4, // عدد عناصر التنقل
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        activeIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? AppColors.white : AppColors.bgDarklow;

          // استخدام دالة إنشاء عناصر التنقل المخصصة
          String label;
          IconData icon;

          switch (index) {
            case 0:
              label = 'Home';
              icon = FontAwesomeIcons.house;
              break;
            case 1:
              label = 'Areas';
              icon = FontAwesomeIcons.layerGroup;
              break;
            case 2:
              label = 'Progress';
              icon = FontAwesomeIcons.squarePollVertical;
              break;
            case 3:
              label = 'Profile';
              icon = FontAwesomeIcons.user;
              break;
            default:
              label = '';
              icon = FontAwesomeIcons.house;
          }

          return Padding(
            padding: EdgeInsets.only(top: 10.h), // تقليل المساحة العلوية
            child: _buildNavItem(icon, label, color),
          );
        },
      ),
    );
  }
}

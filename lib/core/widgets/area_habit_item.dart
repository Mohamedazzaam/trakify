import 'package:flutter/material.dart';
import 'package:trakify/core/theming/app_colors.dart';
import '../../../features/add_habit/data/models/habit_model.dart';

class AreaHabitItem extends StatelessWidget {
  const AreaHabitItem({
    super.key,
    required this.title,
    required this.areaLeadingIcon,
    required this.habit,
    this.onMenuPressed,
  });

  final String title;
  final IconData areaLeadingIcon;
  final Habit habit;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffDDEDE8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(habit.icon, color: Color(0xff1B8466)),
                const SizedBox(width: 6),
                Text(
                  habit.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.menu_rounded),
                  onPressed: onMenuPressed,
                ),
              ],
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 32,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xffFFF4B5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          areaLeadingIcon,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 5),
                        Text(title, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Container(
                    height: 24,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffFFF4B5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.repeat, size: 14, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          _getRepeatText(habit),
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // إضافة معلومات التكرار
          ],
        ),
      ),
    );
  }

  // تحويل نوع التكرار إلى نص مقروء
  String _getRepeatText(Habit habit) {
    switch (habit.repeatType) {
      case 'Daily':
        return 'Daily ${habit.selectedDays.join(", ")}';
      case 'Weekly':
        return 'Weekly (${habit.repeatNumber ?? 1} times)';
      case 'Monthly':
        return 'Monthly (${habit.repeatNumber ?? 1} times)';
      default:
        return habit.repeatType;
    }
  }
}

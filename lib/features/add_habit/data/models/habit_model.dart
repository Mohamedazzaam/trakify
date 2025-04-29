import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 0) // معرف فريد لنوع الكائن
class Habit extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int iconCodePoint; // نخزن رقم الرمز بدلاً من IconData

  @HiveField(3)
  late String iconFontFamily; // نخزن اسم عائلة الخط

  @HiveField(4)
  late String repeatType;

  @HiveField(5)
  late List<String> selectedDays;

  @HiveField(6)
  int? repeatNumber;

  @HiveField(7)
  late bool dailyNotification;

  @HiveField(8)
  late List<String> reminderTimes; // نخزن الأوقات كسلاسل نصية

  @HiveField(9)
  late String area;

  // منشئ فارغ لاستخدامه مع Hive
  Habit();

  // منشئ مع بيانات
  Habit.create({
    required this.id,
    required this.name,
    required IconData icon,
    required this.repeatType,
    required this.selectedDays,
    this.repeatNumber,
    required this.dailyNotification,
    required List<TimeOfDay> reminderTimes,
    required this.area,
  }) {
    this.iconCodePoint = icon.codePoint;
    this.iconFontFamily = icon.fontFamily ?? '';
    this.reminderTimes =
        reminderTimes.map((time) => "${time.hour}:${time.minute}").toList();
  }

  // طريقة مساعدة لتحويل البيانات المخزنة إلى IconData
  IconData get icon => IconData(
    iconCodePoint,
    fontFamily: iconFontFamily.isEmpty ? null : iconFontFamily,
  );

  // طريقة مساعدة لتحويل سلاسل الوقت إلى كائنات TimeOfDay
  List<TimeOfDay> get timeOfDayReminderTimes {
    return reminderTimes.map((timeString) {
      final parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();
  }
}

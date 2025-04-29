// lib/features/add_habit/data/models/habit_model.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int iconCodePoint;

  @HiveField(3)
  late String iconFontFamily;

  @HiveField(4)
  late String repeatType;

  @HiveField(5)
  late List<String> selectedDays;

  @HiveField(6)
  int? repeatNumber;

  @HiveField(7)
  late bool dailyNotification;

  @HiveField(8)
  late List<String> reminderTimes;

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
}

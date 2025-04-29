import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'area_model.g.dart';

@HiveType(typeId: 1) // معرف فريد مختلف عن Habit
class Area extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String subTitle;

  @HiveField(3)
  late int iconCodePoint; // نخزن رقم الرمز بدلاً من IconData

  @HiveField(4)
  late String iconFontFamily; // نخزن اسم عائلة الخط

  @HiveField(5)
  late int colorValue; // لون البطاقة

  // منشئ فارغ لاستخدامه مع Hive
  Area();

  // منشئ مع بيانات
  Area.create({
    required this.id,
    required this.title,
    required this.subTitle,
    required IconData icon,
    Color color = const Color(0xFFDDEDE8), // لون افتراضي
  }) {
    this.iconCodePoint = icon.codePoint;
    this.iconFontFamily = icon.fontFamily ?? '';
    this.colorValue = color.value;
  }

  // طريقة مساعدة لتحويل البيانات المخزنة إلى IconData
  IconData get icon => IconData(
    iconCodePoint,
    fontFamily: iconFontFamily.isEmpty ? null : iconFontFamily,
  );

  // طريقة مساعدة للحصول على اللون
  Color get color => Color(colorValue);

  // تحديث عنوان فرعي (مثلاً لتعكس عدد العادات)
  void updateSubtitle(String newSubtitle) {
    subTitle = newSubtitle;
  }
}

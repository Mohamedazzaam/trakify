import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/area_model.dart';
import '../../../add_habit/data/models/habit_model.dart';

class AreaRepository {
  // الحصول على المربع الخاص بالمناطق
  Box<Area> get _areaBox => Hive.box<Area>('areas');

  // الحصول على المربع الخاص بالعادات
  Box<Habit> get _habitBox => Hive.box<Habit>('habits');

  // جلب جميع المناطق
  List<Area> getAllAreas() {
    return _areaBox.values.toList();
  }

  // إضافة منطقة جديدة
  Future<void> addArea(Area area) async {
    await _areaBox.put(area.id, area);
  }

  // تحديث منطقة
  Future<void> updateArea(Area area) async {
    await area.save();
  }

  // حذف منطقة
  Future<void> deleteArea(String id) async {
    await _areaBox.delete(id);
  }

  // جلب منطقة حسب المعرّف
  Area? getAreaById(String id) {
    return _areaBox.get(id);
  }

  // الحصول على جميع العادات المرتبطة بمنطقة معينة
  List<Habit> getHabitsByArea(String areaId) {
    return _habitBox.values.where((habit) => habit.area == areaId).toList();
  }

  // تحديث عدد العادات في المنطقة
  Future<void> updateAreaHabitsCount(String areaId) async {
    final area = getAreaById(areaId);
    if (area != null) {
      final habitCount = getHabitsByArea(areaId).length;
      area.subTitle = '$habitCount Habits';
      await updateArea(area);
    }
  }

  // الحصول على أسماء جميع المناطق للاستخدام في القائمة المنسدلة
  List<String> getAreaNames() {
    return _areaBox.values.map((area) => area.title).toList();
  }

  // الحصول على معرّف المنطقة من خلال الاسم
  String? getAreaIdByName(String name) {
    final area = _areaBox.values.firstWhere(
      (area) => area.title == name,
      orElse: () => Area(),
    );
    return area.id.isEmpty ? null : area.id;
  }
}

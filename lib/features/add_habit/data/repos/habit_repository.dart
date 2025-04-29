// lib/features/add_habit/data/repos/habit_repository.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/habit_model.dart';

class HabitRepository {
  final Box<Habit> _habitsBox = Hive.box<Habit>('habits');

  // إنشاء عادة جديدة
  Future<void> createHabit({
    required String name,
    required IconData icon,
    required String repeatType,
    required List<String> selectedDays,
    int? repeatNumber,
    required bool dailyNotification,
    required List<TimeOfDay> reminderTimes,
    required String area,
  }) async {
    final habit = Habit.create(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      repeatType: repeatType,
      selectedDays: selectedDays,
      repeatNumber: repeatNumber,
      dailyNotification: dailyNotification,
      reminderTimes: reminderTimes,
      area: area,
    );

    await _habitsBox.put(habit.id, habit);
  }

  // الحصول على جميع العادات
  List<Habit> getAllHabits() {
    return _habitsBox.values.toList();
  }

  // الحصول على عادة بواسطة المعرف
  Habit? getHabitById(String id) {
    return _habitsBox.get(id);
  }

  // تحديث عادة موجودة
  Future<void> updateHabit(Habit habit) async {
    await habit.save();
  }

  // حذف عادة
  Future<void> deleteHabit(String id) async {
    await _habitsBox.delete(id);
  }
}

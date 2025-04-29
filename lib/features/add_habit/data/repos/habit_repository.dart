// lib/features/add_habit/data/repos/habit_repository.dart
import 'package:hive/hive.dart';
import '../models/habit_model.dart';

class HabitRepository {
  // Getter to access the habits box
  Box<Habit> get _habitBox => Hive.box<Habit>('habits');

  // Get all habits
  List<Habit> getAllHabits() {
    return _habitBox.values.toList();
  }

  // Add new habit
  Future<void> addHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
  }

  // Get habit by ID
  Habit? getHabitById(String id) {
    return _habitBox.get(id);
  }

  // Update existing habit
  Future<void> updateHabit(Habit habit) async {
    await habit.save();
  }

  // Delete habit
  Future<void> deleteHabit(String id) async {
    await _habitBox.delete(id);
  }

  // Get habits by area ID
  List<Habit> getHabitsByArea(String areaId) {
    return _habitBox.values.where((habit) => habit.area == areaId).toList();
  }
  // lib/features/add_habit/data/repos/habit_repository.dart

  // أضف هذه الطرق إلى فئة HabitRepository الموجودة:

  // جلب العادات حسب الفئة
  List<Habit> getHabitsByCategory(String category) {
    if (category == 'All') {
      return getAllHabits();
    }

    // في حالة الحاجة إلى فلترة حسب الفئة
    return getAllHabits()
        .where((habit) => _getHabitCategory(habit) == category)
        .toList();
  }

  // تبديل حالة إكمال العادة
  Future<void> toggleHabitCompletion(String habitId, String dateString) async {
    final box = await Hive.openBox<Map>('habit_completion');
    Map<dynamic, dynamic>? completionData = box.get(habitId);

    if (completionData == null) {
      completionData = {'dates': <String>[]};
    }

    final dates = List<String>.from(completionData['dates'] ?? []);

    if (dates.contains(dateString)) {
      dates.remove(dateString);
    } else {
      dates.add(dateString);
    }

    completionData['dates'] = dates;
    await box.put(habitId, completionData);
  }

  // تحقق هل العادة مكتملة في تاريخ معين
  bool isHabitCompletedOnDate(String habitId, String dateString) {
    final box = Hive.box<Map>('habit_completion');
    final completionData = box.get(habitId);

    if (completionData == null) {
      return false;
    }

    final dates = List<String>.from(completionData['dates'] ?? []);
    return dates.contains(dateString);
  }

  // طريقة مساعدة لتحديد فئة العادة
  String _getHabitCategory(Habit habit) {
    // يمكنك تعديل هذا حسب كيفية تخزين الفئات في تطبيقك
    if (habit.area.toLowerCase().contains('health')) return 'Health';
    if (habit.area.toLowerCase().contains('well') ||
        habit.area.toLowerCase().contains('wellbeing'))
      return 'Well Being';
    if (habit.area.toLowerCase().contains('test')) return 'Test';

    return 'All';
  }
}

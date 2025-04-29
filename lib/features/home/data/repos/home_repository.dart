// lib/features/home/data/repos/habit_tracking_repository.dart
import 'package:hive/hive.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/add_habit/data/repos/habit_repository.dart';

class HabitTrackingRepository {
  final HabitRepository habitRepository;

  HabitTrackingRepository(this.habitRepository);

  // جلب جميع العادات
  List<Habit> getAllHabits() {
    return habitRepository.getAllHabits();
  }

  // جلب العادات حسب الفئة
  List<Habit> getHabitsByCategory(String category) {
    if (category == 'All') {
      return getAllHabits();
    }

    return getAllHabits()
        .where((habit) => _getHabitCategory(habit) == category)
        .toList();
  }

  // تبديل حالة إكمال العادة
  Future<void> toggleHabitCompletion(String habitId, String dateString) async {
    try {
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
    } catch (e) {
      print('Error toggling habit completion: $e');
    }
  }

  // تحقق هل العادة مكتملة في تاريخ معين
  bool isHabitCompletedOnDate(String habitId, String dateString) {
    try {
      final box = Hive.box<Map>('habit_completion');
      final completionData = box.get(habitId);

      if (completionData == null) {
        return false;
      }

      final dates = List<String>.from(completionData['dates'] ?? []);
      return dates.contains(dateString);
    } catch (e) {
      print('Error checking habit completion: $e');
      return false;
    }
  }

  // في lib/features/home/data/repos/habit_tracking_repository.dart
  String getAreaNameById(String areaId) {
    try {
      // في حالة وجود مستودع للمناطق يمكنك الوصول إليه
      // محاولة الحصول على اسم المنطقة من قاعدة البيانات
      try {
        final areaBox = Hive.box<dynamic>('areas');
        final area = areaBox.values.firstWhere(
          (area) => area.id == areaId,
          orElse: () => null,
        );

        if (area != null) {
          return area.title;
        }
      } catch (e) {
        print('Error accessing area box: $e');
      }

      // إذا لم يتم العثور على المنطقة، نعيد اسمًا افتراضيًا بناءً على المعرف
      if (areaId.toLowerCase().contains('health')) return 'Health';
      if (areaId.toLowerCase().contains('wellbeing') ||
          areaId.toLowerCase().contains('well'))
        return 'Well Being';
      if (areaId.toLowerCase().contains('test')) return 'Test';

      return 'General'; // اسم افتراضي
    } catch (e) {
      print('Error getting area name: $e');
      return 'General';
    }
  }

  // طريقة مساعدة لتحديد فئة العادة
  String _getHabitCategory(Habit habit) {
    try {
      if (habit.area.toLowerCase().contains('health')) return 'Health';
      if (habit.area.toLowerCase().contains('well') ||
          habit.area.toLowerCase().contains('wellbeing'))
        return 'Well Being';
      if (habit.area.toLowerCase().contains('test')) return 'Test';
    } catch (e) {
      print('Error getting habit category: $e');
    }

    return 'All';
  }
}

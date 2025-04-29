// lib/features/home/data/repos/habit_tracking_repository.dart
import 'package:hive/hive.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/add_habit/data/repos/habit_repository.dart';

import '../models/habit_completion_model.dart';

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
      // استخدام الصندوق المفتوح بالفعل
      final box = Hive.box<HabitCompletionModel>('habit_completion');

      // استخدام ? للإشارة إلى أن القيمة قد تكون null
      HabitCompletionModel? completion = box.get(habitId);

      // إذا كانت القيمة null، قم بإنشاء كائن جديد
      if (completion == null) {
        completion = HabitCompletionModel(habitId: habitId);
      }

      // الآن يمكننا تنفيذ العمليات على completion لأننا تحققنا من أنه ليس null
      completion.toggleCompletion(dateString);
      await box.put(habitId, completion);
    } catch (e) {
      print('Error toggling habit completion: $e');
    }
  }

  // تحقق هل العادة مكتملة في تاريخ معين
  bool isHabitCompletedOnDate(String habitId, String dateString) {
    try {
      // عدم محاولة فتح الصندوق مرة أخرى، بل استخدام الصندوق المفتوح بالفعل
      final box = Hive.box<HabitCompletionModel>('habit_completion');

      final completion = box.get(habitId);
      if (completion == null) {
        return false;
      }

      return completion.isCompletedOnDate(dateString);
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

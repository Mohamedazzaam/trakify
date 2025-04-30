// lib/features/home/data/repos/habit_tracking_repository.dart
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/add_habit/data/repos/habit_repository.dart';

import '../../../areas/data/models/area_model.dart';
import '../models/habit_completion_model.dart';

class HabitTrackingRepository {
  final HabitRepository habitRepository;

  HabitTrackingRepository(this.habitRepository);

  // جلب جميع العادات
  List<Habit> getAllHabits() {
    return habitRepository.getAllHabits();
  }

  // جلب العادات حسب الفئة
  // في HabitTrackingRepository
  List<Habit> getHabitsByCategory(String category) {
    // إذا كان الفلتر هو "All"، أرجع كل العادات
    if (category == 'All') {
      return getAllHabits();
    }

    // جلب معرف المنطقة المقابل للاسم المحدد
    String? categoryId = getCategoryIdByName(category);

    if (categoryId == null) {
      // إذا لم يتم العثور على المنطقة، أرجع قائمة فارغة
      return [];
    }

    // فلترة العادات حسب معرف المنطقة
    return getAllHabits().where((habit) => habit.area == categoryId).toList();
  }

  // دالة مساعدة للحصول على معرف المنطقة من اسمها
  String? getCategoryIdByName(String categoryName) {
    try {
      final areaBox = Hive.box<Area>('areas');

      // طريقة 1: استخدم for loop بدلاً من firstWhere
      for (var area in areaBox.values) {
        if (area.title == categoryName) {
          return area.id;
        }
      }

      // إذا لم يتم العثور على المنطقة
      return null;
    } catch (e) {
      print('Error getting category ID: $e');
      return null;
    }
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

  bool shouldHabitBePerformedOnDate(Habit habit, DateTime date) {
    try {
      final habitCreationDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(habit.id),
      );

      // If checking a date before habit creation, always return false
      if (habitCreationDate.isAfter(date)) {
        return false;
      }

      if (habit.repeatType == 'Daily') {
        // Get the day of week code (e.g., "Sa", "Mo", etc.)
        String dayOfWeek = DateFormat('E').format(date).substring(0, 2);

        // If this day isn't selected, habit shouldn't appear
        if (!habit.selectedDays.contains(dayOfWeek)) {
          return false;
        }

        // Find the first occurrence of this day after habit creation
        DateTime firstOccurrence = habitCreationDate;

        // If creation date is already the right day, start from there
        if (DateFormat('E').format(firstOccurrence).substring(0, 2) ==
            dayOfWeek) {
          // If we're checking the creation date itself, return true
          if (isSameDay(date, habitCreationDate)) {
            return true;
          }
        } else {
          // Otherwise, move forward day by day until we find this day
          while (DateFormat('E').format(firstOccurrence).substring(0, 2) !=
              dayOfWeek) {
            firstOccurrence = firstOccurrence.add(const Duration(days: 1));
          }
        }

        // Habit only appears on the first occurrence of this day
        return isSameDay(date, firstOccurrence);
      } else if (habit.repeatType == 'Weekly') {
        // For weekly habits: show for X weeks (7 days per week) from creation
        int repeatWeeks = habit.repeatNumber ?? 1;
        int daysInPeriod = 7 * repeatWeeks;

        // Calculate end date
        DateTime endDate = habitCreationDate.add(
          Duration(days: daysInPeriod - 1),
        );

        // Show habit if date is within the time period
        return !date.isBefore(habitCreationDate) && !date.isAfter(endDate);
      } else if (habit.repeatType == 'Monthly') {
        // For monthly habits: show for X months (30 days per month) from creation
        int repeatMonths = habit.repeatNumber ?? 1;
        int daysInPeriod = 30 * repeatMonths; // Using 30 days as approximation

        // Calculate end date
        DateTime endDate = habitCreationDate.add(
          Duration(days: daysInPeriod - 1),
        );

        // Show habit if date is within the time period
        return !date.isBefore(habitCreationDate) && !date.isAfter(endDate);
      }

      return false;
    } catch (e) {
      print('Error in shouldHabitBePerformedOnDate: $e');
      return false;
    }
  }

  // Helper function to check if two dates are the same day
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

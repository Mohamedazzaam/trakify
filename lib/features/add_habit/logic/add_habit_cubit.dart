// lib/features/add_habit/logic/add_habit_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../data/repos/habit_repository.dart';
import '../data/models/habit_model.dart';
import '../../../features/areas/data/models/area_model.dart';
import 'add_habit_state.dart';

class AddHabitCubit extends Cubit<AddHabitState> {
  final HabitRepository _repository;
  List<String> areas = ['General']; // قائمة أسماء المناطق

  final List<String> days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // قائمة الأيقونات المتاحة للاختيار
  final List<IconData> availableIcons = [
    Icons.fitness_center,
    Icons.book,
    Icons.water_drop,
    Icons.medical_services,
    Icons.fastfood,
    Icons.self_improvement,
    Icons.emoji_food_beverage,
    Icons.run_circle,
    Icons.breakfast_dining,
    Icons.cleaning_services,
    Icons.flight_takeoff,
    Icons.school,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.audiotrack,
    Icons.directions_bike,
    Icons.sports_soccer,
    Icons.brightness_5,
  ];

  AddHabitCubit(this._repository) : super(AddHabitState.initial()) {
    loadAreas();
  }

  // إضافة دالة لتحميل المناطق
  Future<void> loadAreas() async {
    try {
      // فتح صندوق المناطق
      final areaBox = Hive.box<Area>('areas');

      // جلب أسماء جميع المناطق
      final areaList = areaBox.values.map((area) => area.title).toList();

      // إذا كانت هناك مناطق، استخدمها
      if (areaList.isNotEmpty) {
        areas = areaList;
      } else {
        // وإلا استخدم 'General' كمنطقة افتراضية
        areas = ['General'];
      }

      // تحديث القيمة الافتراضية للمنطقة المحددة
      if (areas.isNotEmpty) {
        emit(state.copyWith(selectedArea: areas[0]));
      }
    } catch (e) {
      print('Error loading areas: $e');
    }
  }

  // تحديث اسم العادة
  void updateHabitName(String name) {
    emit(state.copyWith(habitName: name));
  }

  // اختيار أيقونة
  void selectIcon(IconData icon) {
    emit(state.copyWith(selectedIcon: icon));
  }

  // تغيير نوع التكرار
  void changeRepeatType(String type) {
    emit(state.copyWith(repeatType: type));
  }

  // تبديل يوم محدد
  void toggleDay(String day) {
    final updatedDays = List<String>.from(state.selectedDays);

    if (updatedDays.contains(day)) {
      updatedDays.remove(day);
    } else {
      updatedDays.add(day);
    }

    emit(state.copyWith(selectedDays: updatedDays));
  }

  // اختيار رقم (للتكرار الأسبوعي/الشهري)
  void selectNumber(int number) {
    emit(state.copyWith(selectedNumber: number));
  }

  // تبديل الإشعارات اليومية
  void toggleDailyNotification(bool value) {
    emit(state.copyWith(dailyNotification: value));
  }

  // إضافة وقت تذكير
  void addReminderTime(TimeOfDay time) {
    final updatedTimes = List<TimeOfDay>.from(state.selectedTimes);
    updatedTimes.add(time);
    emit(state.copyWith(selectedTimes: updatedTimes));
  }

  // إزالة وقت تذكير
  void removeReminderTime(int index) {
    final updatedTimes = List<TimeOfDay>.from(state.selectedTimes);
    updatedTimes.removeAt(index);
    emit(state.copyWith(selectedTimes: updatedTimes));
  }

  // اختيار منطقة
  void selectArea(String area) {
    emit(state.copyWith(selectedArea: area));
  }

  // إنشاء عادة جديدة
  Future<void> createHabit() async {
    if (state.habitName.isEmpty) {
      emit(
        state.copyWith(
          status: AddHabitStatus.failure,
          errorMessage: 'Habit name cannot be empty',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AddHabitStatus.loading));

    try {
      // جلب معرف المنطقة من اسمها
      final areaBox = Hive.box<Area>('areas');
      String areaId = 'general'; // قيمة افتراضية

      try {
        // البحث عن المنطقة بالاسم
        final area = areaBox.values.firstWhere(
          (area) => area.title == state.selectedArea,
        );
        areaId = area.id;
      } catch (e) {
        // إذا لم يتم العثور على المنطقة، قم بإنشاء منطقة عامة
        if (areaBox.values.isEmpty) {
          final generalArea = Area.create(
            id: 'general',
            title: 'General',
            subTitle: '0 Habits',
            icon: Icons.category,
          );
          await areaBox.put('general', generalArea);
        }
      }

      // إنشاء كائن العادة باستخدام معرف المنطقة
      final habit = Habit.create(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: state.habitName,
        icon: state.selectedIcon,
        repeatType: state.repeatType,
        selectedDays: state.selectedDays,
        repeatNumber: state.selectedNumber,
        dailyNotification: state.dailyNotification,
        reminderTimes: state.selectedTimes,
        area: areaId, // استخدام معرف المنطقة
      );

      await _repository.addHabit(habit);

      // تحديث عدد العادات في المنطقة
      await updateAreaHabitsCount(areaId);

      emit(state.copyWith(status: AddHabitStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: AddHabitStatus.failure,
          errorMessage: 'Failed to create habit: ${e.toString()}',
        ),
      );
    }
  }

  // دالة مساعدة لتحديث عدد العادات في المنطقة
  Future<void> updateAreaHabitsCount(String areaId) async {
    try {
      final areaBox = Hive.box<Area>('areas');
      final area = areaBox.get(areaId);

      if (area != null) {
        // حساب عدد العادات في هذه المنطقة
        final habitBox = Hive.box<Habit>('habits');
        final habitsCount =
            habitBox.values.where((habit) => habit.area == areaId).length;

        // تحديث النص الفرعي
        area.subTitle = '$habitsCount Habits';
        await area.save();
      }
    } catch (e) {
      print('Error updating area habits count: $e');
    }
  }
}

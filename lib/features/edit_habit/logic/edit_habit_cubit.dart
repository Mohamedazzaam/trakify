import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../features/areas/data/models/area_model.dart';
import '../../add_habit/data/models/habit_model.dart';
import '../../add_habit/data/repos/habit_repository.dart';
import 'edit_habit_state.dart';

class EditHabitCubit extends Cubit<EditHabitState> {
  final HabitRepository _repository;
  final Habit _originalHabit;
  List<String> areas = ['General']; // List of area names
  final List<String> days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  final List<int> numbers = [1, 2, 3, 4, 5, 6];
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

  EditHabitCubit(this._repository, this._originalHabit)
    : super(EditHabitState.fromHabit(_originalHabit)) {
    loadAreas();
  }

  // Load available areas
  Future<void> loadAreas() async {
    try {
      // Open the areas box
      final areaBox = Hive.box<Area>('areas');

      // Get all area titles
      final areaList = areaBox.values.map((area) => area.title).toList();

      // If there are areas, use them
      if (areaList.isNotEmpty) {
        areas = areaList;
      } else {
        // Otherwise use 'General' as default
        areas = ['General'];
      }

      // Find the current area name
      String currentAreaName = 'General';
      for (var area in areaBox.values) {
        if (area.id == _originalHabit.area) {
          currentAreaName = area.title;
          break;
        }
      }

      // Update the selected area
      emit(state.copyWith(selectedArea: currentAreaName));
    } catch (e) {
      print('Error loading areas: $e');
    }
  }

  // Update habit name
  void updateHabitName(String name) {
    emit(state.copyWith(habitName: name));
  }

  // Select icon
  void selectIcon(IconData icon) {
    emit(state.copyWith(selectedIcon: icon));
  }

  // Change repeat type
  void changeRepeatType(String type) {
    emit(state.copyWith(repeatType: type));
  }

  // Toggle day selection
  void toggleDay(String day) {
    final updatedDays = List<String>.from(state.selectedDays);

    if (updatedDays.contains(day)) {
      updatedDays.remove(day);
    } else {
      updatedDays.add(day);
    }

    emit(state.copyWith(selectedDays: updatedDays));
  }

  // Select number for weekly/monthly repeat
  void selectNumber(int number) {
    emit(state.copyWith(selectedNumber: number));
  }

  // Toggle daily notification
  void toggleDailyNotification(bool value) {
    emit(state.copyWith(dailyNotification: value));
  }

  // Add reminder time
  void addReminderTime(TimeOfDay time) {
    final updatedTimes = List<TimeOfDay>.from(state.selectedTimes);
    updatedTimes.add(time);
    emit(state.copyWith(selectedTimes: updatedTimes));
  }

  // Remove reminder time
  void removeReminderTime(int index) {
    final updatedTimes = List<TimeOfDay>.from(state.selectedTimes);
    updatedTimes.removeAt(index);
    emit(state.copyWith(selectedTimes: updatedTimes));
  }

  // Select area
  void selectArea(String area) {
    emit(state.copyWith(selectedArea: area));
  }

  // Update habit
  Future<void> updateHabit() async {
    if (state.habitName.isEmpty) {
      emit(
        state.copyWith(
          status: EditHabitStatus.failure,
          errorMessage: 'Habit name cannot be empty',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EditHabitStatus.loading));

    try {
      // Get area ID from name
      final areaBox = Hive.box<Area>('areas');
      String areaId = 'general'; // Default value

      try {
        // Search for area by name
        final area = areaBox.values.firstWhere(
          (area) => area.title == state.selectedArea,
        );
        areaId = area.id;
      } catch (e) {
        // If area not found, create a general area
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

      // Update the existing habit with new values
      _originalHabit.name = state.habitName;
      _originalHabit.iconCodePoint = state.selectedIcon.codePoint;
      _originalHabit.iconFontFamily = state.selectedIcon.fontFamily ?? '';
      _originalHabit.repeatType = state.repeatType;
      _originalHabit.selectedDays = state.selectedDays;
      _originalHabit.repeatNumber = state.selectedNumber;
      _originalHabit.dailyNotification = state.dailyNotification;
      _originalHabit.reminderTimes =
          state.selectedTimes
              .map((time) => "${time.hour}:${time.minute}")
              .toList();
      _originalHabit.area = areaId;

      // Save updated habit
      await _repository.updateHabit(_originalHabit);

      // Update area habits count
      await updateAreaHabitsCount(areaId);

      emit(state.copyWith(status: EditHabitStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditHabitStatus.failure,
          errorMessage: 'Failed to update habit: ${e.toString()}',
        ),
      );
    }
  }

  // Helper function to update area habits count
  Future<void> updateAreaHabitsCount(String areaId) async {
    try {
      final areaBox = Hive.box<Area>('areas');
      final area = areaBox.get(areaId);

      if (area != null) {
        // Count habits in this area
        final habitBox = Hive.box<Habit>('habits');
        final habitsCount =
            habitBox.values.where((habit) => habit.area == areaId).length;

        // Update subtitle
        area.subTitle = '$habitsCount Habits';
        await area.save();
      }
    } catch (e) {
      print('Error updating area habits count: $e');
    }
  }
}

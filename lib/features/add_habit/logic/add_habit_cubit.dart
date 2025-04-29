// lib/features/add_habit/logic/add_habit_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../data/repos/habit_repository.dart';
import 'add_habit_state.dart';

class AddHabitCubit extends Cubit<AddHabitState> {
  final HabitRepository _habitRepository;

  final List<IconData> availableIcons = [
    Icons.star,
    Icons.favorite,
    Icons.book,
    Icons.self_improvement,
    Icons.restaurant,
    Icons.school,
    Icons.calendar_today,
    Icons.spa,
    Icons.work,
    Icons.bed,
    Icons.fitness_center,
    Icons.book,
    Icons.icecream,
  ];

  final List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  final List<int> numbers = [1, 2, 3, 4, 5, 6];
  final List<String> areas = ['Health', 'Work', 'Study'];

  AddHabitCubit(this._habitRepository) : super(const AddHabitState());

  void updateHabitName(String name) {
    emit(state.copyWith(habitName: name));
  }

  void selectIcon(IconData icon) {
    emit(state.copyWith(selectedIcon: icon));
  }

  void changeRepeatType(String repeatType) {
    emit(
      state.copyWith(
        repeatType: repeatType,
        selectedNumber: null,
        selectedDays: const [],
      ),
    );
  }

  void toggleDay(String day) {
    final currentDays = List<String>.from(state.selectedDays);
    if (currentDays.contains(day)) {
      currentDays.remove(day);
    } else {
      currentDays.add(day);
    }
    emit(state.copyWith(selectedDays: currentDays));
  }

  void selectNumber(int number) {
    emit(state.copyWith(selectedNumber: number));
  }

  void toggleDailyNotification(bool value) {
    emit(state.copyWith(dailyNotification: value));
  }

  void addReminderTime(TimeOfDay time) {
    final currentTimes = List<TimeOfDay>.from(state.selectedTimes);
    currentTimes.add(time);
    emit(state.copyWith(selectedTimes: currentTimes));
  }

  void removeReminderTime(int index) {
    final currentTimes = List<TimeOfDay>.from(state.selectedTimes);
    currentTimes.removeAt(index);
    emit(state.copyWith(selectedTimes: currentTimes));
  }

  void selectArea(String area) {
    emit(state.copyWith(selectedArea: area));
  }

  Future<void> createHabit() async {
    // التحقق من إدخال البيانات الضرورية
    if (state.habitName.isEmpty) {
      emit(
        state.copyWith(
          status: AddHabitStatus.failure,
          errorMessage: 'Please enter a habit name',
        ),
      );
      return;
    }

    if (state.repeatType == 'Daily' && state.selectedDays.isEmpty) {
      emit(
        state.copyWith(
          status: AddHabitStatus.failure,
          errorMessage: 'Please select at least one day',
        ),
      );
      return;
    }

    if (state.repeatType != 'Daily' && state.selectedNumber == null) {
      emit(
        state.copyWith(
          status: AddHabitStatus.failure,
          errorMessage: 'Please select a repeat number',
        ),
      );
      return;
    }

    if (state.selectedArea == null) {
      emit(
        state.copyWith(
          status: AddHabitStatus.failure,
          errorMessage: 'Please select an area',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AddHabitStatus.loading));

    try {
      // استدعاء الطريقة المحدثة في المستودع
      await _habitRepository.createHabit(
        name: state.habitName,
        icon: state.selectedIcon,
        repeatType: state.repeatType,
        selectedDays: state.selectedDays,
        repeatNumber: state.selectedNumber,
        dailyNotification: state.dailyNotification,
        reminderTimes: state.selectedTimes,
        area: state.selectedArea!,
      );

      emit(state.copyWith(status: AddHabitStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: AddHabitStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../add_habit/data/models/habit_model.dart';

enum EditHabitStatus { initial, loading, success, failure }

class EditHabitState extends Equatable {
  final String habitName;
  final IconData selectedIcon;
  final String repeatType;
  final List<String> selectedDays;
  final int? selectedNumber;
  final bool dailyNotification;
  final List<TimeOfDay> selectedTimes;
  final String? selectedArea;
  final EditHabitStatus status;
  final String? errorMessage;

  const EditHabitState({
    this.habitName = '',
    this.selectedIcon = Icons.emoji_emotions,
    this.repeatType = 'Daily',
    this.selectedDays = const [],
    this.selectedNumber,
    this.dailyNotification = true,
    this.selectedTimes = const [],
    this.selectedArea = 'General',
    this.status = EditHabitStatus.initial,
    this.errorMessage,
  });

  // Factory constructor to create state from a Habit object
  factory EditHabitState.fromHabit(Habit habit) {
    // Convert the stored reminder times (strings like "8:30") to TimeOfDay objects
    List<TimeOfDay> timeList = [];
    for (var timeStr in habit.reminderTimes) {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        try {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          timeList.add(TimeOfDay(hour: hour, minute: minute));
        } catch (e) {
          print('Invalid time format: $timeStr');
        }
      }
    }

    return EditHabitState(
      habitName: habit.name,
      selectedIcon: habit.icon, // This uses the getter that returns IconData
      repeatType: habit.repeatType,
      selectedDays: List<String>.from(habit.selectedDays),
      selectedNumber: habit.repeatNumber,
      dailyNotification: habit.dailyNotification,
      selectedTimes: timeList,
      selectedArea: null, // Will be filled by the cubit later
      status: EditHabitStatus.initial,
    );
  }

  EditHabitState copyWith({
    String? habitName,
    IconData? selectedIcon,
    String? repeatType,
    List<String>? selectedDays,
    int? selectedNumber,
    bool? dailyNotification,
    List<TimeOfDay>? selectedTimes,
    String? selectedArea,
    EditHabitStatus? status,
    String? errorMessage,
  }) {
    return EditHabitState(
      habitName: habitName ?? this.habitName,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      repeatType: repeatType ?? this.repeatType,
      selectedDays: selectedDays ?? this.selectedDays,
      selectedNumber: selectedNumber ?? this.selectedNumber,
      dailyNotification: dailyNotification ?? this.dailyNotification,
      selectedTimes: selectedTimes ?? this.selectedTimes,
      selectedArea: selectedArea ?? this.selectedArea,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    habitName,
    selectedIcon,
    repeatType,
    selectedDays,
    selectedNumber,
    dailyNotification,
    selectedTimes,
    selectedArea,
    status,
    errorMessage,
  ];
}

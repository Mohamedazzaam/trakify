// lib/presentation/habits/cubit/add_habit_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AddHabitStatus { initial, loading, success, failure }

class AddHabitState extends Equatable {
  final String habitName;
  final IconData selectedIcon;
  final String repeatType;
  final List<String> selectedDays;
  final int? selectedNumber;
  final bool dailyNotification;
  final List<TimeOfDay> selectedTimes;
  final String? selectedArea;
  final AddHabitStatus status;
  final String? errorMessage;

  const AddHabitState({
    this.habitName = '',
    this.selectedIcon = Icons.emoji_emotions,
    this.repeatType = 'Daily',
    this.selectedDays = const [],
    this.selectedNumber,
    this.dailyNotification = true,
    this.selectedTimes = const [],
    this.selectedArea = 'General', // تعيين قيمة افتراضية
    this.status = AddHabitStatus.initial,
    this.errorMessage,
  });

  AddHabitState copyWith({
    String? habitName,
    IconData? selectedIcon,
    String? repeatType,
    List<String>? selectedDays,
    int? selectedNumber,
    bool? dailyNotification,
    List<TimeOfDay>? selectedTimes,
    String? selectedArea,
    AddHabitStatus? status,
    String? errorMessage,
  }) {
    return AddHabitState(
      habitName: habitName ?? this.habitName,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      repeatType: repeatType ?? this.repeatType,
      selectedDays: selectedDays ?? this.selectedDays,
      selectedNumber: selectedNumber ?? this.selectedNumber,
      dailyNotification: dailyNotification ?? this.dailyNotification,
      selectedTimes: selectedTimes ?? this.selectedTimes,
      selectedArea: selectedArea ?? this.selectedArea,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  // طريقة لإنشاء حالة ابتدائية
  factory AddHabitState.initial() {
    return const AddHabitState(
      habitName: '',
      selectedIcon: Icons.emoji_emotions,
      repeatType: 'Daily',
      selectedDays: [],
      selectedNumber: null,
      dailyNotification: true,
      selectedTimes: [],
      selectedArea: 'General',
      status: AddHabitStatus.initial,
      errorMessage: null,
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

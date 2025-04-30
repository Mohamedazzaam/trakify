import 'package:flutter/material.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/add_habit/data/repos/habit_repository.dart';
import 'package:intl/intl.dart';
import 'package:trakify/features/home/data/repos/habit_tracking_repository.dart';

import '../../../home/data/repos/home_repository.dart';

// Model for habit statistics
class HabitStatistics {
  final int total;
  final int consistency;
  final int streak;

  HabitStatistics({
    required this.total,
    required this.consistency,
    required this.streak,
  });
}

class StatisticsViewModel extends ChangeNotifier {
  final HabitRepository _habitRepository = HabitRepository();
  final HabitTrackingRepository _trackingRepository = HabitTrackingRepository(
    HabitRepository(),
  );

  bool _isLoading = true;
  String _selectedPeriod = 'Weekly';
  List<Habit> _habits = [];

  // Overall statistics values
  int _totalHabits = 0;
  int _averagePerDay = 0;
  int _perfectDays = 0;
  int _totalStreaks = 0;

  // Individual habit statistics cache
  final Map<String, HabitStatistics> _habitStatistics = {};

  StatisticsViewModel() {
    _loadStatistics();
  }

  // Getters
  bool get isLoading => _isLoading;
  String get selectedPeriod => _selectedPeriod;
  List<Habit> get habits => _habits;
  int get totalHabits => _totalHabits;
  int get averagePerDay => _averagePerDay;
  int get perfectDays => _perfectDays;
  int get totalStreaks => _totalStreaks;

  // Change the selected period (weekly, monthly, yearly)
  Future<void> changePeriod(String period) async {
    _selectedPeriod = period;
    await _loadStatistics();
    notifyListeners();
  }

  // Get statistics for an individual habit
  HabitStatistics getHabitStatistics(String habitId) {
    // Return cached statistics if available
    if (_habitStatistics.containsKey(habitId)) {
      return _habitStatistics[habitId]!;
    }

    // Or calculate and cache them
    final startDate = _getStartDate(DateTime.now());
    final total = _calculateTotalCompletions(
      habitId,
      startDate,
      DateTime.now(),
    );
    final consistency = _calculateConsistency(
      habitId,
      startDate,
      DateTime.now(),
    );
    final streak = _calculateStreak(habitId);

    final stats = HabitStatistics(
      total: total,
      consistency: consistency,
      streak: streak,
    );

    _habitStatistics[habitId] = stats;
    return stats;
  }

  // Load all statistics
  Future<void> _loadStatistics() async {
    _isLoading = true;
    _habitStatistics.clear();
    notifyListeners();

    try {
      // Get all habits
      _habits = _habitRepository.getAllHabits();
      _totalHabits = _habits.length;

      // Get date range for analysis
      final now = DateTime.now();
      final startDate = _getStartDate(now);

      // Calculate other statistics
      final completionsPerDay = _getCompletionsPerDay(startDate, now);

      // Calculate average completions per day
      if (completionsPerDay.isNotEmpty) {
        int totalCompletions = 0;
        completionsPerDay.values.forEach((dayCompletions) {
          totalCompletions += dayCompletions;
        });
        _averagePerDay = (totalCompletions / completionsPerDay.length).round();
      } else {
        _averagePerDay = 0;
      }

      // Calculate perfect days
      _perfectDays = _calculatePerfectDays(completionsPerDay);

      // Calculate total streaks
      _totalStreaks = _habits.fold(
        0,
        (sum, habit) => sum + _calculateStreak(habit.id),
      );

      // Pre-calculate statistics for all habits
      for (final habit in _habits) {
        final total = _calculateTotalCompletions(habit.id, startDate, now);
        final consistency = _calculateConsistency(habit.id, startDate, now);
        final streak = _calculateStreak(habit.id);

        _habitStatistics[habit.id] = HabitStatistics(
          total: total,
          consistency: consistency,
          streak: streak,
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading statistics: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get start date based on selected period
  DateTime _getStartDate(DateTime now) {
    switch (_selectedPeriod) {
      case 'Weekly':
        return now.subtract(Duration(days: 7));
      case 'Monthly':
        return DateTime(now.year, now.month - 1, now.day);
      case 'Yearly':
        return DateTime(now.year - 1, now.month, now.day);
      default:
        return now.subtract(Duration(days: 7));
    }
  }

  // Get number of completions per day for all habits
  Map<String, int> _getCompletionsPerDay(DateTime startDate, DateTime endDate) {
    Map<String, int> completionsPerDay = {};

    // Iterate through each day in the range
    for (
      DateTime date = startDate;
      !date.isAfter(endDate);
      date = date.add(Duration(days: 1))
    ) {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      int completionsForDay = 0;

      // For each habit, check if it was completed on this day
      for (final habit in _habits) {
        if (_shouldHabitBePerformedOnDate(habit, date) &&
            _trackingRepository.isHabitCompletedOnDate(habit.id, dateStr)) {
          completionsForDay++;
        }
      }

      completionsPerDay[dateStr] = completionsForDay;
    }

    return completionsPerDay;
  }

  // Calculate the number of days where all habits were completed
  int _calculatePerfectDays(Map<String, int> completionsPerDay) {
    int perfectDays = 0;

    completionsPerDay.forEach((date, count) {
      // Get number of habits that should have been performed on this date
      int habitsDueOnDate = 0;
      final dateObj = DateFormat('yyyy-MM-dd').parse(date);

      for (final habit in _habits) {
        if (_shouldHabitBePerformedOnDate(habit, dateObj)) {
          habitsDueOnDate++;
        }
      }

      // If all habits due on this date were completed, it's a perfect day
      if (habitsDueOnDate > 0 && count == habitsDueOnDate) {
        perfectDays++;
      }
    });

    return perfectDays;
  }

  // Calculate current streak for a habit
  int _calculateStreak(String habitId) {
    int streak = 0;
    DateTime currentDate = DateTime.now();

    // Find the habit
    final habit = _habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => Habit(),
    );

    if (habit.id.isEmpty) return 0;

    // Check backwards day by day until we find a day the habit wasn't completed
    while (true) {
      final dateStr = DateFormat('yyyy-MM-dd').format(currentDate);

      // Check if the habit should have been performed on this date
      if (_shouldHabitBePerformedOnDate(habit, currentDate)) {
        // If the habit should have been performed but wasn't completed, break
        if (!_trackingRepository.isHabitCompletedOnDate(habitId, dateStr)) {
          break;
        }
        streak++;
      }

      // Move to previous day
      currentDate = currentDate.subtract(Duration(days: 1));

      // Set a reasonable limit to prevent infinite loops
      if (streak > 365 || currentDate.isBefore(DateTime(2020, 1, 1))) {
        break;
      }
    }

    return streak;
  }

  // Calculate total completions for a habit
  int _calculateTotalCompletions(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  ) {
    int total = 0;

    // Find the habit
    final habit = _habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => Habit(),
    );

    if (habit.id.isEmpty) return 0;

    for (
      DateTime date = startDate;
      !date.isAfter(endDate);
      date = date.add(Duration(days: 1))
    ) {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      // Only count if the habit was meant to be performed on this date
      if (_shouldHabitBePerformedOnDate(habit, date) &&
          _trackingRepository.isHabitCompletedOnDate(habitId, dateStr)) {
        total++;
      }
    }

    return total;
  }

  // Calculate consistency percentage for a habit
  int _calculateConsistency(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  ) {
    // Find the habit
    final habit = _habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => Habit(),
    );

    if (habit.id.isEmpty) return 0;

    int daysHabitShouldBePerformed = 0;
    int daysHabitWasCompleted = 0;

    for (
      DateTime date = startDate;
      !date.isAfter(endDate);
      date = date.add(Duration(days: 1))
    ) {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      // Check if habit should be performed on this date
      if (_shouldHabitBePerformedOnDate(habit, date)) {
        daysHabitShouldBePerformed++;

        // Check if it was completed
        if (_trackingRepository.isHabitCompletedOnDate(habitId, dateStr)) {
          daysHabitWasCompleted++;
        }
      }
    }

    // Calculate percentage (avoid division by zero)
    if (daysHabitShouldBePerformed == 0) return 0;

    return ((daysHabitWasCompleted / daysHabitShouldBePerformed) * 100).round();
  }

  // Determine if a habit should be performed on a specific date
  bool _shouldHabitBePerformedOnDate(Habit habit, DateTime date) {
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
          if (_isSameDay(date, habitCreationDate)) {
            return true;
          }
        } else {
          // Otherwise, move forward day by day until we find this day
          while (DateFormat('E').format(firstOccurrence).substring(0, 2) !=
              dayOfWeek) {
            firstOccurrence = firstOccurrence.add(Duration(days: 1));
          }
        }

        // Habit only appears on the first occurrence of this day
        return _isSameDay(date, firstOccurrence);
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
      print('Error in _shouldHabitBePerformedOnDate: $e');
      return false;
    }
  }

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

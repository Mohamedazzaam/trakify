// lib/features/home/ui/view_model/habit_tracking_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/home/data/repos/habit_tracking_repository.dart';
import 'package:trakify/features/areas/data/models/area_model.dart';

import '../../data/repos/home_repository.dart';

// Define AreaInfo class outside HabitTrackingViewModel
class AreaInfo {
  final String name;
  final IconData icon;
  final Color color;

  AreaInfo({required this.name, required this.icon, this.color = Colors.black});
}

class HabitTrackingViewModel extends ChangeNotifier {
  final HabitTrackingRepository _repository;

  // Current state
  DateTime _selectedDate = DateTime.now();
  DateTime _displayedMonth = DateTime.now(); // For calendar navigation
  String _selectedCategory = 'All';
  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _errorMessage;

  HabitTrackingViewModel({required HabitTrackingRepository repository})
    : _repository = repository {
    _loadHabits();
  }

  // GETTERS

  // Date related getters
  DateTime get selectedDate => _selectedDate;
  DateTime get displayedMonth => _displayedMonth;

  // Calendar specific getters
  String get currentMonthYear =>
      DateFormat('MMMM yyyy').format(_displayedMonth);

  int get daysInMonth {
    return DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
  }

  int get firstDayOfMonth {
    return DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7;
  }

  // Category and habits getters
  String get selectedCategory => _selectedCategory;
  List<Habit> get habits => _habits;
  List<Habit> get inProgressHabits =>
      _habits.where((habit) => !isHabitCompleted(habit.id)).toList();
  List<Habit> get completedHabits =>
      _habits.where((habit) => isHabitCompleted(habit.id)).toList();

  // Status getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasHabits => _habits.isNotEmpty;

  // Formatted date getters
  String get dayName => DateFormat('EEEE').format(_selectedDate);
  String get formattedDate => DateFormat('dd MMMM yyyy').format(_selectedDate);

  // Get available categories from Hive
  List<String> get availableCategories {
    final categories = ['All']; // Always start with "All"

    try {
      // Get all areas from Hive
      final areaBox = Hive.box<Area>('areas');
      final areaNames = areaBox.values.map((area) => area.title).toList();

      // Add unique area names
      for (var name in areaNames) {
        if (!categories.contains(name)) {
          categories.add(name);
        }
      }
    } catch (e) {
      print('Error getting area categories: $e');
    }

    return categories;
  }

  // CALENDAR METHODS

  // Select a specific date
  void selectDate(DateTime date) {
    _selectedDate = date;
    // If the selected date is in a different month, update displayed month
    if (date.month != _displayedMonth.month ||
        date.year != _displayedMonth.year) {
      _displayedMonth = DateTime(date.year, date.month, 1);
    }
    _loadHabits();
    notifyListeners();
  }

  // Navigate to previous month in calendar
  void previousMonth() {
    _displayedMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month - 1,
      1,
    );
    notifyListeners();
  }

  // Navigate to next month in calendar
  void nextMonth() {
    _displayedMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      1,
    );
    notifyListeners();
  }

  // Date navigation methods
  void previousDay() {
    selectDate(_selectedDate.subtract(const Duration(days: 1)));
  }

  void nextDay() {
    selectDate(_selectedDate.add(const Duration(days: 1)));
  }

  // Date validation methods
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isSelectedDate(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  // HABIT RELATED METHODS

  // Check if any habits should be performed on a date
  bool hasHabitsOnDate(DateTime date) {
    // Filter habits based on repeat type and pattern
    return _repository.getAllHabits().any(
      (habit) => shouldHabitBePerformedOnDate(habit, date),
    );
  }

  // Check if any habits were completed on a date
  bool hasCompletedHabitsOnDate(DateTime date) {
    final dateString = _formatDate(date);

    List<Habit> habitsForDate =
        _repository
            .getAllHabits()
            .where((habit) => shouldHabitBePerformedOnDate(habit, date))
            .toList();

    if (habitsForDate.isEmpty) return false;

    return habitsForDate.any(
      (habit) => _repository.isHabitCompletedOnDate(habit.id, dateString),
    );
  }

  // Get the completion percentage for a date
  double getCompletionPercentageForDate(DateTime date) {
    final dateString = _formatDate(date);

    List<Habit> habitsForDate =
        _repository
            .getAllHabits()
            .where((habit) => shouldHabitBePerformedOnDate(habit, date))
            .toList();

    if (habitsForDate.isEmpty) return 0.0;

    int completedCount =
        habitsForDate
            .where(
              (habit) =>
                  _repository.isHabitCompletedOnDate(habit.id, dateString),
            )
            .length;

    return completedCount / habitsForDate.length;
  }

  // Filter habits by category
  void selectCategory(String category) {
    _selectedCategory = category;
    _loadHabits();
    notifyListeners();
  }

  // Toggle habit completion status
  Future<void> toggleHabitCompletion(String habitId) async {
    try {
      final dateString = _formatDate(_selectedDate);

      // Debug output
      final beforeStatus = isHabitCompleted(habitId);
      print('Before toggle - Habit $habitId completion: $beforeStatus');

      // Toggle completion in repository
      await _repository.toggleHabitCompletion(habitId, dateString);

      // Debug output
      final afterStatus = _repository.isHabitCompletedOnDate(
        habitId,
        dateString,
      );
      print('After toggle - Habit $habitId completion: $afterStatus');

      // Force reload habits to reflect changes
      await _loadHabits();

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error toggling habit completion: $e';
      print('Error toggling habit completion: $e');
      notifyListeners();
    }
  }

  // Check if a habit is completed on the selected date
  bool isHabitCompleted(String habitId) {
    try {
      final dateString = _formatDate(_selectedDate);
      return _repository.isHabitCompletedOnDate(habitId, dateString);
    } catch (e) {
      print('Error checking habit completion status: $e');
      return false;
    }
  }

  // HELPER METHODS

  // Determine if a habit should be performed on a specific date based on its repeat pattern
  bool shouldHabitBePerformedOnDate(Habit habit, DateTime date) {
    try {
      if (habit.repeatType == 'Daily') {
        // Format the day of week to match the format stored in habit.selectedDays
        String dayOfWeek = DateFormat('E').format(date).substring(0, 2);
        return habit.selectedDays.contains(dayOfWeek);
      } else if (habit.repeatType == 'Weekly') {
        // For weekly habits, calculate weeks since creation
        final habitCreationDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(habit.id),
        );

        // If the habit starts in the future, it's not due yet
        if (habitCreationDate.isAfter(date)) return false;

        // Calculate days since creation
        final daysSinceCreation = date.difference(habitCreationDate).inDays;

        // For weekly habits, check if this is a multiple of (repeatNumber * 7) days
        int repeatWeeks = habit.repeatNumber ?? 1;
        return daysSinceCreation % (repeatWeeks * 7) == 0;
      } else if (habit.repeatType == 'Monthly') {
        // For monthly habits, check if the day of month matches
        final habitCreationDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(habit.id),
        );

        // If the habit starts in the future, it's not due yet
        if (habitCreationDate.isAfter(date)) return false;

        // Check if the day matches AND if the month difference is a multiple of repeatNumber
        if (date.day != habitCreationDate.day) return false;

        int monthDiff =
            (date.year - habitCreationDate.year) * 12 +
            (date.month - habitCreationDate.month);

        int repeatMonths = habit.repeatNumber ?? 1;
        return monthDiff % repeatMonths == 0;
      }

      return false;
    } catch (e) {
      print('Error in shouldHabitBePerformedOnDate: $e');
      return false;
    }
  }

  // Load habits based on selected category and date
  Future<void> _loadHabits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // First get all habits in the selected category
      List<Habit> categoryHabits = _repository.getHabitsByCategory(
        _selectedCategory,
      );

      // Then filter by date (habits that should be performed on the selected date)
      _habits =
          categoryHabits
              .where(
                (habit) => shouldHabitBePerformedOnDate(habit, _selectedDate),
              )
              .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error loading habits: $e';
      notifyListeners();
    }
  }

  // Format date to string
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Get area information
  AreaInfo getAreaInfo(String areaId) {
    try {
      final areaBox = Hive.box<Area>('areas');
      for (var area in areaBox.values) {
        if (area.id == areaId) {
          return AreaInfo(name: area.title, icon: area.icon, color: area.color);
        }
      }

      // Default values based on area ID if not found
      switch (areaId.toLowerCase()) {
        case 'health':
          return AreaInfo(
            name: 'Health',
            icon: Icons.favorite,
            color: Colors.red,
          );
        case 'well being':
        case 'wellbeing':
          return AreaInfo(
            name: 'Well Being',
            icon: Icons.self_improvement,
            color: Colors.blue,
          );
        case 'general':
          return AreaInfo(
            name: 'General',
            icon: Icons.category,
            color: AppColors.primary,
          );
        default:
          return AreaInfo(
            name: areaId.replaceAll('_', ' ').trim(),
            icon: Icons.category,
            color: AppColors.primary,
          );
      }
    } catch (e) {
      print('Error getting area info: $e');
      return AreaInfo(
        name: 'Unknown Area',
        icon: Icons.help_outline,
        color: Colors.grey,
      );
    }
  }

  // Legacy method for backward compatibility
  String getAreaName(String areaId) {
    return getAreaInfo(areaId).name;
  }
}

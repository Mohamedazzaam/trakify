// lib/features/home/data/models/habit_completion_model.dart
import 'package:hive/hive.dart';

part 'habit_completion_model.g.dart';

@HiveType(typeId: 2) // Make sure this ID doesn't conflict with other Hive types
class HabitCompletionModel extends HiveObject {
  @HiveField(0)
  String habitId;

  @HiveField(1)
  List<String> completedDates;

  // Constructor
  HabitCompletionModel({required this.habitId, List<String>? completedDates})
    : this.completedDates = completedDates ?? [];

  // Toggle completion status for a specific date
  void toggleCompletion(String dateString) {
    if (completedDates.contains(dateString)) {
      completedDates.remove(dateString);
    } else {
      completedDates.add(dateString);
    }
  }

  // Check if habit is completed on date
  bool isCompletedOnDate(String dateString) {
    return completedDates.contains(dateString);
  }
}

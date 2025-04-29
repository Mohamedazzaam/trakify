// lib/features/habit_tracking/data/models/habit_completion_model.dart
import 'package:hive/hive.dart';

part 'habit_completion_model.g.dart';

@HiveType(typeId: 2)
class HabitCompletionModel extends HiveObject {
  @HiveField(0)
  late String habitId;

  @HiveField(1)
  late List<String> completedDates;

  HabitCompletionModel({required this.habitId, List<String>? completedDates})
    : completedDates = completedDates ?? [];

  bool isCompletedOnDate(String dateString) {
    return completedDates.contains(dateString);
  }

  void toggleCompletion(String dateString) {
    if (isCompletedOnDate(dateString)) {
      completedDates.remove(dateString);
    } else {
      completedDates.add(dateString);
    }
    save();
  }
}

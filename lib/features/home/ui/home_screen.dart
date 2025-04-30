import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/add_habit/data/repos/habit_repository.dart';
import 'package:trakify/features/home/ui/view_model/habit_tracking_view_model.dart';

import '../data/repos/home_repository.dart';
import 'CalendarWidget.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide ViewModel directly in the screen
    return ChangeNotifierProvider(
      create:
          (context) => HabitTrackingViewModel(
            repository: HabitTrackingRepository(HabitRepository()),
          ),
      child: const _HabitsScreenContent(),
    );
  }
}

class _HabitsScreenContent extends StatelessWidget {
  const _HabitsScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitTrackingViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child:
                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildContent(context, viewModel),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HabitTrackingViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Simple title
          const SizedBox(height: 20),
          // Category tabs
          _buildCategoryTabs(context, viewModel),
          const SizedBox(height: 10),
          // Date selector with calendar
          _buildDateSelector(context, viewModel),
          const SizedBox(height: 20),
          // Habits list
          Expanded(
            child:
                viewModel.hasHabits
                    ? _buildHabitsList(context, viewModel)
                    : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(
    BuildContext context,
    HabitTrackingViewModel viewModel,
  ) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.availableCategories.length,
        itemBuilder: (context, index) {
          final category = viewModel.availableCategories[index];
          final isSelected = category == viewModel.selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => viewModel.selectCategory(category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    HabitTrackingViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.dayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  viewModel.formattedDate,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          // Add a calendar icon button to open the calendar dialog
          IconButton(
            icon: const Icon(Icons.calendar_month, color: AppColors.primary),
            onPressed: () => _showCalendarDialog(context, viewModel),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: AppColors.primary,
            ),
            onPressed: () => viewModel.previousDay(),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: AppColors.primary,
            ),
            onPressed: () => viewModel.nextDay(),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList(
    BuildContext context,
    HabitTrackingViewModel viewModel,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // In Progress section
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'In Progress',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Show in-progress habits or placeholder if empty
          if (viewModel.inProgressHabits.isNotEmpty)
            ...viewModel.inProgressHabits.map(
              (habit) => _buildHabitItem(context, habit, false, viewModel),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 5),
              child: Text(
                'No habits in progress',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // Only show Completed section if there are completed habits
          if (viewModel.completedHabits.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Completed Habits',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...viewModel.completedHabits.map(
              (habit) => _buildHabitItem(context, habit, true, viewModel),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_habits.png', // Replace with your actual image path
            width: 200,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.cloud_outlined,
                size: 100,
                color: Colors.grey,
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'No habits yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Time to start building one! 🚀',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitItem(
    BuildContext context,
    Habit habit,
    bool isCompleted,
    HabitTrackingViewModel viewModel,
  ) {
    // Use getAreaInfo instead of getAreaName
    final areaInfo = viewModel.getAreaInfo(habit.area);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isCompleted
                  ? Colors
                      .lightGreen
                      .shade100 // Lighter green for completed habits
                  : Colors.lightGreen.shade50, // Original color for in-progress
          borderRadius: BorderRadius.circular(10),
          // Add a subtle border for completed items
          border:
              isCompleted
                  ? Border.all(color: Colors.green.withOpacity(0.3), width: 1)
                  : null,
        ),
        child: Row(
          children: [
            Icon(
              habit.icon,
              color: isCompleted ? Colors.green : AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      // Strike through text if completed
                      decoration:
                          isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      color:
                          isCompleted
                              ? Colors
                                  .black54 // Slightly faded for completed
                              : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Show area with its icon
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isCompleted
                              ? Color(0xffE8F5E9) // Light green for completed
                              : Color(0xffFFF4B5), // Original yellow
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          areaInfo.icon,
                          size: 14,
                          color: isCompleted ? Colors.green : AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          areaInfo.name,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isCompleted ? Colors.green : AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox with animation for better feedback
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () async {
                // Show immediate feedback with a simple animation
                await _animateCompletion(context);

                // Toggle habit completion
                await viewModel.toggleHabitCompletion(habit.id);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isCompleted ? Colors.green : AppColors.primary,
                    width: 2,
                  ),
                  color: isCompleted ? Colors.green : Colors.transparent,
                ),
                child:
                    isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to show toggle animation
  Future<void> _animateCompletion(BuildContext context) async {
    // Simple ripple animation using a ScaffoldMessenger overlay
    final overlay = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const SizedBox.shrink(),
        duration: const Duration(milliseconds: 100),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );

    // Dismiss the overlay after a short delay
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  Widget _buildAreaTag(String areaName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Text(
        areaName,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showCalendarDialog(
    BuildContext context,
    HabitTrackingViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Calendar widget
                CalendarWidget(
                  viewModel: viewModel,
                  onDateSelected: (date) {
                    viewModel.selectDate(date);
                    Navigator.of(context).pop();
                  },
                ),

                const SizedBox(height: 16),

                // Today button
                TextButton(
                  onPressed: () {
                    viewModel.selectDate(DateTime.now());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Go to Today'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

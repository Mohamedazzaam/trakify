// lib/features/home/ui/calendar_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/features/home/ui/view_model/habit_tracking_view_model.dart';

class CalendarWidget extends StatelessWidget {
  final HabitTrackingViewModel viewModel;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    Key? key,
    required this.viewModel,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.primary),
              onPressed: viewModel.previousMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 24,
            ),
            Text(
              viewModel.currentMonthYear,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppColors.primary),
              onPressed: viewModel.nextMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 24,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Days of week header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildWeekdayHeaders(),
        ),
        const SizedBox(height: 8),

        // Calendar days grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: viewModel.daysInMonth + viewModel.firstDayOfMonth,
          itemBuilder: (context, index) {
            // Empty cells before first day of month
            if (index < viewModel.firstDayOfMonth) {
              return const SizedBox.shrink();
            }

            final day = index - viewModel.firstDayOfMonth + 1;
            return _buildDayCell(context, day);
          },
        ),
      ],
    );
  }

  // Build weekday header cells
  List<Widget> _buildWeekdayHeaders() {
    final weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return weekdays
        .map(
          (day) => Expanded(
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ),
        )
        .toList();
  }

  // Build day cell
  Widget _buildDayCell(BuildContext context, int day) {
    final date = DateTime(
      viewModel.displayedMonth.year,
      viewModel.displayedMonth.month,
      day,
    );

    final isToday = viewModel.isToday(date);
    final isSelected = viewModel.isSelectedDate(date);
    final hasHabits = viewModel.hasHabitsOnDate(date);
    final hasCompletedHabits = viewModel.hasCompletedHabitsOnDate(date);

    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary
                  : isToday
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border:
              hasHabits
                  ? Border.all(
                    color:
                        isSelected
                            ? Colors.white.withOpacity(0.5)
                            : AppColors.primary.withOpacity(0.5),
                    width: 1,
                  )
                  : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Day number
            Text(
              day.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight:
                    isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),

            // Habit completion indicator
            if (hasHabits)
              Positioned(
                bottom: 2,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        hasCompletedHabits
                            ? (isSelected ? Colors.white : AppColors.primary)
                            : Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/widgets/bg_shape_scaffold.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/progress/ui/view_models/StatisticsViewModel.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsViewModel(),
      child: _StatisticsContent(),
    );
  }
}

class _StatisticsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsViewModel>(
      builder: (context, viewModel, _) {
        return BgShapeScaffold(
          body:
              viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildStatisticsContent(context, viewModel),
        );
      },
    );
  }

  Widget _buildStatisticsContent(
    BuildContext context,
    StatisticsViewModel viewModel,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards in Horizontal ListView
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: _buildSummaryCardsHorizontal(context, viewModel),
          ),

          // Habits Statistics Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Habits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Individual Habit Statistics Cards
          _buildHabitStatisticsCards(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildSummaryCardsHorizontal(
    BuildContext context,
    StatisticsViewModel viewModel,
  ) {
    return SizedBox(
      height: 80, // Reduced height for more compact cards
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildStatCard(
            context,
            icon: Icons.public,
            title: 'Total Habits',
            value: viewModel.totalHabits.toString(),
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            icon: Icons.calendar_today,
            title: 'Average per Daily',
            value: viewModel.averagePerDay.toString(),
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            icon: Icons.event_available,
            title: 'Perfect Days',
            value: viewModel.perfectDays.toString(),
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            icon: Icons.whatshot,
            title: 'Total Streaks',
            value: viewModel.totalStreaks.toString(),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 150, // Reduced width for more compact cards
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with icon and title
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Centered value
          Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitStatisticsCards(
    BuildContext context,
    StatisticsViewModel viewModel,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.habits.length,
      itemBuilder: (context, index) {
        final habit = viewModel.habits[index];
        return _buildHabitStatCard(context, habit, viewModel);
      },
    );
  }

  Widget _buildHabitStatCard(
    BuildContext context,
    Habit habit,
    StatisticsViewModel viewModel,
  ) {
    // Get habit-specific statistics
    final statistics = viewModel.getHabitStatistics(habit.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Habit header with proper overflow handling
            Row(
              children: [
                // Icon (fixed width)
                Icon(habit.icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),

                // Layout that properly handles overflow
                Expanded(
                  child: Row(
                    children: [
                      // Flexible name that can shrink
                      Flexible(
                        child: Text(
                          habit.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Small fixed spacing
                      const SizedBox(width: 8),

                      // Schedule badge with minimum width
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getScheduleText(habit),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 11, // Smaller text
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Habit statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Total', statistics.total.toString()),
                _buildStatItem('Consistency', '${statistics.consistency}%'),
                _buildStatItem('Streaks', statistics.streak.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Make the stat item as compact as possible
  Widget _buildStatItem(String title, String value) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Compact schedule text formatting
  String _getScheduleText(Habit habit) {
    if (habit.repeatType == 'Daily') {
      if (habit.selectedDays.isEmpty) return "Daily";

      // For more than 2 days, show summary
      if (habit.selectedDays.length > 2) {
        return "${habit.selectedDays.length}d";
      }

      return habit.selectedDays.join(',');
    } else if (habit.repeatType == 'Weekly') {
      final weeks = habit.repeatNumber ?? 1;
      return "${weeks}w";
    } else {
      final months = habit.repeatNumber ?? 1;
      return "${months}m";
    }
  }
}

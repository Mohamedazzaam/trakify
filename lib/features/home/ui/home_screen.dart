// lib/features/home/ui/habits_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/add_habit/data/repos/habit_repository.dart';
import 'package:trakify/features/home/data/repos/habit_tracking_repository.dart';
import 'package:trakify/features/home/ui/view_model/habit_tracking_view_model.dart';

import '../data/repos/home_repository.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // توفير ViewModel مباشرة في الشاشة
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
          // عنوان بسيط
          _buildSimpleHeader(),
          const SizedBox(height: 20),
          // شريط الفئات
          _buildCategoryTabs(context, viewModel),
          const SizedBox(height: 10),
          // محدد التاريخ
          _buildDateSelector(context, viewModel),
          const SizedBox(height: 20),
          // قائمة العادات
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

  Widget _buildSimpleHeader() {
    return Row(
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning ☀️',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              'Mohamed ahmed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Spacer(),
        Icon(Icons.notifications_outlined, color: AppColors.primary),
      ],
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
          if (viewModel.inProgressHabits.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'in progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...viewModel.inProgressHabits.map(
              (habit) => _buildHabitItem(context, habit, false, viewModel),
            ),
            const SizedBox(height: 20),
          ],

          if (viewModel.completedHabits.isNotEmpty) ...[
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
            'assets/images/empty_habits.png', // استبدلها بمسار الصورة الفعلي
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
            'time to start building one! 🚀',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Widget _buildHabitItem(
  //   BuildContext context,
  //   Habit habit,
  //   bool isCompleted,
  //   HabitTrackingViewModel viewModel,
  // ) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 10),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: Colors.lightGreen.shade50,
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(habit.icon, color: AppColors.primary, size: 24),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   habit.name,
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 // عرض علامات الفئات
  //                 Row(
  //                   children: [
  //                     _buildCategoryTag('Health'),
  //                     const SizedBox(width: 4),
  //                     _buildCategoryTag('Health'),
  //                     const SizedBox(width: 4),
  //                     _buildCategoryTag('Health'),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // مربع الاختيار لإكمال العادة
  //           GestureDetector(
  //             onTap: () => viewModel.toggleHabitCompletion(habit.id),
  //             child: Container(
  //               width: 24,
  //               height: 24,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.rectangle,
  //                 borderRadius: BorderRadius.circular(4),
  //                 border: Border.all(color: AppColors.primary, width: 2),
  //                 color: isCompleted ? AppColors.primary : Colors.transparent,
  //               ),
  //               child:
  //                   isCompleted
  //                       ? const Icon(Icons.check, size: 16, color: Colors.white)
  //                       : null,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildHabitItem(
    BuildContext context,
    Habit habit,
    bool isCompleted,
    HabitTrackingViewModel viewModel,
  ) {
    // الحصول على اسم المنطقة من معرفها
    final areaName = viewModel.getAreaName(habit.area);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(habit.icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // عرض المنطقة المختارة
                  _buildAreaTag(areaName),
                ],
              ),
            ),
            // مربع الاختيار لإكمال العادة
            GestureDetector(
              onTap: () => viewModel.toggleHabitCompletion(habit.id),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.primary, width: 2),
                  color: isCompleted ? AppColors.primary : Colors.transparent,
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

  // طريقة خاصة لبناء علامة المنطقة
  // Widget _buildAreaTag(String areaName) {
  //   // تحديد لون الخلفية والأيقونة حسب المنطقة
  //   Color backgroundColor;
  //   IconData iconData;
  //
  //   switch (areaName.toLowerCase()) {
  //     case 'health':
  //       backgroundColor = Colors.green.shade100;
  //       iconData = Icons.favorite;
  //       break;
  //     case 'well being':
  //       backgroundColor = Colors.blue.shade100;
  //       iconData = Icons.self_improvement;
  //       break;
  //     case 'test':
  //       backgroundColor = Colors.orange.shade100;
  //       iconData = Icons.school;
  //       break;
  //     default:
  //       backgroundColor = Colors.amber.shade100;
  //       iconData = Icons.category;
  //   }
  //
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //     decoration: BoxDecoration(
  //       color: backgroundColor,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(iconData, color: backgroundColor.withOpacity(0.7), size: 12),
  //         const SizedBox(width: 4),
  //         Text(
  //           areaName,
  //           style: const TextStyle(fontSize: 12, color: Colors.black54),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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

  Widget _buildCategoryTag(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite, color: Colors.amber, size: 12),
          const SizedBox(width: 4),
          Text(
            category,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

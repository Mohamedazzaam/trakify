import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakify/core/constants/assets.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/widgets/bg_shape_scaffold.dart';
import 'package:trakify/core/widgets/icon_picker_dialog.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/add_habit/data/repos/habit_repository.dart';

import '../logic/edit_habit_cubit.dart';
import '../logic/edit_habit_state.dart';

class EditHabitScreen extends StatelessWidget {
  final Habit habit;

  const EditHabitScreen({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditHabitCubit(HabitRepository(), habit),
      child: const _EditHabitView(),
    );
  }
}

class _EditHabitView extends StatelessWidget {
  const _EditHabitView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditHabitCubit, EditHabitState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == EditHabitStatus.success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habit updated successfully!')),
          );
        } else if (state.status == EditHabitStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        }
      },
      child: BgShapeScaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Habit',
            style: TextStyle(
              color: Colors.black,
              fontFamily: Assets.fontsIBMPlexSansBold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: false,
        ),
        body: const _EditHabitForm(),
      ),
    );
  }
}

class _EditHabitForm extends StatelessWidget {
  const _EditHabitForm();

  void _selectTime(BuildContext context) async {
    final cubit = context.read<EditHabitCubit>();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      cubit.addReminderTime(picked);
    }
  }

  void _showIconPicker(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<EditHabitCubit>(),
            child: const IconPickerDialog(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: BlocBuilder<EditHabitCubit, EditHabitState>(
          builder: (context, state) {
            final cubit = context.read<EditHabitCubit>();

            return ListView(
              children: [
                // Habit name
                Text(
                  'Habit Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: Assets.fontsIBMPlexSansBold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Habit name input field (takes most space)
                    Expanded(
                      child: TextFormField(
                        initialValue: state.habitName,
                        decoration: InputDecoration(
                          hintText: 'habit name',
                          prefixIcon: const Icon(Icons.edit),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                        onChanged: cubit.updateHabitName,
                      ),
                    ),

                    // Space between field and button
                    const SizedBox(width: 10),

                    // Icon selection button
                    Container(
                      height: 58,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.primary, width: 1),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => _showIconPicker(context),
                        icon: Icon(
                          state.selectedIcon,
                          size: 24,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Repeat section
                const Text(
                  'Repeat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final type in ['Daily', 'Weekly', 'Monthly'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                state.repeatType == type
                                    ? AppColors.primary
                                    : Color(0xffDDEDE8),
                            foregroundColor:
                                state.repeatType == type
                                    ? Colors.white
                                    : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => cubit.changeRepeatType(type),
                          child: Text(type),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Days selection (for Daily repeat)
                if (state.repeatType == 'Daily') ...[
                  const Text(
                    'On These Days',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        cubit.days.map((day) {
                          final isSelected = state.selectedDays.contains(day);
                          return GestureDetector(
                            onTap: () => cubit.toggleDay(day),
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Color(0xffDDEDE8),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow:
                                    isSelected
                                        ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ]
                                        : null,
                              ),
                              child: Center(
                                child: Text(
                                  day, // 'Su', 'Mo', etc.
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ]
                // Number of repeats (for Weekly or Monthly)
                else ...[
                  Text(
                    state.repeatType == 'Weekly'
                        ? 'How many weeks?'
                        : 'How many months?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        cubit.numbers.map((number) {
                          final isSelected = state.selectedNumber == number;
                          return GestureDetector(
                            onTap: () => cubit.selectNumber(number),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Color(0xffDDEDE8),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow:
                                    isSelected
                                        ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ]
                                        : null,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      number.toString(),
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      state.repeatType == 'Weekly'
                                          ? (number == 1 ? 'week' : 'weeks')
                                          : (number == 1 ? 'month' : 'months'),
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white.withOpacity(0.9)
                                                : Colors.black.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Daily notification toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Daily notification'),
                    Switch(
                      value: state.dailyNotification,
                      onChanged: cubit.toggleDailyNotification,
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Reminder times (if daily notification is enabled)
                if (state.dailyNotification) ...[
                  // Show selected reminder times
                  if (state.selectedTimes.isNotEmpty)
                    Column(
                      children:
                          state.selectedTimes
                              .asMap()
                              .entries
                              .map(
                                (entry) => ListTile(
                                  leading: const Icon(Icons.access_time),
                                  title: Text(entry.value.format(context)),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () =>
                                            cubit.removeReminderTime(entry.key),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  // Button to add a new reminder time
                  TextButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.add_alarm, color: AppColors.primary),
                    label: const Text(
                      'Select Time',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Area dropdown
                DropdownButtonFormField<String>(
                  value: state.selectedArea,
                  decoration: InputDecoration(
                    labelText: 'Choose Your Area...',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  dropdownColor: Colors.grey[200],
                  items:
                      cubit.areas
                          .map(
                            (area) => DropdownMenuItem(
                              value: area,
                              child: Text(area),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) cubit.selectArea(value);
                  },
                ),
                const SizedBox(height: 30),

                // Update button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed:
                        state.status == EditHabitStatus.loading
                            ? null
                            : () => cubit.updateHabit(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 15.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child:
                        state.status == EditHabitStatus.loading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Update Habit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

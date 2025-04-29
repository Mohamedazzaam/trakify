import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trakify/core/constants/assets.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/core/widgets/bg_shape_scaffold.dart';

import '../../../core/widgets/icon_picker_dialog.dart';
import '../data/repos/habit_repository.dart';
import '../logic/add_habit_cubit.dart';
import '../logic/add_habit_state.dart';

class AddHabitScreen extends StatelessWidget {
  const AddHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddHabitCubit(HabitRepository()),
      child: const _AddHabitView(),
    );
  }
}

// المكون الرئيسي للشاشة - يستمع إلى تغييرات الحالة
class _AddHabitView extends StatelessWidget {
  const _AddHabitView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddHabitCubit, AddHabitState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddHabitStatus.success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إنشاء العادة بنجاح!')),
          );
        } else if (state.status == AddHabitStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ ما')),
          );
        }
      },
      child: BgShapeScaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.close, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Add Habit',
            style: TextStyle(
              color: Colors.black,
              fontFamily: Assets.fontsIBMPlexSansBold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        body: const _AddHabitForm(),
      ),
    );
  }
}

// نموذج إضافة العادة - يعرض النموذج ويتفاعل مع Cubit
class _AddHabitForm extends StatelessWidget {
  const _AddHabitForm();

  void _selectTime(BuildContext context) async {
    final cubit = context.read<AddHabitCubit>();
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
            value: context.read<AddHabitCubit>(),
            child: const IconPickerDialog(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: BlocBuilder<AddHabitCubit, AddHabitState>(
          builder: (context, state) {
            final cubit = context.read<AddHabitCubit>();

            return ListView(
              children: [
                // اسم العادة
                Text(
                  'Habit Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: Assets.fontsIBMPlexSansBold,
                  ),
                ),
                const SizedBox(height: 8),
                // استخدام TextFormField مباشرة لتجنب مشكلة CustomTextField
                // اسم العادة وزر الأيقونة في صف واحد
                Row(
                  children: [
                    // حقل إدخال اسم العادة (يأخذ معظم المساحة)
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

                    // مسافة بين الحقل والزر
                    const SizedBox(width: 10),

                    // زر اختيار الأيقونة (حجم مصغر)
                    Container(
                      height: 58, // نفس ارتفاع حقل النص تقريبًا
                      width: 55, // عرض مناسب للزر
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.primary, width: 1),
                        color: Colors.white, // نفس لون الحقل
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero, // بدون padding داخلي
                        onPressed: () => _showIconPicker(context),
                        icon: Icon(
                          state.selectedIcon,
                          size: 24, // حجم مناسب للأيقونة
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // قسم التكرار
                const Text('Repeat '),
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

                // أيام التكرار (للتكرار اليومي)
                if (state.repeatType == 'Daily') ...[
                  const Text('On These Days'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        cubit.days.map((day) {
                          final isSelected = state.selectedDays.contains(day);
                          return GestureDetector(
                            onTap: () => cubit.toggleDay(day),
                            child: Container(
                              width: 42,
                              height: 42,
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Color(0xffDDEDE8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                day,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ]
                // عدد التكرار (للتكرار الأسبوعي أو الشهري)
                else ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        cubit.numbers.map((number) {
                          final isSelected = state.selectedNumber == number;
                          return GestureDetector(
                            onTap: () => cubit.selectNumber(number),
                            child: Container(
                              width: 46,
                              height: 42,
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Color(0xffDDEDE8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  number.toString(),
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // تبديل الإشعارات اليومية
                // تبديل الإشعارات اليومية
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

                // أوقات التذكير (إذا كانت الإشعارات اليومية مفعلة)
                if (state.dailyNotification) ...[
                  // عرض أوقات التذكير المختارة
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
                  // زر إضافة وقت تذكير جديد
                  TextButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.add_alarm, color: AppColors.primary),
                    label: const Text(
                      'Select Time',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ], // هذا هو قوس الإغلاق للشرط - يجب أن يكون هنا
                // قائمة منسدلة لاختيار المجال - خارج الشرط
                // قائمة منسدلة لاختيار المجال
                // في widget _AddHabitForm
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

                // زر إنشاء العادة
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed:
                        state.status == AddHabitStatus.loading
                            ? null
                            : () => cubit.createHabit(),
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
                      splashFactory:
                          NoSplash.splashFactory, // يمنع تأثير السبلاتش
                    ),
                    child:
                        state.status == AddHabitStatus.loading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Create habit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    16, // ممكن تعدله حسب الستايل العام عندك
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trakify/core/widgets/bg_shape_scaffold.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/widgets/area_habit_item.dart';
import '../../../core/widgets/area_list_tile.dart';
import '../../../features/add_habit/data/models/habit_model.dart';
import '../../add_habit/ui/add_habit_screen.dart';
import '../../edit_habit/ui/edit_habit_screen.dart';
import '../data/models/area_model.dart';

class AreaScreen extends StatelessWidget {
  const AreaScreen({
    super.key,
    required this.title,
    required this.subTitle,
    required this.areaLeadingIcon,
  });

  final String title;
  final String subTitle;
  final IconData areaLeadingIcon;

  @override
  Widget build(BuildContext context) {
    // احصل على معرّف المنطقة من خلال البحث في صندوق المناطق
    final areaBox = Hive.box<Area>('areas');
    final area = areaBox.values.firstWhere(
      (a) => a.title == title,
      orElse: () => Area(),
    );

    final areaId = area.id.isNotEmpty ? area.id : '';

    return BgShapeScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text('My Area'),
        actions: [
          InkWell(
            onTap: () {
              // إضافة منطق للتعامل مع قائمة الخيارات (تعديل/حذف)
              _showOptionsMenu(context, areaId);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.menu_rounded),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // منطقة العنوان
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: AreaListTile(
                title: title,
                subTitle: subTitle,
                areaLeadingIcon: areaLeadingIcon,
                leadingIconColor: Colors.white,
                cardColor: Color(0xff1B8466),
                titleColor: Colors.white,
                subTitleColor: Colors.white,
                enable: false,
              ),
            ),

            // عرض العادات المرتبطة بالمنطقة
            // في الجزء الخاص بعرض العادات
            Expanded(
              child: ValueListenableBuilder<Box<Habit>>(
                valueListenable: Hive.box<Habit>('habits').listenable(),
                builder: (context, habitBox, child) {
                  // فلترة العادات بناءً على معرّف المنطقة
                  final habits =
                      habitBox.values
                          .where((habit) => habit.area == areaId)
                          .toList();

                  if (habits.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No habits in this area yet',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              // التوجيه إلى شاشة إضافة عادة
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddHabitScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                            label: Text('Add Habit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      return AreaHabitItem(
                        title: title,
                        areaLeadingIcon: areaLeadingIcon,
                        habit: habit,
                        onMenuPressed: () {
                          // إضافة منطق للتعامل مع خيارات العادة
                          _showHabitOptionsMenu(context, habit);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // زر إضافة عادة جديدة
    );
  }

  // عرض قائمة خيارات المنطقة
  void _showOptionsMenu(BuildContext context, String areaId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Area'),
              onTap: () {
                Navigator.pop(context);
                // يمكنك عرض مربع حوار لتحرير المنطقة
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Area', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // طلب تأكيد قبل الحذف
                _confirmDeleteArea(context, areaId);
              },
            ),
          ],
        );
      },
    );
  }

  // مربع حوار تأكيد حذف المنطقة
  Future<void> _confirmDeleteArea(BuildContext context, String areaId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Area'),
          content: Text(
            'Are you sure you want to delete this area? This will also delete all habits in this area.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // حذف المنطقة من Hive
                if (areaId.isNotEmpty) {
                  final areaBox = Hive.box<Area>('areas');
                  await areaBox.delete(areaId);

                  // حذف جميع العادات المرتبطة بهذه المنطقة
                  final habitBox = Hive.box<Habit>('habits');
                  final habitsToDelete =
                      habitBox.values
                          .where((habit) => habit.area == areaId)
                          .map((habit) => habit.key)
                          .toList();

                  for (var key in habitsToDelete) {
                    await habitBox.delete(key);
                  }

                  // العودة للشاشة السابقة
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showHabitOptionsMenu(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Habit'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet

                // Navigate to the edit habit screen with the selected habit
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditHabitScreen(habit: habit),
                  ),
                ).then((_) {
                  // Simply force a rebuild to refresh the data
                  if (context.mounted) {
                    // Force rebuilding the widget to reflect any changes
                    // This works because we're using ValueListenableBuilder
                    // which will automatically refresh when the Hive box changes
                  }
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Habit', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteHabit(context, habit);
              },
            ),
          ],
        );
      },
    );
  }

  // مربع حوار تأكيد حذف العادة
  Future<void> _confirmDeleteHabit(BuildContext context, Habit habit) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Habit'),
          content: Text('Are you sure you want to delete "${habit.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // حذف العادة من Hive
                await habit.delete();

                // تحديث عدد العادات في المنطقة
                if (habit.area.isNotEmpty) {
                  final areaBox = Hive.box<Area>('areas');
                  final area = areaBox.get(habit.area);
                  if (area != null) {
                    final habitBox = Hive.box<Habit>('habits');
                    final habitsCount =
                        habitBox.values
                            .where((h) => h.area == habit.area)
                            .length;

                    area.subTitle = '$habitsCount Habits';
                    await area.save();
                  }
                }

                Navigator.pop(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

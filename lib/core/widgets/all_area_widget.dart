import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../features/areas/data/models/area_model.dart';
import '../../features/areas/ui/widgets/add_area_dialog.dart'; // تأكد من إضافة مسار صحيح

class AllAreasWidget extends StatelessWidget {
  const AllAreasWidget({super.key});

  // حساب إجمالي عدد العادات من جميع المناطق
  int _calculateTotalHabits(List<Area> areas) {
    int count = 0;
    for (var area in areas) {
      // استخراج الرقم من النص مثل "5 Habits"
      final match = RegExp(r'(\d+)').firstMatch(area.subTitle);
      if (match != null) {
        count += int.parse(match.group(1)!);
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Area>>(
      valueListenable: Hive.box<Area>('areas').listenable(),
      builder: (context, box, child) {
        final areas = box.values.toList();
        final totalHabits = _calculateTotalHabits(areas);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff1B8466),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.icecream_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'All Areas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalHabits Habits',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 2, // مقدار الظل
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddAreaDialog(),
                      );
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, size: 24, color: Color(0xff1B8466)),
                          SizedBox(width: 4),
                          Text(
                            'Add Area',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff1B8466),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

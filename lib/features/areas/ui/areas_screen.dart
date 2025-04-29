import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trakify/core/widgets/bg_shape_scaffold.dart';

import '../../../core/widgets/all_area_widget.dart';
import '../../../core/widgets/area_list_tile.dart';
import '../data/models/area_model.dart';
import 'area_screen.dart';

class AreasScreen extends StatelessWidget {
  const AreasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BgShapeScaffold(
      body: SafeArea(
        child: Column(
          children: [AllAreasWidget(), Expanded(child: AreaListView())],
        ),
      ),
    );
  }
}

class AreaListView extends StatelessWidget {
  const AreaListView({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام ValueListenableBuilder لمراقبة تغييرات الصندوق
    return ValueListenableBuilder<Box<Area>>(
      valueListenable: Hive.box<Area>('areas').listenable(),
      builder: (context, box, child) {
        final areas = box.values.toList();

        // عرض رسالة إذا لم تكن هناك مناطق
        if (areas.isEmpty) {
          return Center(
            child: Text(
              'No areas found. Add your first area!',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // عرض قائمة المناطق
        return ListView.builder(
          itemCount: areas.length,
          itemBuilder: (context, index) {
            final area = areas[index];

            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: AreaListTile(
                title: area.title,
                subTitle: area.subTitle,
                areaLeadingIcon: area.icon,
                areaTrailingIcon: Icons.arrow_forward_ios,
                leadingIconColor: Colors.black,
                cardColor: Color(0xffDDEDE8),
                titleColor: Colors.black,
                subTitleColor: Colors.black,
                onTap: () {
                  // الانتقال إلى شاشة تفاصيل المنطقة
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AreaScreen(
                            title: area.title,
                            subTitle: area.subTitle,
                            areaLeadingIcon: area.icon,
                          ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

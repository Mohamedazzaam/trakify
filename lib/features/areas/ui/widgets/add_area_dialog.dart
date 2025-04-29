import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../core/theming/app_colors.dart';
import '../../data/models/area_model.dart';

class AddAreaDialog extends StatefulWidget {
  const AddAreaDialog({Key? key}) : super(key: key);

  @override
  _AddAreaDialogState createState() => _AddAreaDialogState();
}

class _AddAreaDialogState extends State<AddAreaDialog> {
  final TextEditingController _controller = TextEditingController();
  IconData _selectedIcon = Icons.emoji_emotions;
  bool _isLoading = false;
  String? _errorMessage;

  final List<IconData> _icons = [
    Icons.star,
    Icons.favorite,
    Icons.book,
    Icons.self_improvement,
    Icons.restaurant,
    Icons.school,
    Icons.calendar_today,
    Icons.spa,
    Icons.work,
    Icons.bed,
    Icons.fitness_center,
    Icons.icecream,
  ];

  void _showIconPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Icon'),
          content: Wrap(
            spacing: 10,
            children:
                _icons.map((icon) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = icon;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            _selectedIcon == icon
                                ? AppColors.primary
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        icon,
                        color:
                            _selectedIcon == icon
                                ? Colors.white
                                : AppColors.primary,
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _addArea() async {
    if (_controller.text.isEmpty) {
      setState(() {
        _errorMessage = 'Area name cannot be empty';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // الحصول على مربع المناطق
      final areaBox = Hive.box<Area>('areas');

      // إنشاء كائن منطقة جديد
      final area = Area.create(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _controller.text,
        subTitle: '0 Habits',
        icon: _selectedIcon,
      );

      // حفظ المنطقة في Hive
      await areaBox.put(area.id, area);

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error adding area: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Add New Area')),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.99,
        height: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Area Name',
                      border: OutlineInputBorder(),
                      errorText: _errorMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showIconPicker,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(_selectedIcon, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: AppColors.primary,
              minimumSize: Size(300, 50),
            ),
            onPressed: _isLoading ? null : _addArea,
            child:
                _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

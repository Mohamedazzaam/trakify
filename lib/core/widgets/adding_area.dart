import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddAreaDialog extends StatefulWidget {
  @override
  _AddAreaDialogState createState() => _AddAreaDialogState();
}

class _AddAreaDialogState extends State<AddAreaDialog> {
  final TextEditingController _controller = TextEditingController();
  IconData _selectedIcon = Icons.emoji_emotions;

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
    Icons.book,
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
                                ? Color(0xff1B8466)
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        icon,
                        color:
                            _selectedIcon == icon
                                ? Colors.white
                                : Color(0xff1B8466),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
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
                    child: Icon(_selectedIcon, color: Color(0xff1B8466)),
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
              backgroundColor: Color(0xff1B8466),
              minimumSize: Size(300, 50),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

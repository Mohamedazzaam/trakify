import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/add_habit/logic/add_habit_cubit.dart';

class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddHabitCubit>();
    final state = context.watch<AddHabitCubit>().state;

    return AlertDialog(
      title: const Text('Choose Icon'),
      content: Container(
        width: double.maxFinite,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              cubit.availableIcons.map((icon) {
                final isSelected = state.selectedIcon == icon;
                return GestureDetector(
                  onTap: () {
                    cubit.selectIcon(icon);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      icon,
                      color:
                          isSelected
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

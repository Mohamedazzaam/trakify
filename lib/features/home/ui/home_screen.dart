import 'package:flutter/material.dart';
import 'package:trakify/core/widgets/bg_shape_scaffold.dart';
import 'package:trakify/features/add_habit/data/repos/habit_repository.dart';

import '../../add_habit/data/models/habit_model.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final HabitRepository _repository = HabitRepository();
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  void _loadHabits() {
    setState(() {
      _habits = _repository.getAllHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BgShapeScaffold(
      appBar: AppBar(
        title: const Text('عاداتي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, '/add_habit');
              _loadHabits(); // إعادة تحميل العادات بعد العودة
            },
          ),
        ],
      ),
      body:
          _habits.isEmpty
              ? const Center(child: Text('لا توجد عادات. أضف عادات جديدة!'))
              : ListView.builder(
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  return ListTile(
                    leading: Icon(habit.icon),
                    title: Text(habit.name),
                    subtitle: Text(habit.area),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _repository.deleteHabit(habit.id);
                        _loadHabits();
                      },
                    ),
                  );
                },
              ),
    );
  }
}

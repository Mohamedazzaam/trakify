import 'package:flutter/material.dart';
import '../../data/rebos/area_rebos.dart';
import '../../data/models/area_model.dart';
import '../../../add_habit/data/models/habit_model.dart';

class AreaDetailViewModel extends ChangeNotifier {
  final AreaRepository _repository;
  final String areaId;

  // الحالة
  bool _isLoading = false;
  String? _errorMessage;
  Area? _area;
  List<Habit> _habits = [];

  // البناء
  AreaDetailViewModel({
    required AreaRepository repository,
    required this.areaId,
  }) : _repository = repository {
    loadAreaDetails();
  }

  // الخصائص العامة
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Area? get area => _area;
  List<Habit> get habits => _habits;
  bool get hasHabits => _habits.isNotEmpty;

  // تحميل تفاصيل المنطقة
  Future<void> loadAreaDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _area = _repository.getAreaById(areaId);
      _habits = _repository.getHabitsByArea(areaId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error loading area details: $e';
      notifyListeners();
    }
  }

  // تحديث عنوان المنطقة
  Future<bool> updateAreaTitle(String newTitle) async {
    if (newTitle.isEmpty) {
      _errorMessage = 'Area title cannot be empty';
      notifyListeners();
      return false;
    }

    if (_area == null) return false;

    try {
      _area!.title = newTitle;
      await _repository.updateArea(_area!);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error updating area: $e';
      notifyListeners();
      return false;
    }
  }
}

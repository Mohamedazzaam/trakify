import 'package:flutter/material.dart';
import '../../data/rebos/area_rebos.dart';
import '../../data/models/area_model.dart';

class AreaListViewModel extends ChangeNotifier {
  final AreaRepository _repository;

  // حالة الشاشة
  bool _isLoading = false;
  String? _errorMessage;
  List<Area> _areas = [];

  // البناء
  AreaListViewModel({required AreaRepository repository})
    : _repository = repository {
    loadAreas();
  }

  // الخصائص العامة
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Area> get areas => _areas;
  bool get hasAreas => _areas.isNotEmpty;

  // تحميل جميع المناطق
  Future<void> loadAreas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _areas = _repository.getAllAreas();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load areas: $e';
      notifyListeners();
    }
  }

  // إضافة منطقة جديدة
  Future<bool> addArea(String title, IconData icon, [Color? color]) async {
    if (title.isEmpty) {
      _errorMessage = 'Area name cannot be empty';
      notifyListeners();
      return false;
    }

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final area = Area.create(
        id: id,
        title: title,
        subTitle: '0 Habits',
        icon: icon,
        color: color ?? const Color(0xFFDDEDE8),
      );

      await _repository.addArea(area);
      await loadAreas(); // تحديث القائمة
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add area: $e';
      notifyListeners();
      return false;
    }
  }

  // حذف منطقة
  Future<bool> deleteArea(String id) async {
    try {
      await _repository.deleteArea(id);
      await loadAreas(); // تحديث القائمة
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete area: $e';
      notifyListeners();
      return false;
    }
  }

  // الحصول على إجمالي عدد العادات
  int get totalHabitsCount {
    int count = 0;
    for (var area in _areas) {
      // استخراج الرقم من النص مثل "5 Habits"
      final match = RegExp(r'(\d+)').firstMatch(area.subTitle);
      if (match != null) {
        count += int.parse(match.group(1)!);
      }
    }
    return count;
  }
}

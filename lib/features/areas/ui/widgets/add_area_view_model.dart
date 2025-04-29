import 'package:flutter/material.dart';
import '../../data/rebos/area_rebos.dart';
import 'area_list_view_model.dart';

class AddAreaViewModel extends ChangeNotifier {
  final AreaRepository _repository;

  // الحالة
  String _areaName = '';
  IconData _selectedIcon = Icons.emoji_emotions;
  bool _isLoading = false;
  String? _errorMessage;

  // قائمة الأيقونات المتاحة
  final List<IconData> availableIcons = [
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

  // البناء
  AddAreaViewModel({required AreaRepository repository})
    : _repository = repository;

  // الخصائص العامة
  String get areaName => _areaName;
  IconData get selectedIcon => _selectedIcon;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get canSave => _areaName.isNotEmpty && !_isLoading;

  // تحديث اسم المنطقة
  void updateAreaName(String name) {
    _areaName = name;
    _errorMessage = null;
    notifyListeners();
  }

  // اختيار أيقونة
  void selectIcon(IconData icon) {
    _selectedIcon = icon;
    notifyListeners();
  }

  // إضافة منطقة جديدة
  Future<bool> saveArea() async {
    if (_areaName.isEmpty) {
      _errorMessage = 'Area name cannot be empty';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final areaListViewModel = AreaListViewModel(repository: _repository);
      final success = await areaListViewModel.addArea(_areaName, _selectedIcon);

      _isLoading = false;
      if (success) {
        // إعادة تعيين القيم
        _areaName = '';
        _selectedIcon = Icons.emoji_emotions;
      }
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error adding area: $e';
      notifyListeners();
      return false;
    }
  }
}

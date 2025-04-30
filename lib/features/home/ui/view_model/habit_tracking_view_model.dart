// lib/features/home/ui/view_model/habit_tracking_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:trakify/core/theming/app_colors.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/home/data/repos/habit_tracking_repository.dart';
import 'package:trakify/features/areas/data/models/area_model.dart';

import '../../data/repos/home_repository.dart';

// تعريف فئة AreaInfo خارج HabitTrackingViewModel
class AreaInfo {
  final String name;
  final IconData icon;
  final Color color;

  AreaInfo({required this.name, required this.icon, this.color = Colors.black});
}

class HabitTrackingViewModel extends ChangeNotifier {
  final HabitTrackingRepository _repository;

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'All';
  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _errorMessage;

  HabitTrackingViewModel({required HabitTrackingRepository repository})
    : _repository = repository {
    _loadHabits();
  }

  // الحصول على التاريخ المحدد
  DateTime get selectedDate => _selectedDate;

  // الحصول على الفئة المحددة
  String get selectedCategory => _selectedCategory;

  // الحصول على قائمة العادات
  List<Habit> get habits => _habits;

  // الحصول على العادات قيد التقدم
  List<Habit> get inProgressHabits =>
      _habits.where((habit) => !isHabitCompleted(habit.id)).toList();

  // الحصول على العادات المكتملة
  List<Habit> get completedHabits =>
      _habits.where((habit) => isHabitCompleted(habit.id)).toList();

  // حالة التحميل
  bool get isLoading => _isLoading;

  // رسالة الخطأ (إن وجدت)
  String? get errorMessage => _errorMessage;

  // هل توجد عادات
  bool get hasHabits => _habits.isNotEmpty;

  // تغيير التاريخ المحدد
  void selectDate(DateTime date) {
    _selectedDate = date;
    _loadHabits();
    notifyListeners();
  }

  // الانتقال لليوم السابق
  void previousDay() {
    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    _loadHabits();
    notifyListeners();
  }

  // الانتقال لليوم التالي
  void nextDay() {
    _selectedDate = _selectedDate.add(const Duration(days: 1));
    _loadHabits();
    notifyListeners();
  }

  // تغيير الفئة المحددة
  void selectCategory(String category) {
    _selectedCategory = category;
    _loadHabits();
    notifyListeners();
  }

  // تبديل حالة إكمال العادة
  Future<void> toggleHabitCompletion(String habitId) async {
    try {
      final dateString = _formatDate(_selectedDate);
      await _repository.toggleHabitCompletion(habitId, dateString);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error toggling habit completion: $e';
      notifyListeners();
    }
  }

  // التحقق مما إذا كانت العادة مكتملة في التاريخ المحدد
  bool isHabitCompleted(String habitId) {
    final dateString = _formatDate(_selectedDate);
    return _repository.isHabitCompletedOnDate(habitId, dateString);
  }

  // تحميل العادات بناءً على الفئة المحددة والتاريخ
  Future<void> _loadHabits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _habits = _repository.getHabitsByCategory(_selectedCategory);
      // يمكن هنا إضافة مزيد من الفلترة حسب التاريخ إذا لزم الأمر

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error loading habits: $e';
      notifyListeners();
    }
  }

  // تنسيق التاريخ كسلسلة
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // الحصول على اسم المنطقة
  String getAreaName(String areaId) {
    try {
      final areaBox = Hive.box<Area>('areas');

      for (final area in areaBox.values) {
        if (area.id == areaId) {
          return area.title;
        }
      }

      // إذا لم يتم العثور على المنطقة، استخدم بعض المنطق لتخمين الاسم
      if (areaId == 'general') return 'General';
      if (areaId.toLowerCase().contains('health')) return 'Health';
      if (areaId.toLowerCase().contains('well')) return 'Well Being';
      if (areaId.toLowerCase().contains('test')) return 'Test';

      // إذا كل شيء فشل، أرجع قيمة معقولة
      return areaId.replaceAll('_', ' ').trim();
    } catch (e) {
      print('Error getting area name: $e');
      return 'Unknown Area';
    }
  }

  // الحصول على معلومات المنطقة
  AreaInfo getAreaInfo(String areaId) {
    try {
      final areaBox = Hive.box<Area>('areas');
      for (var area in areaBox.values) {
        if (area.id == areaId) {
          return AreaInfo(name: area.title, icon: area.icon, color: area.color);
        }
      }

      // إذا لم يتم العثور على المنطقة، استخدم معلومات افتراضية
      switch (areaId.toLowerCase()) {
        case 'health':
          return AreaInfo(
            name: 'Health',
            icon: Icons.favorite,
            color: Colors.red,
          );
        case 'well being':
          return AreaInfo(
            name: 'Well Being',
            icon: Icons.self_improvement,
            color: Colors.blue,
          );
        default:
          return AreaInfo(
            name: areaId.replaceAll('_', ' ').trim(),
            icon: Icons.category,
            color: AppColors.primary,
          );
      }
    } catch (e) {
      print('Error getting area info: $e');
      return AreaInfo(
        name: 'Unknown Area',
        icon: Icons.help_outline,
        color: Colors.grey,
      );
    }
  }

  // تحصل على اسم اليوم من التاريخ المحدد
  String get dayName => DateFormat('EEEE').format(_selectedDate);

  // تحصل على التاريخ منسقًا
  String get formattedDate => DateFormat('dd MMMM yyyy').format(_selectedDate);

  // تعيد قائمة بالفئات المتاحة
  // داخل فئة HabitTrackingViewModel

  // تعديل الخاصية availableCategories لتجلب المناطق من Hive
  List<String> get availableCategories {
    final categories = ['All']; // دائمًا ابدأ بخيار "All"

    try {
      // جلب جميع المناطق من Hive
      final areaBox = Hive.box<Area>('areas');
      final areaNames = areaBox.values.map((area) => area.title).toList();

      // إضافة أسماء المناطق المميزة فقط (بدون تكرار)
      for (var name in areaNames) {
        if (!categories.contains(name)) {
          categories.add(name);
        }
      }
    } catch (e) {
      print('Error getting area categories: $e');
    }

    return categories;
  }
}

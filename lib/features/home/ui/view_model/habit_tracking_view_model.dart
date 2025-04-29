// lib/features/home/ui/view_model/habit_tracking_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:trakify/features/add_habit/data/models/habit_model.dart';
import 'package:trakify/features/home/data/repos/habit_tracking_repository.dart';

import '../../../areas/data/models/area_model.dart';
import '../../data/repos/home_repository.dart';

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
  // في lib/features/home/ui/view_model/habit_tracking_view_model.dart
  // أضف هذه الطريقة إلى الفئة:

  // في HabitTrackingViewModel
  String getAreaName(String areaId) {
    try {
      // عدم محاولة فتح الصندوق مرة أخرى، بل استخدام الصندوق المفتوح بالفعل
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

  // تحصل على اسم اليوم من التاريخ المحدد
  String get dayName => DateFormat('EEEE').format(_selectedDate);

  // تحصل على التاريخ منسقًا
  String get formattedDate => DateFormat('dd MMMM yyyy').format(_selectedDate);

  // تعيد قائمة بالفئات المتاحة
  List<String> get availableCategories => [
    'All',
    'Well Being',
    'Health',
    'Test',
  ];
}

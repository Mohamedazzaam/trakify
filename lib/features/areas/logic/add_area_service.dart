import '../data/rebos/area_rebos.dart';

class AreaService {
  final AreaRepository _repository;

  AreaService(this._repository);

  // جلب أسماء المناطق للقائمة المنسدلة
  List<String> getAreaNames() {
    final areas = _repository.getAreaNames();

    // إذا لم تكن هناك مناطق، أضف منطقة افتراضية
    if (areas.isEmpty) {
      return ['General'];
    }

    return areas;
  }

  // جلب معرّف المنطقة بواسطة الاسم
  String getAreaIdByName(String areaName) {
    final areaId = _repository.getAreaIdByName(areaName);
    return areaId ??
        'general'; // استخدم معرف افتراضي إذا لم يتم العثور على المنطقة
  }

  // تحديث عدد العادات في المنطقة
  Future<void> updateAreaHabitsCount(String areaId) async {
    await _repository.updateAreaHabitsCount(areaId);
  }
}

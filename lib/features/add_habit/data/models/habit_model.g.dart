// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..iconCodePoint = fields[2] as int
      ..iconFontFamily = fields[3] as String
      ..repeatType = fields[4] as String
      ..selectedDays = (fields[5] as List).cast<String>()
      ..repeatNumber = fields[6] as int?
      ..dailyNotification = fields[7] as bool
      ..reminderTimes = (fields[8] as List).cast<String>()
      ..area = fields[9] as String;
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconCodePoint)
      ..writeByte(3)
      ..write(obj.iconFontFamily)
      ..writeByte(4)
      ..write(obj.repeatType)
      ..writeByte(5)
      ..write(obj.selectedDays)
      ..writeByte(6)
      ..write(obj.repeatNumber)
      ..writeByte(7)
      ..write(obj.dailyNotification)
      ..writeByte(8)
      ..write(obj.reminderTimes)
      ..writeByte(9)
      ..write(obj.area);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

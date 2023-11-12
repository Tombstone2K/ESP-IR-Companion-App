// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rulesCustomClass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RulesAdapter extends TypeAdapter<Rules> {
  @override
  final int typeId = 0;

  @override
  Rules read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rules(
      fields[0] as String,
      fields[1] as String,
      fields[2] as double,
      fields[3] as bool,
      fields[4] as bool,
      fields[5] as String,
      fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Rules obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.temperatureThreshold)
      ..writeByte(3)
      ..write(obj.greaterThanTemperature)
      ..writeByte(4)
      ..write(obj.actionTaken)
      ..writeByte(5)
      ..write(obj.action)
      ..writeByte(6)
      ..write(obj.ruleType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RulesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class listOfRulesAdapter extends TypeAdapter<listOfRules> {
  @override
  final int typeId = 1;

  @override
  listOfRules read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return listOfRules(
      (fields[0] as List).cast<Rules>(),
    );
  }

  @override
  void write(BinaryWriter writer, listOfRules obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.arrayOfRules);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is listOfRulesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rules _$RulesFromJson(Map<String, dynamic> json) => Rules(
      json['startTime'] as String,
      json['endTime'] as String,
      (json['temperatureThreshold'] as num).toDouble(),
      json['greaterThanTemperature'] as bool,
      json['actionTaken'] as bool,
      json['action'] as String,
      json['ruleType'] as int,
    );

Map<String, dynamic> _$RulesToJson(Rules instance) => <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'temperatureThreshold': instance.temperatureThreshold,
      'greaterThanTemperature': instance.greaterThanTemperature,
      'actionTaken': instance.actionTaken,
      'action': instance.action,
      'ruleType': instance.ruleType,
    };

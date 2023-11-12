/// Hive (NoSQL) Schema and JSON serialization functions
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'rulesCustomClass.g.dart';

@JsonSerializable()
@HiveType(typeId: 0) // Unique typeId for the Hive adapter
class Rules extends HiveObject{

  @HiveField(0)
  String startTime;
  @HiveField(1)
  String endTime;
  @HiveField(2)
  double temperatureThreshold;
  @HiveField(3)
  bool greaterThanTemperature;
  @HiveField(4)
  bool actionTaken;
  @HiveField(5)
  String action;
  @HiveField(6)
  int ruleType;

  Rules(this.startTime,  this.endTime, this.temperatureThreshold, this.greaterThanTemperature, this.actionTaken, this.action, this.ruleType);

  factory Rules.fromJson(Map<String, dynamic> json) => _$RulesFromJson(json);

  Map<String, dynamic> toJson() => _$RulesToJson(this);
  /**
   * SF - Superfan
   * AC - Air Conditioner
   * eg - SF5 -> superfan on 5
   * eg - AC26 -> ac on temperature 26 auto
   */
/**
 * Rule Type 1 - between time and temperature condition
 * Rule Type 2 - between time on different days and temp condition
 * Rule Type 3 - straight timer condiditon
 */

}

@HiveType(typeId: 1)
class listOfRules extends HiveObject{
  @HiveField(0)
  List<Rules> arrayOfRules;

  listOfRules(this.arrayOfRules);

}
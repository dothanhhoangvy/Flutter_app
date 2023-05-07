import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class DataModel {
  double? temperature;
  double? engine_speed;
  double? Fuel;
  double? Mileage;
  DataModel({this.temperature,this.engine_speed,this.Fuel,this.Mileage});

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      _$DataModelFromJson(json);
  Map<String, dynamic> toJson() => _$DataModelToJson(this);
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataModel _$DataModelFromJson(Map<String, dynamic> json) => DataModel(
      temperature: (json['temperature'] as num?)?.toDouble(),
      engine_speed: (json['engine_speed'] as num?)?.toDouble(),
      Fuel: (json['Fuel'] as num?)?.toDouble(),
      Mileage: (json['Mileage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DataModelToJson(DataModel instance) => <String, dynamic>{
      'temperature': instance.temperature,
      'engine_speed': instance.engine_speed,
      'Fuel': instance.Fuel,
      'Mileage': instance.Mileage,
    };

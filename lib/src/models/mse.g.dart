// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mse _$MseFromJson(Map<String, dynamic> json) => Mse(
      supervisor: json['supervisor'] as String,
      employees: (json['employees'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MseToJson(Mse instance) => <String, dynamic>{
      'supervisor': instance.supervisor,
      'employees': instance.employees.map((e) => e.toJson()).toList(),
    };

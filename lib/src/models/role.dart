library geiger_dummy_data;

import 'dart:convert';

import 'package:equatable/equatable.dart';
import '../constant/constant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable(explicitToJson: true)
class Role extends Equatable {
  final String? roleId;
  final String? name;

  Role({String? roleId, this.name}) : roleId = roleId ?? GeigerConstant.uuid;

  factory Role.fromJson(Map<String, dynamic> json) {
    return _$RoleFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RoleToJson(this);
  }

  /// convert to json string
  static String convertToJson(List<Role> roles) {
    List<Map<String, dynamic>> jsonData =
        roles.map((role) => role.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// pass [role] as a string
  static List<Role> fromJSon(String jsonArray) {
    List<dynamic> jsonData = jsonDecode(jsonArray);
    return jsonData.map((role) => Role.fromJson(role)).toList();
  }

  @override
  String toString() {
    super.toString();
    return '{"roleId":$roleId, "name":$name}';
  }

  @override
  List<Object?> get props => [roleId, name];
}

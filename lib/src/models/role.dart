library geiger_dummy_data;

import 'dart:convert';
import 'package:geiger_dummy_data/src/exceptions/custom_format_exception.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../constant/constant.dart';

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
    try {
      List<Map<String, dynamic>> jsonData =
          roles.map((role) => role.toJson()).toList();
      return jsonEncode(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message: "Fails to Convert List<Role> $roles to String");
    }
  }

  /// pass [role] as a string
  static List<Role> fromJSon(String roleJson) {
    try {
      List<dynamic> jsonData = jsonDecode(roleJson);
      return jsonData.map((role) => Role.fromJson(role)).toList();
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format for Role: $roleJson \n right String format:\n [{"roleId":"id","name":"threatName"}] \n Note: roleId is optional');
    }
  }

  @override
  String toString() {
    super.toString();
    return '{"roleId":$roleId, "name":$name}';
  }

  @override
  List<Object?> get props => [roleId, name];
}

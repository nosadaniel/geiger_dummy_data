import 'dart:convert';

import 'package:geiger_dummy_data/src/models/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String userId;
  String? firstName;
  String? lastName;
  String? knowledgeLevel;
  Role? role;

  User(this.userId,
      {this.firstName, this.lastName, this.knowledgeLevel, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }

  /// convert to json string
  static String convertToJson(List<User> users) {
    List<Map<String, dynamic>> jsonData =
        users.map((user) => user.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// pass [ThreatScore] as a string
  static List<User> fromJSon(String jsonArray) {
    List<dynamic> jsonData = jsonDecode(jsonArray);
    return jsonData.map((user) => User.fromJson(user)).toList();
  }

  @override
  String toString() {
    super.toString();
    return '{"userId":$userId, "firstName":$firstName, "lastName":$lastName, "role":$role}';
  }
}

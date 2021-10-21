import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geiger_dummy_data/src/models/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
//Equatable makes it easy to compare objects
class User extends Equatable {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? knowledgeLevel;
  final Role? role;

  User(
      {this.userId: "123user",
      this.firstName,
      this.lastName,
      this.knowledgeLevel,
      this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }

  /// convert from users List to String
  static String convertToJsonUserArray(List<User> users) {
    List<Map<String, dynamic>> jsonData =
        users.map((user) => user.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// converts jsonUserListString to List<User>
  static List<User> fromJSonUserList(String jsonArray) {
    List<dynamic> jsonData = jsonDecode(jsonArray);
    return jsonData.map((user) => User.fromJson(user)).toList();
  }

  /// convert from JsonUserString to User
  static User currentUserFromJSon(String json) {
    var jsonData = jsonDecode(json);
    return User.fromJson(jsonData);
  }

  /// convert from User to userString
  static String convertToJsonCurrentUser(User currentUser) {
    var jsonData = jsonEncode(currentUser);
    return jsonData;
  }

  @override
  String toString() {
    super.toString();
    return '{"userId":$userId,firstName":$firstName, "lastName":$lastName, "role":$role}';
  }

  @override
  List<Object?> get props =>
      [userId, firstName, lastName, knowledgeLevel, role];
}

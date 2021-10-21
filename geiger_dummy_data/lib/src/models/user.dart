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

  /// convert to json string
  static String convertToJson(List<User> users) {
    List<Map<String, dynamic>> jsonData =
        users.map((user) => user.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// pass list of User as a string
  static List<User> fromJSonUser(String jsonArray) {
    List<dynamic> jsonData = jsonDecode(jsonArray);
    return jsonData.map((user) => User.fromJson(user)).toList();
  }

  /// pass single User as a strong
  static User currentUserFromJSon(String json) {
    var jsonData = jsonDecode(json);
    return User.fromJson(jsonData);
  }

  //makes output data readable
  @override
  bool get stringify => true;

  @override
  List<Object?> get props =>
      [userId, firstName, lastName, knowledgeLevel, role];
}

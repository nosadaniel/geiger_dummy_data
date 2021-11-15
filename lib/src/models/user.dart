library geiger_dummy_data;

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/models/mse.dart';
import 'package:geiger_dummy_data/src/models/share_info.dart';
import 'package:json_annotation/json_annotation.dart';

import '/src/exceptions/custom_format_exception.dart';
import '/src/exceptions/custom_invalid_map_key_exception.dart';
import '/src/models/consent.dart';
import '/src/models/terms_and_conditions.dart';
import '../constant/constant.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
//Equatable makes it easy to compare objects
class User extends Equatable {
  final String userId;
  final String? userName;
  final String language;
  final bool? supervisor;
  final TermsAndConditions termsAndConditions;
  final Consent consent;
  final Device deviceOwner;
  final List<Device>? pairedDevices;
  final ShareInfo? shareInfo;
  final Mse? mse;

  User(
      {String? userId,
      this.userName,
      this.language: "en",
      this.supervisor: false,
      required this.termsAndConditions,
      required this.consent,
      required this.deviceOwner,
      this.pairedDevices,
      this.shareInfo,
      this.mse})
      : userId = userId ?? GeigerConstant.uuid;

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserFromJson(json);
    } catch (e) {
      throw CustomInvalidMapKeyException(message: e);
    }
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }

  /// convert from User List to User json
  static String convertUsersToJson(List<User> users) {
    try {
      // encode to json
      List<Map<String, dynamic>> jsonData =
          users.map((user) => user.toJson()).toList();
      return jsonEncode(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message: "Fails to Convert List<User> $users to json");
    }
  }

  ///// converts User List Json to List<User>
  // static List<User> convertUsersFromJson(String userJson) {
  //   try {
  //     List<dynamic> jsonData = jsonDecode(userJson);
  //     return jsonData.map((user) => User.fromJson(user)).toList();
  //   } on FormatException {
  //     throw CustomFormatException(
  //         message:
  //             '\n that is the wrong format for User: \n $userJson \n right String format:\n [{"userId":"value","firstName":"value", "lastName":"value", "role":{"roleId":"value", "name":"value"}}] \n Note: ids are optional');
  //   }
  // }

  /// convert from UserJson  to User
  static User convertUserFromJson(String json) {
    try {
      var jsonData = jsonDecode(json);
      return User.fromJson(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format for User: \n $json \n right String format:\n {"userId":"value","userName":"value", "language":"value", "owner":"value","termsAndConditions":{}, "consent":{} } \n Note: ids are optional');
    }
  }

  /// convert from User to UserJson
  static String convertUserToJson(User currentUser) {
    try {
      var jsonData = jsonEncode(currentUser);
      return jsonData;
    } on FormatException {
      throw CustomFormatException(
          message: "Fails to Convert User $currentUser to json");
    }
  }

  @override
  String toString() {
    super.toString();
    return '{"userId":$userId,"userName":$userName, "language":$language, "owner":$supervisor, "termsAndConditions":$termsAndConditions, "consent":$consent, "deviceOwner":$deviceOwner, "pairedDevices":$pairedDevices, "shareInfo": $shareInfo, "mse":$mse}';
  }

  @override
  List<Object?> get props => [
        userId,
        userName,
        language,
        supervisor,
        termsAndConditions,
        consent,
        deviceOwner,
        pairedDevices,
        shareInfo,
        mse
      ];
}

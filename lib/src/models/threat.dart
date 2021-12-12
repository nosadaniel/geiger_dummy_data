library geiger_dummy_data;

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '/src/exceptions/custom_format_exception.dart';
import '/src/exceptions/custom_invalid_map_key_exception.dart';
import '../constant/constant.dart';

part 'threat.g.dart';

@JsonSerializable(explicitToJson: true)
class Threat extends Equatable {
  final String? threatId;
  final String name;

  Threat({String? threatId, required this.name})
      : threatId = threatId ?? GeigerConstant.uuid;

  factory Threat.fromJson(Map<String, dynamic> map) {
    try {
      return _$ThreatFromJson(map);
    } catch (e) {
      throw CustomInvalidMapKeyException(message: e);
    }
  }

  Map<String, dynamic> toJson() {
    return _$ThreatToJson(this);
  }

  /// convert from threats List to Threat json
  static String convertToJson(List<Threat> threats) {
    try {
      List<Map<String, dynamic>> jsonData =
          threats.map((threat) => threat.toJson()).toList();
      return jsonEncode(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message: "Fails to Convert List<Threat> $threats to json");
    }
  }

  /// converts jsonThreatListJson to List<Threat>
  static List<Threat> convertFromJson(String threatJson) {
    try {
      List<dynamic> jsonData = jsonDecode(threatJson);
      return jsonData.map((threatMap) => Threat.fromJson(threatMap)).toList();
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format for Threat \n $threatJson \n right String format [{"threatId":"value","name":"value"}] \n Note: threatId is optional');
    }
  }

  /// convert from User to UserJson
  static String convertThreatToJson(Threat threat) {
    try {
      var jsonData = jsonEncode(threat);
      return jsonData;
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format for Threat \n $threat\n right String format [{"threatId":"value","name":"value"}] \n Note: threatId is optional');
    }
  }

  static Threat convertUserFromJson(String json) {
    try {
      var jsonData = jsonDecode(json);
      return Threat.fromJson(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format for Threat \n $json\n right String format [{"threatId":"value","name":"value"}] \n Note: threatId is optional');
    }
  }

  @override
  String toString() {
    super.toString();
    return '{"threatId":$threatId,"name":$name}';
  }

  @override
  List<Object?> get props => [threatId, name];
}

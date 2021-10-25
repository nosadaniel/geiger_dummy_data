library geiger_dummy_data;

import 'dart:convert';

import 'package:equatable/equatable.dart';
import '../constant/constant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'threat.g.dart';

@JsonSerializable(explicitToJson: true)
class Threat extends Equatable {
  final String? threatId;
  final String name;

  Threat({String? threatId, required this.name})
      : threatId = threatId ?? GeigerConstant.uuid;

  factory Threat.fromJson(Map<String, dynamic> map) {
    return _$ThreatFromJson(map);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatToJson(this);
  }

  /// convert from threats List to String
  static String convertToJson(List<Threat> threats) {
    List<Map<String, dynamic>> jsonData =
        threats.map((threat) => threat.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// converts jsonThreatListString to List<Threat>
  static List<Threat> fromJSon(String jsonArray) {
    List<dynamic> jsonData = jsonDecode(jsonArray);
    return jsonData.map((threatMap) => Threat.fromJson(threatMap)).toList();
  }

  @override
  String toString() {
    super.toString();
    return "{threatId:$threatId,name:$name}";
  }

  @override
  List<Object?> get props => [threatId, name];
}

//Todo
// throw FormatException for every model converter.

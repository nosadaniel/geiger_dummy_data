library geiger_dummy_data;

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'threat.g.dart';

@JsonSerializable(explicitToJson: true)
class Threat {
  String threatId;
  String name;

  Threat({required this.threatId, required this.name});

  factory Threat.fromJson(Map<String, dynamic> map) {
    return _$ThreatFromJson(map);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatToJson(this);
  }

  /// convert to json string
  static String convertToJson(List<Threat> threats) {
    List<Map<String, dynamic>> jsonData =
        threats.map((threat) => threat.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// pass [Threat] as a string
  static List<Threat> fromJSon(String json) {
    List<dynamic> jsonData = jsonDecode(json);
    return jsonData.map((threatMap) => Threat.fromJson(threatMap)).toList();
  }

  @override
  String toString() {
    super.toString();
    return "{threatId:$threatId,name:$name}";
  }
}

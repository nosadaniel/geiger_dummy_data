import 'package:json_annotation/json_annotation.dart';

part 'threat.g.dart';

@JsonSerializable(explicitToJson: true)
class Threat {
  String threatId;
  String name;

  Threat({required this.threatId, required this.name});

  factory Threat.fromJson(Map<String, dynamic> json) {
    return _$ThreatFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatToJson(this);
  }
}

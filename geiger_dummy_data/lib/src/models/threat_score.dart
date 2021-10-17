import 'package:json_annotation/json_annotation.dart';

import '/src/models/threat.dart';

part 'threat_score.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatScore {
  Threat threat;
  String score;
  ThreatScore({required this.threat, required this.score});

  factory ThreatScore.fromJson(Map<String, dynamic> json) {
    return _$ThreatScoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatScoreToJson(this);
  }
}

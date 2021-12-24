import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geiger_score_threats.g.dart';

@JsonSerializable(explicitToJson: true)
class GeigerScoreThreats {
  List<ThreatScore> threatScores;
  String geigerScore;

  GeigerScoreThreats({required this.threatScores, required this.geigerScore});

  factory GeigerScoreThreats.fromJson(Map<String, dynamic> json) {
    return _$GeigerScoreThreatsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeigerScoreThreatsToJson(this);
  }
}

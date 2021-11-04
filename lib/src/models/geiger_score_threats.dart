import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'geiger_score_threats.g.dart';

@JsonSerializable()
class GeigerScoreThreats extends Equatable {
  final List<ThreatScore> threatScores;
  final String geigerScore;

  GeigerScoreThreats({required this.threatScores, required this.geigerScore});

  factory GeigerScoreThreats.fromJson(Map<String, dynamic> json) {
    return _$GeigerScoreThreatsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeigerScoreThreatsToJson(this);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [threatScores, geigerScore];
}
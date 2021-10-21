import 'package:equatable/equatable.dart';
import 'package:geiger_dummy_data/src/models/threat_weight.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class Recommendation extends Equatable {
  final String recommendationId;
  final String recommendationType;
  final ThreatWeight threatWeight;
  final String short_description;
  final String? long_description;

  Recommendation(this.recommendationId, this.recommendationType,
      this.threatWeight, this.short_description, this.long_description);

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return _$RecommendationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RecommendationToJson(this);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

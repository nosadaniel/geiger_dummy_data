import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geiger_recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class GeigerRecommendation {
  final Threat threat;
  List<Recommendations> recommendations;

  GeigerRecommendation({required this.threat, required this.recommendations});
  factory GeigerRecommendation.fromJson(Map<String, dynamic> json) {
    return _$GeigerRecommendationFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$GeigerRecommendationToJson(this);
  }
}

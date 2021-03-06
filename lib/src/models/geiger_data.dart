import 'package:equatable/equatable.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geiger_data.g.dart';

@JsonSerializable(explicitToJson: true)
class GeigerData extends Equatable {
  final List<GeigerScoreThreats> geigerScoreThreats;
  final List<GeigerRecommendation> geigerRecommendations;

  GeigerData(
      {required this.geigerScoreThreats, required this.geigerRecommendations});

  factory GeigerData.fromJson(Map<String, dynamic> json) {
    return _$GeigerDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeigerDataToJson(this);
  }

  @override
  List<Object?> get props => [geigerScoreThreats, geigerRecommendations];
}

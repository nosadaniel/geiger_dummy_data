import 'package:equatable/equatable.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'threat_weight.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatWeight extends Equatable {
  final Threat threat;
  final String weight;

  ThreatWeight(this.threat, this.weight);

  factory ThreatWeight.fromJson(Map<String, dynamic> json) {
    return _$ThreatWeightFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatWeightToJson(this);
  }

  @override
  List<Object> get props => [threat, weight];
}

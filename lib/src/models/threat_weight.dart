import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import '../../geiger_dummy_data.dart';

part 'threat_weight.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatWeight extends Equatable {
  final Threat threat;
  final String weight;

  ThreatWeight({required this.threat, required this.weight});

  factory ThreatWeight.fromJson(Map<String, dynamic> json) {
    return _$ThreatWeightFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatWeightToJson(this);
  }

  @override
  String toString() {
    super.toString();
    return '{"threat":$threat, "weight":$weight }';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [threat, weight];
}

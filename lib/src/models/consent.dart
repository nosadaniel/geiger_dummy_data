import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consent.g.dart';

@JsonSerializable(explicitToJson: true)
class Consent extends Equatable {
  final bool dataAccess;
  final bool dataProcess;
  final bool cloudProcess;
  final bool toolProcess;

  Consent(
      {this.dataAccess: false,
      this.dataProcess: false,
      this.cloudProcess: false,
      this.toolProcess: false});

  factory Consent.fromJson(Map<String, dynamic> json) {
    return _$ConsentFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ConsentToJson(this);
  }

  @override
  String toString() {
    super.toString();
    return '{"dataAccess":$dataAccess,"dataProcess":$dataProcess, "cloudProcess":$cloudProcess, "toolProcess":$toolProcess }';
  }

  @override
  // TODO: implement props
  List<Object> get props =>
      [dataAccess, dataProcess, cloudProcess, toolProcess];
}

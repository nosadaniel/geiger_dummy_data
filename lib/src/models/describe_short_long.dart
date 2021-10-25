library geiger_dummy_data;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'describe_short_long.g.dart';

@JsonSerializable(explicitToJson: true)
class DescriptionShortLong extends Equatable {
  final String shortDescription;
  final String? longDescription;

  DescriptionShortLong({
    required this.shortDescription,
    this.longDescription,
  });

  factory DescriptionShortLong.fromJson(Map<String, dynamic> json) {
    return _$DescriptionShortLongFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DescriptionShortLongToJson(this);
  }

  @override
  String toString() {
    super.toString();
    return '{"shortDescription":$shortDescription, longDescription":$longDescription}';
  }

  @override
  List<Object?> get props => [shortDescription, longDescription];
}

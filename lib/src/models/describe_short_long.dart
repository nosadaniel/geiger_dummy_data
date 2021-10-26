library geiger_dummy_data;

import 'package:equatable/equatable.dart';
import '/src/exceptions/custom_invalid_map_key_exception.dart';
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
    try {
      return _$DescriptionShortLongFromJson(json);
    } catch (e) {
      throw CustomInvalidMapKeyException(message: e);
    }
  }

  Map<String, dynamic> toJson() {
    return _$DescriptionShortLongToJson(this);
  }

  @override
  String toString() {
    super.toString();
    return '{"shortDescription":$shortDescription, "longDescription":$longDescription}';
  }

  @override
  List<Object?> get props => [shortDescription, longDescription];
}

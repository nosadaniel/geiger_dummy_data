library geiger_dummy_data;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'ids.g.dart';

@JsonSerializable()
class Id extends Equatable {
  final String? uuid;

  Id({
    final String? uuid,
  }) : uuid = uuid ?? Uuid().v1();

  factory Id.fromJson(Map<String, dynamic> json) {
    return _$IdFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$IdToJson(this);
  }

  @override
  String toString() {
    return "{'uuid':$uuid}";
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uuid];
}

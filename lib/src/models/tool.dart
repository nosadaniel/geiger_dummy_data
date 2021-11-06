import 'package:json_annotation/json_annotation.dart';

import '/src/constant/constant.dart';

part 'tool.g.dart';

@JsonSerializable(explicitToJson: true)
class Tool {
  final String toolId;
  final String name;

  Tool({String? toolId, required this.name})
      : toolId = toolId ?? GeigerConstant.uuid;

  factory Tool.fromJson(Map<String, dynamic> json) {
    return _$ToolFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ToolToJson(this);
  }
}

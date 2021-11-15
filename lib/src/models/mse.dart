import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../geiger_dummy_data.dart';

part 'mse.g.dart';

@JsonSerializable(explicitToJson: true)
class Mse extends Equatable {
  final String supervisor;
  final List<User> employees;

  Mse({required this.supervisor, required this.employees});

  factory Mse.fromJson(Map<String, dynamic> json) {
    return _$MseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MseToJson(this);
  }

  @override
  List<Object?> get props => [supervisor, employees];
}

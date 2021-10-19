import 'dart:convert';

import 'package:geiger_dummy_data/src/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable(explicitToJson: true)
class Device {
  User owner;
  String deviceId;
  String? name;
  String? type;

  Device(this.owner, this.deviceId, this.name, this.type);

  factory Device.fromJson(Map<String, dynamic> json) {
    return _$DeviceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeviceToJson(this);
  }

  /// convert to json string
  static String convertToJson(List<Device> devices) {
    List<Map<String, dynamic>> jsonData =
        devices.map((device) => device.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// pass [Device] as a string
  static List<Device> fromJSon(String deviceArray) {
    List<dynamic> jsonData = jsonDecode(deviceArray);
    return jsonData.map((device) => Device.fromJson(device)).toList();
  }

  @override
  String toString() {
    super.toString();
    return '{"owner":$owner, "deviceId":$deviceId, "name":$name, "type":$type}';
  }
}

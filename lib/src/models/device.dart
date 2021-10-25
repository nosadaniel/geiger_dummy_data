library geiger_dummy_data;

import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../constant/constant.dart';
import '../models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable(explicitToJson: true)
class Device extends Equatable {
  final String? deviceId;
  final User owner;
  final String? name;
  final String? type;

  Device({required this.owner, String? deviceId, this.name, this.type})
      : deviceId = deviceId ?? GeigerConstant.uuid;

  factory Device.fromJson(Map<String, dynamic> json) {
    return _$DeviceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeviceToJson(this);
  }

  /// convert from devices List to String
  static String convertToJson(List<Device> devices) {
    List<Map<String, dynamic>> jsonData =
        devices.map((device) => device.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// converts jsonDeviceListString to List<Device>
  static List<Device> fromJSon(String deviceArray) {
    List<dynamic> jsonData = jsonDecode(deviceArray);
    return jsonData.map((device) => Device.fromJson(device)).toList();
  }

  /// convert from JsonDeviceString to User
  static Device currentDeviceFromJSon(String json) {
    var jsonData = jsonDecode(json);
    return Device.fromJson(jsonData);
  }

  /// convert from Device to deviceString
  static String convertToJsonCurrentDevice(Device currentDevice) {
    var jsonData = jsonEncode(currentDevice);
    return jsonData;
  }

  @override
  String toString() {
    super.toString();
    return '{"deviceId":$deviceId, "owner":$owner, "name":$name, "type":$type}';
  }

  @override
  List<Object?> get props => [deviceId, owner, name, type];
}

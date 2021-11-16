library geiger_dummy_data;

import 'dart:convert';

import 'package:geiger_dummy_data/src/models/tool.dart';
import 'package:json_annotation/json_annotation.dart';

import '/src/exceptions/custom_format_exception.dart';
import '/src/exceptions/custom_invalid_map_key_exception.dart';

part 'device.g.dart';

@JsonSerializable(explicitToJson: true)
class Device {
  String? deviceId;

  String? name;
  String? type;
  List<Tool>? tools;

  Device({this.deviceId, this.name, this.type, this.tools});

  factory Device.fromJson(Map<String, dynamic> json) {
    try {
      return _$DeviceFromJson(json);
    } catch (e) {
      throw CustomInvalidMapKeyException(message: e);
    }
  }

  Map<String, dynamic> toJson() {
    return _$DeviceToJson(this);
  }

  /// convert from Device List to Device json
  static String convertDevicesToJson(List<Device> devices) {
    try {
      List<Map<String, dynamic>> jsonData =
          devices.map((device) => device.toJson()).toList();
      return jsonEncode(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message: "Fails to Convert List<Device> $devices to json");
    }
  }

  // /// converts Device List Json to List<Device>
  // static List<Device> convertDevicesFromJson(String deviceJson) {
  //   try {
  //     List<dynamic> jsonData = jsonDecode(deviceJson);
  //     return jsonData.map((device) => Device.fromJson(device)).toList();
  //   } on FormatException {
  //     throw CustomFormatException(
  //         message:
  //             '\n that is the wrong format for Device: \n $deviceJson \n right String format:\n [{"owner":{},"deviceId":"value","name":"value","type":"value","tools":"value"}] \n Note: ids are optional');
  //   }
  // }

  /// convert from JsonDeviceJson to Device
  static Device convertDeviceFromJson(String json) {
    try {
      var jsonData = jsonDecode(json);
      return Device.fromJson(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format for Device: \n $json \n right String format: {"owner":{},"deviceId":"value","name":"value","type":"value"}} \n Note: ids are optional');
    }
  }

  /// convert from Device to deviceJson
  static String convertDeviceToJson(Device currentDevice) {
    try {
      var jsonData = jsonEncode(currentDevice);
      return jsonData;
    } on FormatException {
      throw CustomFormatException(
          message: "Fails to Convert Device $currentDevice to json");
    }
  }

  @override
  String toString() {
    super.toString();
    return '{"deviceId":$deviceId,  "name":$name, "type":$type, "tools":$tools}';
  }
}

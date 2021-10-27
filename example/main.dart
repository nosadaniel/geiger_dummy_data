import "package:geiger_dummy_data/geiger_dummy_data.dart";
import 'package:geiger_localstorage/geiger_localstorage.dart';

void main() {
  //initialize database
  StorageController _storageController =
      GenericController("Example", SqliteMapper("./example.db"));

  //set and get threat
  GeigerThreat _geigerThreat = GeigerThreat(_storageController);
  //set and get current user
  GeigerUser _geigerUser = GeigerUser(_storageController);
  //set and get current device
  GeigerDevice _geigerDevice = GeigerDevice(_storageController);

  //store and retrieve threats from :Global:threats
  // return a List of Threat object containing threatId and name.
  List<Threat> getThreatInfo() {
    try {
      return _geigerThreat.getThreats;
    } catch (e) {
      //threat Json format  '[{"threatId": "t1", name":"phishing"},{"threatId":"t2","name":"malware"}]'
      //Threat to convert your json to Threat object
      // threatId is optional: is auto generated.
      List<Threat> threatData =
          Threat.convertFromJson('[{"name":"phishing"},{"name":"malware"}]');

      //store threat in :Global:threats:
      _geigerThreat.setGlobalThreatsNode = threatData;

      return _geigerThreat.getThreats;
    }
  }

  //store and retrieve currentUserInfo from :Local "currentUser" NodeValue
  User getCurrentUser() {
    try {
      return _geigerUser.getCurrentUserInfo;
    } catch (e) {
      //set current user info
      User userData = User.convertUserFromJson(
          '{"firstName":"John", "lastName":"Doe", "role":{ "name":"CEO"}}');

      //store current user info
      _geigerUser.setCurrentUserInfo = userData;
      return _geigerUser.getCurrentUserInfo;
    }
  }

  //store  and retrieve currentDeviceInfo from :Local "currentDeviceNew NodeValue
  Device getCurrentDevice() {
    try {
      return _geigerDevice.getCurrentDeviceInfo;
    } catch (e) {
      //set current device info
      // format
      Device deviceData = Device.convertDeviceFromJson(
          '{"owner":${User.convertUserToJson(getCurrentUser())},"name":"Iphone","type":"mobile"}');

      //store current user info
      _geigerDevice.setCurrentDeviceInfo = deviceData;
      return _geigerDevice.getCurrentDeviceInfo;
    }
  }

  // display terminal threat info
  print(getThreatInfo());

  // display current user info in terminal
  print(getCurrentUser());

  //display current device info in terminal
  print(getCurrentDevice());
}

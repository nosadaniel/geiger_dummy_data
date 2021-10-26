import "package:geiger_dummy_data/geiger_dummy_data.dart";
import 'package:geiger_localstorage/geiger_localstorage.dart';



void main() {
  //initialize database
  StorageController _storageController =
  GenericController("Example", SqliteMapper("./database.db"));

  //set and get threats for :Global:threats
  GeigerThreat _geigerThreat = GeigerThreat(_storageController);

  // return a List of Threat object containing threatId and name.
  List<Threat> getThreat() {
    try {
      return _geigerThreat.getThreats;
    } catch (e) {
      //set using Threat object to convert your json
      // threatId is optional: is auto generated.
      _geigerThreat.setGlobalThreatsNode =
          Threat.convertFromJson('[{"name":"phishing"},{"name":"malware"}]');
      return _geigerThreat.getThreats;
    }
  }
  // print display output terminal
  print(getThreat());




  /*//device
  GeigerDevice geigerDevice = GeigerDevice(_storageController);
  //user
  GeigerUser geigerUser = GeigerUser(_storageController);

  //aggre
  GeigerAggregateScore geigerAggregateScore =
      GeigerAggregateScore(_storageController);
  //--start of currentUser
  print("//--start of currentUser");
  //set currentUser info in :Local NodeValue called "currentUser"
  geigerUser.setCurrentUserInfo = User.convertUserFromJson(
      '[{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}]');
  //get user info from :Local NodeValue called "currentUser"
  User user = geigerUser.getCurrentUserInfo;
  print(user);

  print("//-- end");
  // --- end of currentuser

  //---start of currentDevice

  print("//-- start of currentDevice");
  //set currentDevice info in :Local NodeValue called "currentDeviceNew"
  //can't store in currentDevice because it will run into error
  geigerDevice.setCurrentDeviceInfo = Device.currentDeviceFromJSon(
      '[{"owner":{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}},"deviceId":"d1","name":"SamSung","type":"Mobile"}]');
  //get currentDevice info from :Local NodeValue called "currentDeviceNew"
  print(geigerDevice.getCurrentDeviceInfo);

  print("//--end");
  // ----end of CurrentDevice

  // ----- start threats
  print("//-- start of threats");
  //set String of Threats in :Global:Threats
  print(geigerThreat.setGlobalThreatsNode = Threat.convertFromJson(
      '[{"threatId":"1","name":"phishing"},{"threatId":"2","name":"malware"}]'));
  //get List<Threat> of threat
  List<Threat> threats = geigerThreat.getThreats;
  print(threats);

  print("//--end");
  // ----- end threats

  // ---- start GeigerUserScore
  print("// ---start GeigerUserScore");
  //set currentUser threat score in Users:uuid:gi:data:GeigerUserScore
  geigerUser.setCurrentGeigerUserScoreNodeAndNodeValue(
      currentUser: user,
      threatScores: ThreatScore.convertFromJson(
          '[{"threat":{"threatId":"1","name":"phishing"}, "score":"12"}, {"threat":{"threatId":"2","name":"malware"},"score":"662"},{"threat":{"threatId":"2","name":"malware"},"score":"662"}]'));
  print("//-end");

  // -- end GeigerUserScore

  // --- start GeigerScoreAggregate
  print("// --start GeigerScoreAggregate");
  // set currentUser aggregate score in Users:uuid:gi:data:GeigerScoreAggregate
  geigerAggregateScore.setGeigerScoreAggregate(
      ThreatScore.convertFromJson(
          '[{"threat":{"threatId":"2","name":"malware"},"score":"662"}]'),
      user);
  print("//-end");*/
}

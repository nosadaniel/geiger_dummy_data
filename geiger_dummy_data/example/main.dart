import 'package:geiger_dummy_data/src/geiger_device.dart';
import 'package:geiger_dummy_data/src/geiger_threat.dart';
import 'package:geiger_dummy_data/src/geiger_user.dart';
import 'package:geiger_dummy_data/src/models/user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

void main() {
  StorageController _storageController =
      GenericController("owner43", SqliteMapper("./owner43.db"));
  GeigerDevice geigerDevice = GeigerDevice(_storageController);
  GeigerThreat geigerThreat = GeigerThreat(_storageController);
  GeigerUser geigerUser = GeigerUser(_storageController);

  //users

  geigerUser.setCurrentUser =
      '[{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}]';

  print("------");
  List<User> users = geigerUser.getCurrentUser();
  print(users);
  print("----");
  geigerDevice.setCurrentDevice =
      '[{"owner":{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}},"deviceId":"d1","name":"SamSung","type":"Mobile"}]';
  print("----");
  print(geigerDevice.getCurrentDevice());
  print("----");
  // print(geigerThreat.setGlobalThreatsNode =
  //     '[{"threatId":"1","name":"phishing"},{"threatId":"2","name":"malware"}]');
  //
  // print(geigerThreat.getThreats());

  //GeigerUserScore
  // geigerUser.setCurrentGeigerUserScoreNodeAndNodeValue(
  //     users,
  //     ThreatScore.fromJSon(
  //         '[{"threat":{"threatId":"1","name":"phishing"}, "score":"12"}, {"threat":{"threatId":"2","name":"malware"},"score":"662"},{"threat":{"threatId":"2","name":"malware"},"score":"662"}]'));
  //
  // //GeigerScoreAggregate
  // geigerUser.setGeigerScoreAggregate(
  //     ThreatScore.fromJSon(
  //         '[{"threat":{"threatId":"2","name":"malware"},"score":"662"}]'),
  //     users);
}

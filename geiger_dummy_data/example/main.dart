import 'package:geiger_dummy_data/src/initial_data.dart';
import 'package:geiger_dummy_data/src/models/threat.dart';
import 'package:geiger_dummy_data/src/models/threat_score.dart';
import 'package:geiger_dummy_data/src/models/user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

void main() {
  StorageController _storageController =
      GenericController("owner43", SqliteMapper("./owner43.db"));
  InitialData initialData = InitialData(_storageController);

  List<User> users = initialData.getCurrentUser(
      '[{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}]');
  print(users);

  initialData.setCurrentDevice =
      '[{"owner":{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}},"deviceId":"d1","name":"SamSung","type":"Mobile"}]';

  List<Threat> threats = initialData.getThreats(
      '[{"threatId":"1","name":"phishing"},{"threatId":"2","name":"malware"}]');
  print(threats);

  initialData.setCurrentGeigerUserScoreNode(
      users,
      ThreatScore.fromJSon(
          '[{"threat":{"threatId":"1","name":"phishing"}, "score":"12"}, {"threat":{"threatId":"2","name":"malware"},"score":"662"},{"threat":{"threatId":"2","name":"malware"},"score":"662"}]'));
  initialData.setGeigerScoreAggregate(
      ThreatScore.fromJSon(
          '[{"threat":{"threatId":"1","name":"phishing"}, "score":"12"}, {"threat":{"threatId":"2","name":"malware"},"score":"662"},{"threat":{"threatId":"2","name":"malware"},"score":"662"}]'),
      users);
}

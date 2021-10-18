import 'package:geiger_dummy_data/src/initial_data.dart';
import 'package:geiger_dummy_data/src/models/threat.dart';
import 'package:geiger_dummy_data/src/models/user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

void main() {
  StorageController _storageController =
      GenericController("owner43", SqliteMapper("./owner43.db"));
  InitialData initialData = InitialData(_storageController);

  List<User> users = initialData.getCurrentUser(
      '[{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}]');
  print(users);

  List<Threat> threats = initialData.getThreats(
      '[{"threatId":"1","name":"phishing"},{"threatId":"2","name":"malware"}]');
  print(threats);
}

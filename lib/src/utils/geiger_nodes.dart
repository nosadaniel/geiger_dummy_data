library geiger_dummy_data;

import 'package:geiger_localstorage/geiger_localstorage.dart';

//
class GeigerNodes {
  GeigerNodes(this._storageController);
  final StorageController _storageController;

  Future<Node> get getLocalNode async {
    return await _storageController.get(":Local");
  }

  Future<Node> get getGlobalNode async {
    return await _storageController.get(":Global");
  }

  /* List<Threat> get getGlobalThreats{

  }*/

}

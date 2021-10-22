library geiger_dummy_data;

import 'package:geiger_localstorage/geiger_localstorage.dart';

//
class GeigerNodes {
  GeigerNodes(this._storageController);
  final StorageController _storageController;

  Node get getLocalNode {
    return _storageController.get(":Local");
  }

  Node get getGlobalNode {
    return _storageController.get(":Global");
  }

  /* List<Threat> get getGlobalThreats{

  }*/

}

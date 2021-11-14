import 'package:geiger_localstorage/geiger_localstorage.dart';

void main() async {
  //initialize database
  StorageController _storageController =
      GenericController("Example", SqliteMapper("./example.db"));

  // //set and get threat
  // ThreatNode _geigerThreat = ThreatNode(_storageController);
  // //set and get current user
  // UserNode _geigerUser = UserNode(_storageController);
  // //set and get current device
  // DeviceNode _geigerDevice = DeviceNode(_storageController);
  //
  // //store and retrieve threats from :Global:threats
  // // return a List of Threat object containing threatId and name.
  // Future<List<Threat>> getThreatInfo() async {
  //   try {
  //     return await _geigerThreat.getThreats();
  //   } catch (e) {
  //     // threatId is optional: is auto generated.
  //     List<Threat> threatData = [
  //       Threat(name: "phishing"),
  //       Threat(name: "Malware")
  //     ];
  //
  //     //store threat in :Global:threats:
  //     _geigerThreat.setGlobalThreatsNode(threats: threatData);
  //
  //     return _geigerThreat.getThreats();
  //   }
  // }
  //
  // //store and retrieve currentUserInfo from :Local "currentUser" NodeValue
  // Future<User> getCurrentUser() async {
  //   try {
  //     return await _geigerUser.getUserInfo;
  //   } catch (e) {
  //     //set current user info
  //     User userData =
  //         User(termsAndConditions: TermsAndConditions(), consent: Consent());
  //
  //     //store current user info
  //     await _geigerUser.setUserInfo(userData);
  //     return _geigerUser.getUserInfo;
  //   }
  // }
  //
  // //store  and retrieve currentDeviceInfo from :Local "currentDeviceNew NodeValue
  // Future<Device> getCurrentDevice() async {
  //   try {
  //     return await _geigerDevice.getDeviceInfo;
  //   } catch (e) {
  //     //set current device info
  //     // format
  //     Device deviceData = Device(owner: await getCurrentUser());
  //
  //     //store current user info
  //     await _geigerDevice.setCurrentDeviceInfo(deviceData);
  //     return _geigerDevice.getDeviceInfo;
  //   }
  // }

  Future<void> setGlobalThreatsNode() async {
    List<String> threats = ["phishing", "malware"];
    List<String> threatid = ["t1", "t2"];
    try {
      for (int i = 0; i < threats.length; i++) {
        Node _node =
            await _storageController.get(':Global:threats:${threatid[i]}');
        //create a NodeValue
        NodeValue threatNodeValueName = NodeValueImpl("name", threats[i]);
        await _node.addOrUpdateValue(threatNodeValueName);
        await _storageController.update(_node);
      }
    } on StorageException {
      //log(":Global:threats not found");
      Node threatsNode = NodeImpl("threats", ":Global");
      await _storageController.addOrUpdate(threatsNode);

      for (int i = 0; i < threats.length; i++) {
        Node threatIdNode = NodeImpl("${threatid[i]}", ":Global:threats");
        //create :Global:threats:$threatId
        await _storageController.addOrUpdate(threatIdNode);
        //create a NodeValue
        NodeValue threatNodeValueName = NodeValueImpl("name", threats[i]);
        await threatIdNode.addOrUpdateValue(threatNodeValueName);
        await _storageController.update(threatIdNode);
      }
    }
  }

  Future<List<String>> getThreats({String language: "en"}) async {
    List<String> t = [];
    try {
      Node _node = await _storageController.get(":Global:threats");

      //return _node!.getChildNodesCsv();
      for (String threatId
          in await _node.getChildNodesCsv().then((value) => value.split(','))) {
        Node threatNode =
            await _storageController.get(":Global:threats:$threatId");

        t.add(await threatNode
            .getValue("name")
            .then((value) => value!.getValue(language)!));
      }
    } on StorageException {
      rethrow;
    }
    return t;
  }

  getListThreat() async {
    await setGlobalThreatsNode();
    await getThreats();
  }

  Future<String> getCurrentUserId() async {
    try {
      Node _node = await _storageController.get(":Local");
      String currentUser = await _node
          .getValue("currentUser")
          .then((value) => value!.getValue("en")!);
      return currentUser;
    } on StorageException {
      throw ("Node :Local not found");
    }
  }

  //print("Global Threats: ${getListThreat()}");
  print("CurrentUser Id : ${await getCurrentUserId()}");
  // // display terminal threat info
  // print("Threats: ${getThreatInfo()}");
  //
  // // display current user info in terminal
  // print("Current User: ${getCurrentUser()}");
  //
  // //display current device info in terminal
  // print("Current Device: ${getCurrentDevice()}");
}

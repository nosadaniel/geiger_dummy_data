
## Authors
- [Nosa Daniel Ahanor @FHNW](https://github.com/nosadaniel)

#GEIGER DUMMY DATA

This repository contains classes that provides methods to easily set and get data from the Node paths provided in the Geiger Indicator docs.

## Features
 - Receive data as a json object from a specific NodeValue path.
 - Access to functionality to help you serialized and deserialized data.
 - Set data according the Node path already defined in the geiger indicator docs.
 - Auto generation of uuids for userId, deviceId, threatId, recommendationId, roleId, etc.
 - Access to Data models
## Getting started
Run the following command in your terminal, to add the package in your pubspec.yaml 
```
  Flutter pub add geiger_dummy_data
  or
  dart pub add geiger_dummy_data
```

## Additional information for flutter users
Also run the following command in your terminal, to add the package in your pubspec.yaml
```
 flutter pub add sqlite3_flutter_libs
 flutter pub add sqflite 
 
 
```
## Usage

A short and useful examples for package users. Check `/example` folder for more details. 

```dart
import "package:geiger_dummy_data/geiger_dummy_data.dart";
import 'package:geiger_localstorage/geiger_localstorage.dart';

//flutter users only: uncomment the import lines below
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';



void main() {



  //flutter user only
  //initialize database
  void _iniDatabase() async{
    String dbPath = join(await getDatabasesPath(), 'database.db');
    StorageController _storageController = GenericController('Example', SqliteMapper(dbPath));
  }
  
  
  //dart users
  //initialize database
  StorageController _storageController =
  GenericController("Example", SqliteMapper("./database.db"));
  
  

  //set and get threats from :Global:threats
  GeigerThreat _geigerThreat = GeigerThreat(_storageController);

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
  // display in terminal
  print(getThreat());
}


```
Check `test/geiger_dummy_data_test` folder more demo

TODO:
 - Provide more functionality to set data and in the following Node path.
 - :EnterPrise:users
 - :Global:profile
 - :Local:plugin
 - :Users:userId:data:metrics
 - :Device:deviceId:data:metrics
 - Provide more data models
 - docs



TODO: This project is open to contribution and improvements


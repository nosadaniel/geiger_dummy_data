<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
#GEIGER DUMMY DATA

This repository contains classes that provides methods to easily set and get data from the Node paths provided in the Geiger Indicator docs.

## Features
 - set and Receive data as a json object.
 - Access to functionality that helps you to serialize and deserialize your data.
 - Set data in Node path, already provided in the geiger indicator docs.
 - Auto generation of uuids for userId, deviceId, threatId, recommendationId, roleId, etc.

## Getting started
run the following command in your terminal, to add the package in your pubspec.yaml 
```
  Flutter pub add geiger_dummy_data
  or
  dart pub add geiger_dummy_data
```

## Usage

A short and useful examples for package users. Check`/example` folder for more details. 

```dart
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
}


```
TODO: 

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.

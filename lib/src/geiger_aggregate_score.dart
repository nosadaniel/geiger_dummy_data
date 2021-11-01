library geiger_dummy_data;

import 'package:geiger_localstorage/geiger_localstorage.dart';

import '../geiger_dummy_data.dart';

/// GeigerAggregateScore Node path
class GeigerAggregateScore {
  StorageController _storageController;
  GeigerAggregateScore(this._storageController);

  Node? _node;

  /// get threats_score from :Users:uuid:gi:data:GeigerScoreAggregate
  List<ThreatScore> getGeigerScoreAggregate({String language: "en"}) {
    User currentUser = GeigerUser(_storageController).getCurrentUserInfo;
    _node = _storageController
        .get(":Users:${currentUser.userId}:gi:data:GeigerScoreAggregate");

    String threats_score =
        _node!.getValue("threats_score")!.getValue(language).toString();
    print(_node);
    return ThreatScore.convertFromJson(threats_score);
  }
}

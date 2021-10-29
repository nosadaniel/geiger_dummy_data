library geiger_dummy_data;

import 'package:geiger_localstorage/geiger_localstorage.dart';

import '../geiger_dummy_data.dart';

/// GeigerAggregateScore Node path
class GeigerAggregateScore {
  StorageController _storageController;
  GeigerAggregateScore(this._storageController);

  NodeValue? _geigerScore;
  NodeValue? _geigerThreatScores;
  NodeValue? _geigerNumMetrics;
  Node? _node;

  /// set GeigerAggregateScore Node in :Users:uuid:gi:data:GeigerScoreAggregate node path
  void setGeigerScoreAggregate(
      {required List<ThreatScore> threatScores,
      required User currentUser,
      String geigerScore: "0"}) {
    try {
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreAggregate");
      _setUserNodeValues(threatScores, geigerScore: geigerScore);
    } on StorageException {
      Node userNode = NodeImpl("${currentUser.userId}", ":Users");
      _storageController.addOrUpdate(userNode);
      Node giNode = NodeImpl("gi", ":Users:${currentUser.userId}");
      _storageController.addOrUpdate(giNode);
      Node nodeData = NodeImpl("data", ":Users:${currentUser.userId}:gi");
      _storageController.addOrUpdate(nodeData);

      Node aggScoreNode = NodeImpl(
          "GeigerScoreAggregate", ":Users:${currentUser.userId}:gi:data");
      _storageController.add(aggScoreNode);

      _setUserNodeValuesException(aggScoreNode, threatScores);
    }
  }

  /// get threats_score from :Users:uuid:gi:data:GeigerScoreAggregate
  List<ThreatScore> get getGeigerScoreAggregate {
    User currentUser = GeigerUser(_storageController).getCurrentUserInfo;
    _node = _storageController
        .get(":Users:${currentUser.userId}:gi:data:GeigerScoreAggregate");

    String threats_score =
        _node!.getValue("threats_score")!.getValue("en").toString();
    return ThreatScore.convertFromJson(threats_score);
  }

  void _setUserNodeValues(List<ThreatScore> threatScores,
      {String geigerScore: "0"}) {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    _node!.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));
    _node!.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    _node!.addOrUpdateValue(_geigerNumMetrics!);

    _storageController.update(_node!);
  }

  void _setUserNodeValuesException(Node aggScoreNode, threatScores,
      {String geigerScore: "0"}) {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    aggScoreNode.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));
    aggScoreNode.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());

    aggScoreNode.addOrUpdateValue(_geigerNumMetrics!);
    _storageController.update(aggScoreNode);
  }
}

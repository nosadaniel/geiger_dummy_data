import 'package:geiger_dummy_data/src/models/recommendation.dart';
import 'package:geiger_dummy_data/src/models/threat_weight.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class GeigerRecommendation {
  StorageController _storageController;
  GeigerRecommendation(this._storageController);

  Node? _node;

  /// set all threat in Global:threats node
  // Not tested
  void set setGlobalRecommendationsNode(List<Recommendation> recommendations) {
    try {
      for (Recommendation recommendation in recommendations) {
        _node = _storageController
            .get(':Global:recommendations:${recommendation.recommendationId}');
        //create a NodeValue
        _setThreatsNodeValue(recommendation);
      }
    } on StorageException {
      //log(":Global:threats not found");
      Node recommendationsNode = NodeImpl("recommendations", ":Global");
      _storageController.addOrUpdate(recommendationsNode);

      for (Recommendation recommendation in recommendations) {
        Node threatIdNode = NodeImpl(
            "${recommendation.recommendationId}", ":Global:recommendations");
        //create :Global:threats:$threatId
        _storageController.add(threatIdNode);
        //create a NodeValue
        _setThreatsNodeValueException(recommendation, threatIdNode);
      }
    }
  }

  void _setThreatsNodeValue(Recommendation recommendation) {
    //create a NodeValue
    NodeValue relatedThreatsWeightNodeValue = NodeValueImpl(
        "relatedThreatsWeights",
        ThreatWeight.convertToJson(recommendation.threatWeight));
    _node!.addOrUpdateValue(relatedThreatsWeightNodeValue);

    NodeValue recommendationType =
        NodeValueImpl("recommendationType", recommendation.recommendationType);
    _node!.addOrUpdateValue(recommendationType);
    NodeValue shortDescriptionNodeValue =
        NodeValueImpl("short", recommendation.shortDescription);
    _node!.addOrUpdateValue(shortDescriptionNodeValue);

    NodeValue longDescriptionNodeValue =
        NodeValueImpl("long", recommendation.longDescription.toString());
    _node!.addOrUpdateValue(longDescriptionNodeValue);

    _storageController.update(_node!);

    print(_node);
  }

  void _setThreatsNodeValueException(
      Recommendation recommendation, Node threatIdNode) {
    //create a NodeValue
    NodeValue relatedThreatWeightNodeValueName = NodeValueImpl(
        "relatedThreatsWeights",
        ThreatWeight.convertToJson(recommendation.threatWeight));
    threatIdNode.addOrUpdateValue(relatedThreatWeightNodeValueName);

    NodeValue recommendationType =
        NodeValueImpl("recommendationType", recommendation.recommendationType);
    _node!.addOrUpdateValue(recommendationType);

    NodeValue shortDescriptionNodeValue =
        NodeValueImpl("short", recommendation.shortDescription);
    _node!.addOrUpdateValue(shortDescriptionNodeValue);

    NodeValue longDescriptionNodeValue =
        NodeValueImpl("long", recommendation.longDescription.toString());
    _node!.addOrUpdateValue(longDescriptionNodeValue);
    _storageController.update(threatIdNode);
  }
}

//Todo
//Run test for setGlobalRecommendationsNode

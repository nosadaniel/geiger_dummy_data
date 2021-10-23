import 'package:geiger_dummy_data/src/constant/constant.dart';
import 'package:geiger_dummy_data/src/exceptions/weight_length_exception.dart';

import '/src/models/recommendation.dart';
import '/src/models/threat_weight.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import '/src/models/threat.dart';

class GeigerRecommendation {
  StorageController _storageController;
  GeigerRecommendation(this._storageController);

  Node? _node;

  /// set all recommendations in Global:recommendations node
  // Not tested
  void setGlobalRecommendationsNode(
      {required List<Recommendation> recommendations,
      required List<Threat> threats,
      required List<String> weights}) {
    List<ThreatsWeight> threatsWeight = [];
    try {
      for (Recommendation recommendation in recommendations) {
        _node = _storageController
            .get(':Global:recommendations:${recommendation.recommendationId}');

        if (threats.length == weights.length) {
          for (int i = 0; i < threats.length; i++) {
            threatsWeight
                .add(ThreatsWeight(threat: threats[i], weight: weights[i]));
          }
          //create a NodeValue
          _setThreatsNodeValue(recommendation, threatsWeight);
        } else {
          throw FormatException(
              'length of weights must to be equal to length of threats');
        }
      }
    } on StorageException {
      //log(":Global:threats not found");
      Node recommendationsNode = NodeImpl("recommendations", ":Global");
      _storageController.addOrUpdate(recommendationsNode);

      for (Recommendation recommendation in recommendations) {
        Node recomIdNode = NodeImpl(
            "${recommendation.recommendationId}", ":Global:recommendations");
        //create :Global:threats:$threatId
        _storageController.addOrUpdate(recomIdNode);
        if (threats.length == weights.length) {
          for (int i = 0; i < threats.length; i++) {
            threatsWeight
                .add(ThreatsWeight(threat: threats[i], weight: weights[i]));
          }
          _setThreatsNodeValueException(
              recommendation, recomIdNode, threatsWeight);
        } else {
          throw WeightLengthException();
        }
        //create a NodeValue

      }
    }
  }

  void _setThreatsNodeValue(
      Recommendation recommendation, List<ThreatsWeight> threatsWeight) {
    //create a NodeValue

    NodeValue relatedThreatsWeightNodeValue = NodeValueImpl(
        "relatedThreatsWeights", ThreatsWeight.convertToJson(threatsWeight));
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

  void _setThreatsNodeValueException(Recommendation recommendation,
      Node threatIdNode, List<ThreatsWeight> threatsWeight) {
    //create a NodeValue
    NodeValue relatedThreatWeightNodeValueName = NodeValueImpl(
        "relatedThreatsWeights", ThreatsWeight.convertToJson(threatsWeight));

    threatIdNode.addOrUpdateValue(relatedThreatWeightNodeValueName);

    NodeValue recommendationType =
        NodeValueImpl("recommendationType", recommendation.recommendationType);
    threatIdNode.addOrUpdateValue(recommendationType);

    NodeValue shortDescriptionNodeValue =
        NodeValueImpl("short", recommendation.shortDescription);
    threatIdNode.addOrUpdateValue(shortDescriptionNodeValue);

    NodeValue longDescriptionNodeValue =
        NodeValueImpl("long", recommendation.longDescription.toString());
    threatIdNode.addOrUpdateValue(longDescriptionNodeValue);
    _storageController.update(threatIdNode);
  }

  ///from return list of recommendations from localStorage
  List<Recommendation> get getRecommendations {
    List<Recommendation> r = [];

    _node = _storageController.get(":Global:recommendations");
    for (String recId in _node!.getChildNodesCsv().split(",")) {
      print(recId);
      Node recNode = _storageController.get(":Global:recommendations:$recId");
      r.add(Recommendation(
          recommendationId: recId,
          recommendationType:
              recNode.getValue("recommendationType")!.getValue("en").toString(),
          threatsWeight: ThreatsWeight.fromJSon(recNode
              .getValue("relatedThreatsWeights")!
              .getValue("en")
              .toString()),
          shortDescription:
              recNode.getValue("short")!.getValue("en").toString(),
          longDescription:
              recNode.getValue("long")!.getValue("en").toString()));
    }
    return r;
  }
}

//Todo
//Run test for setGlobalRecommendationsNode

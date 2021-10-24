import 'package:geiger_dummy_data/src/models/describe_short_long.dart';

import '../geiger_dummy_data.dart';
import '/src/models/recommendation.dart';
import '/src/models/related_threat_weight.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

import 'models/threat_recommendation.dart';

class GeigerRecommendation {
  StorageController _storageController;
  GeigerRecommendation(this._storageController);

  Node? _node;

  /// set all recommendations in Global:recommendations node
  // Not tested
  void setGlobalRecommendationsNode(
      {required List<Recommendation> recommendations}) {
    try {
      for (Recommendation recommendation in recommendations) {
        _node = _storageController
            .get(':Global:recommendations:${recommendation.recommendationId}');

        //create a NodeValue
        _setThreatsNodeValue(recommendation);
        //empty threats to avoid duplications
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
        //create a NodeValue
        _setThreatsNodeValueException(recommendation, recomIdNode);
        //empty threats to avoid duplications

      }
    }
  }

  void _setThreatsNodeValue(Recommendation recommendation) {
    //create a NodeValue

    NodeValue relatedThreatsWeightNodeValue = NodeValueImpl(
        "relatedThreatsWeights",
        RelatedThreatsWeight.convertToJson(
            recommendation.relatedThreatsWeight));

    _node!.addOrUpdateValue(relatedThreatsWeightNodeValue);

    NodeValue recommendationType =
        NodeValueImpl("recommendationType", recommendation.recommendationType);
    _node!.addOrUpdateValue(recommendationType);

    NodeValue short =
        NodeValueImpl("short", recommendation.description.shortDescription);
    _node!.addOrUpdateValue(short);

    NodeValue long = NodeValueImpl(
        "long", recommendation.description.longDescription.toString());
    _node!.addOrUpdateValue(long);

    _storageController.update(_node!);
  }

  void _setThreatsNodeValueException(
      Recommendation recommendation, Node recomIdNode) {
    //create a NodeValue
    NodeValue relatedThreatWeightNodeValueName = NodeValueImpl(
        "relatedThreatsWeights",
        RelatedThreatsWeight.convertToJson(
            recommendation.relatedThreatsWeight));

    recomIdNode.addOrUpdateValue(relatedThreatWeightNodeValueName);

    NodeValue recommendationType =
        NodeValueImpl("recommendationType", recommendation.recommendationType);
    recomIdNode.addOrUpdateValue(recommendationType);

    NodeValue short =
        NodeValueImpl("short", recommendation.description.shortDescription);
    recomIdNode.addOrUpdateValue(short);

    NodeValue long = NodeValueImpl(
        "long", recommendation.description.longDescription.toString());
    recomIdNode.addOrUpdateValue(long);

    _storageController.update(recomIdNode);
  }

  ///from return list of recommendations from localStorage
  List<Recommendation> get getRecommendations {
    List<Recommendation> r = [];

    _node = _storageController.get(":Global:recommendations");
    for (String recId in _node!.getChildNodesCsv().split(",")) {
      Node recNode = _storageController.get(":Global:recommendations:$recId");
      r.add(Recommendation(
        recommendationId: recId,
        recommendationType:
            recNode.getValue("recommendationType")!.getValue("en").toString(),
        relatedThreatsWeight: RelatedThreatsWeight.fromJSon(recNode
            .getValue("relatedThreatsWeights")!
            .getValue("en")
            .toString()),
        description: DescriptionShortLong(
            shortDescription:
                recNode.getValue("short")!.getValue("en").toString(),
            longDescription:
                recNode.getValue("long")!.getValue("en").toString()),
      ));
    }
    return r;
  }

  /// get list of threat recommendation
  List<ThreatRecommendation> getThreatRecommendation(
      {required Threat threat, required String recommendationType}) {
    List<ThreatRecommendation> t = [];
    List<Recommendation> recommendations = getRecommendations;
    _node = _storageController.get(":Global:recommendations");
    for (String recId in _node!.getChildNodesCsv().split(",")) {
      Node recNode = _storageController.get(":Global:recommendations:$recId");
      DescriptionShortLong descriptionShortLong = DescriptionShortLong(
          shortDescription:
              recNode.getValue("short")!.getValue("en").toString(),
          longDescription: recNode.getValue("long")!.getValue("en").toString());

      List<RelatedThreatsWeight> relatedThreatsWeight =
          RelatedThreatsWeight.fromJSon(recNode
              .getValue("relatedThreatsWeights")!
              .getValue("en")
              .toString());
      String type =
          recNode.getValue("recommendationType")!.getValue("en").toString();
      if (type == recommendationType) {
        for (RelatedThreatsWeight related in relatedThreatsWeight) {
          if (related.threatWeight.threat == threat) {
            t.add(ThreatRecommendation(
                recommendationId: recId,
                weight: related.threatWeight,
                descriptionShortLong: descriptionShortLong));
          }
        }
      }
    }
    return t;
  }
}

//Todo
//Run test for setGlobalRecommendationsNode

//ReportToMartin addOrUpdate(Node) works fine when 1st exception is throw
// but fails on when exception happens again

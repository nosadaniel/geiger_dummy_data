library geiger_dummy_data;

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../src/models/describe_short_long.dart';
import '../src/models/threat.dart';
import '../src/models/recommendation.dart';
import '../src/models/threat_recommendation.dart';
import '../src/models/threat_weight.dart';

/// <p>Grant access to methods relating recommendation.</p>
/// @param storageController
class RecommendationNode {
  StorageController _storageController;
  RecommendationNode(this._storageController);

  Node? _node;

  /// <p>set all recommendations in Global:recommendations node.</p>
  /// @param optional language locale object
  /// @Param list of recommendation object

  void setGlobalRecommendationsNode(
      {Locale? language, required List<Recommendation> recommendations}) {
    try {
      for (Recommendation recommendation in recommendations) {
        _node = _storageController
            .get(':Global:recommendations:${recommendation.recommendationId}');

        //create a NodeValue
        _setThreatsNodeValue(language, recommendation);
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
        _setThreatsNodeValueException(language, recommendation, recomIdNode);
        //empty threats to avoid duplications

      }
    }
  }

  void _setThreatsNodeValue(Locale? language, Recommendation recommendation) {
    //create a NodeValue

    NodeValue relatedThreatsWeightNodeValue = NodeValueImpl(
        "relatedThreatsWeights",
        ThreatWeight.convertToJson(recommendation.relatedThreatsWeight));

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

    if (language != null) {
      relatedThreatsWeightNodeValue.setValue(
          ThreatWeight.convertToJson(recommendation.relatedThreatsWeight),
          language);
      recommendationType.setValue(recommendation.recommendationType, language);
      short.setValue(recommendation.description.shortDescription, language);
      long.setValue(
          recommendation.description.longDescription.toString(), language);
    }

    _storageController.update(_node!);
  }

  void _setThreatsNodeValueException(
      Locale? language, Recommendation recommendation, Node recomIdNode) {
    //create a NodeValue
    NodeValue relatedThreatWeight = NodeValueImpl("relatedThreatsWeights",
        ThreatWeight.convertToJson(recommendation.relatedThreatsWeight));

    recomIdNode.addOrUpdateValue(relatedThreatWeight);

    NodeValue recommendationType =
        NodeValueImpl("recommendationType", recommendation.recommendationType);
    recomIdNode.addOrUpdateValue(recommendationType);

    NodeValue short =
        NodeValueImpl("short", recommendation.description.shortDescription);
    recomIdNode.addOrUpdateValue(short);

    NodeValue long = NodeValueImpl(
        "long", recommendation.description.longDescription.toString());
    recomIdNode.addOrUpdateValue(long);

    if (language != null) {
      relatedThreatWeight.setValue(
          ThreatWeight.convertToJson(recommendation.relatedThreatsWeight),
          language);
      recommendationType.setValue(recommendation.recommendationType, language);
      short.setValue(recommendation.description.shortDescription, language);
      long.setValue(
          recommendation.description.longDescription.toString(), language);
    }

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
        relatedThreatsWeight: ThreatWeight.convertFromJson(recNode
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

  /// <p> get list of threat recommendation</p>
  /// @param option language as string
  /// @param threat object
  /// @param recommendationType as string
  /// @return list of ThreatRecommendation object
  List<ThreatRecommendation> getThreatRecommendation(
      {String language: "en",
      required Threat threat,
      required String recommendationType}) {
    List<ThreatRecommendation> t = [];
    try {
      _node = _storageController.get(":Global:recommendations");
      for (String recId in _node!.getChildNodesCsv().split(",")) {
        Node recNode = _storageController.get(":Global:recommendations:$recId");
        DescriptionShortLong descriptionShortLong = DescriptionShortLong(
            shortDescription:
                recNode.getValue("short")!.getValue(language).toString(),
            longDescription:
                recNode.getValue("long")!.getValue(language).toString());

        List<ThreatWeight> relatedThreatsWeight = ThreatWeight.convertFromJson(
            recNode
                .getValue("relatedThreatsWeights")!
                .getValue(language)
                .toString());
        String type = recNode
            .getValue("recommendationType")!
            .getValue(language)
            .toString();
        if (type == recommendationType) {
          for (ThreatWeight related in relatedThreatsWeight) {
            if (related.threat == threat) {
              t.add(ThreatRecommendation(
                  recommendationId: recId,
                  threatWeight: related,
                  descriptionShortLong: descriptionShortLong));
            }
          }
        }
      }
      return t;
    } on StorageException {
      throw Exception("Node not Found");
    }
  }
}

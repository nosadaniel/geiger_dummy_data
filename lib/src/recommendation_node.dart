library geiger_dummy_data;

import 'package:geiger_dummy_data/src/models/geiger_recommendation.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../geiger_dummy_data.dart';
import '../src/models/describe_short_long.dart';
import '../src/models/recommendation.dart';

/// <p>Grant access to methods relating recommendation.</p>
/// @param storageController
class RecommendationNode {
  StorageController _storageController;
  RecommendationNode(this._storageController);

  Node? _node;

  /// <p>set all recommendations in Global:recommendations node.</p>
  /// @param optional language locale object
  /// @Param list of recommendation object

  Future<void> setGlobalRecommendationsNode(
      {Locale? language,
      required List<Threat> relatedThreat,
      required List<Recommendations> recommendations}) async {
    Node? node;
    Node? recomIdNode;
    NodeValue? nodeValue1;
    NodeValue? nodeValue2;
    NodeValue? nodeValue3;
    NodeValue? nodeValue4;

    Node _node = NodeImpl(":Global:recommendations", "owner");
    _storageController.addOrUpdate(_node);

    for (Recommendations recommendation in recommendations) {
      try {
        recomIdNode = await _storageController
            .get(':Global:recommendations:${recommendation.recommendationId}');
      } on StorageException {
        nodeValue1 =
            NodeValueImpl("relatedThreat", Threat.convertToJson(relatedThreat));

        recomIdNode = NodeImpl(
            ":Global:recommendations:${recommendation.recommendationId}",
            "owner");

        nodeValue2 = NodeValueImpl(
            "recommendationType", recommendation.recommendationType!);

        nodeValue3 =
            NodeValueImpl("short", recommendation.description.shortDescription);

        nodeValue4 = NodeValueImpl(
            "long", recommendation.description.longDescription.toString());
      }
      await recomIdNode.addOrUpdateValue(nodeValue1!);
      await recomIdNode.addOrUpdateValue(nodeValue2!);

      await recomIdNode.addOrUpdateValue(nodeValue3!);

      await recomIdNode.addOrUpdateValue(nodeValue4!);
      await _storageController.addOrUpdate(recomIdNode);
      print(recomIdNode);
    }
  }

  Future<void> _setThreatsNodeValue(
      Locale? language, Recommendations recommendation, Threat threat) async {
    //create a NodeValue

    NodeValue relatedThreat =
        NodeValueImpl("relatedThreat", Threat.convertThreatToJson(threat));
    await _node!.addOrUpdateValue(relatedThreat);

    NodeValue recommendationType =
        NodeValueImpl("recommendationType", recommendation.recommendationType!);
    await _node!.addOrUpdateValue(recommendationType);

    NodeValue short =
        NodeValueImpl("short", recommendation.description.shortDescription);
    await _node!.addOrUpdateValue(short);

    NodeValue long = NodeValueImpl(
        "long", recommendation.description.longDescription.toString());
    await _node!.addOrUpdateValue(long);
    await _storageController.update(_node!);
  }

  void _setThreatsNodeValueException(Locale? language,
      Recommendations recommendation, Node recomIdNode, Threat threat) async {
    //create a NodeValue

    NodeValue relatedThreat =
        NodeValueImpl("relatedThreat", Threat.convertThreatToJson(threat));
    await recomIdNode.addOrUpdateValue(relatedThreat);

    NodeValue recommendationType =
        NodeValueImpl("recommendationType", recommendation.recommendationType!);
    await recomIdNode.addOrUpdateValue(recommendationType);

    NodeValue short =
        NodeValueImpl("short", recommendation.description.shortDescription);
    await recomIdNode.addOrUpdateValue(short);

    NodeValue long = NodeValueImpl(
        "long", recommendation.description.longDescription.toString());
    await recomIdNode.addOrUpdateValue(long);
  }

  ///from return list of recommendations from localStorage
  Future<List<GeigerRecommendation>> get getRecommendations async {
    List<Recommendations> r = [];
    List<GeigerRecommendation> gR = [];
    _node = await _storageController.get(":Global:recommendations");
    print(_node);
    for (String recId
        in await _node!.getChildNodesCsv().then((value) => value.split(','))) {
      Node recNode =
          await _storageController.get(":Global:recommendations:$recId");
      print(recNode);
      String json = await recNode
          .getValue("relatedThreat")
          .then((value) => value!.getValue("en")!);

      List<Threat> threats = Threat.convertFromJson(json);
      r.add(Recommendations(
        recommendationId: recId,
        recommendationType: await recNode
            .getValue("recommendationType")
            .then((value) => value!.getValue("en")!),
        description: DescriptionShortLong(
            shortDescription: await recNode
                .getValue("short")
                .then((value) => value!.getValue("en")!),
            longDescription: await recNode
                .getValue("long")
                .then((value) => value!.getValue("en")!)),
      ));
      for (Threat threat in threats) {
        gR.add(GeigerRecommendation(threat: threat, recommendations: r));
      }
    }
    return gR;
  }

  // a problem
  //please don't use
  // ///set related Threats Weight recommendations
  // void setRelatedThreatsWeightInRecommendation(
  //     {required String recommendationId,
  //     required List<ThreatWeight> threatsWeight,
  //     required String recommendationType}) {
  //   _node =
  //       _storageController.get(':Global:recommendations:${recommendationId}');
  //
  //   NodeValue recoType =
  //       NodeValueImpl("recommendationType", recommendationType);
  //
  //   _node!.addOrUpdateValue(recoType);
  //
  //   NodeValue relatedThreatsWeightNodeValue = NodeValueImpl(
  //       "relatedThreatsWeights", ThreatWeight.convertToJson(threatsWeight));
  //   _node!.addOrUpdateValue(relatedThreatsWeightNodeValue);
  //
  //   _storageController.update(_node!);
  // }

  /// <p> get list of threat recommendation</p>
  /// @param option language as string
  /// @param recommendationType as string
  /// @return list of Recommendation object
  Future<GeigerRecommendation> getGeigerRecommendation(
      {required Threat threat, required List<Recommendations> r}) async {
    GeigerRecommendation gR;

    gR = GeigerRecommendation(threat: threat, recommendations: r);
    return gR;
  }
}

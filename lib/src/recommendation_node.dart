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

  // Future<void> setGlobalRecommendationsNode(
  //     {Locale? language,
  //     required List<Threat> relatedThreat,
  //     required List<Recommendations> recommendations}) async {
  //   Node? recomIdNode;
  //   NodeValue? nodeValue1;
  //   NodeValue? nodeValue2;
  //   NodeValue? nodeValue3;
  //   NodeValue? nodeValue4;
  //
  //   Node _node;
  //   try {
  //     _node = await _storageController.get(":Global:recommendations");
  //   } catch (e, s) {
  //     _node = NodeImpl(":Global:recommendations", "owner");
  //     _storageController.addOrUpdate(_node);
  //   }
  //
  //   for (Recommendations recommendation in recommendations) {
  //     try {
  //       recomIdNode = await _storageController
  //           .get(':Global:recommendations:${recommendation.recommendationId}');
  //       if (language != null) {
  //         nodeValue1 = await recomIdNode.getValue("relatedThreat");
  //         nodeValue1!.setValue(Threat.convertToJson(relatedThreat), language);
  //         nodeValue2 = await recomIdNode.getValue("recommendationType");
  //         nodeValue2!.setValue(recommendation.recommendationType!, language);
  //         nodeValue3 = await recomIdNode.getValue("short");
  //         nodeValue3!
  //             .setValue(recommendation.description.shortDescription, language);
  //         nodeValue4 = await recomIdNode.getValue("long");
  //         nodeValue4!
  //             .setValue(recommendation.description.longDescription!, language);
  //       }
  //     } on StorageException {
  //       recomIdNode = NodeImpl(
  //           ":Global:recommendations:${recommendation.recommendationId}",
  //           "owner");
  //
  //       nodeValue1 =
  //           NodeValueImpl("relatedThreat", Threat.convertToJson(relatedThreat));
  //
  //       nodeValue2 = NodeValueImpl(
  //           "recommendationType", recommendation.recommendationType!);
  //
  //       nodeValue3 =
  //           NodeValueImpl("short", recommendation.description.shortDescription);
  //
  //       nodeValue4 =
  //           NodeValueImpl("long", recommendation.description.longDescription!);
  //     }
  //     await recomIdNode.addOrUpdateValue(nodeValue1!);
  //     await recomIdNode.addOrUpdateValue(nodeValue2!);
  //
  //     await recomIdNode.addOrUpdateValue(nodeValue3!);
  //
  //     await recomIdNode.addOrUpdateValue(nodeValue4!);
  //     await _storageController.addOrUpdate(recomIdNode);
  //   }
  //
  //   print(recomIdNode);
  // }

  Future<void> setGlobalRecommendationsNode(
      {Locale? language,
      required List<Threat> relatedThreat,
      required List<Recommendations> recommendations}) async {
    try {
      for (Recommendations recommendation in recommendations) {
        _node = await _storageController
            .get(':Global:recommendations:${recommendation.recommendationId}');

        //create a NodeValue
        _setThreatsNodeValue(language, recommendation, relatedThreat);
        //empty threats to avoid duplications
      }
    } on StorageException {
      //log(":Global:threats not found");
      Node recommendationsNode = NodeImpl(":Global:recommendations", "owner");
      await _storageController.addOrUpdate(recommendationsNode);

      for (Recommendations recommendation in recommendations) {
        Node recomIdNode = NodeImpl(
            ":Global:recommendations:${recommendation.recommendationId}",
            "owner");
        //create :Global:threats:$threatId
        await _storageController.addOrUpdate(recomIdNode);
        //create a NodeValue
        _setThreatsNodeValueException(
            language, recommendation, recomIdNode, relatedThreat);
        //empty threats to avoid duplications

      }
    }
  }

  Future<void> _setThreatsNodeValue(Locale? language,
      Recommendations recommendation, List<Threat> relatedThreat) async {
    //create a NodeValue
    NodeValue nodeValue1 =
        NodeValueImpl("relatedThreat", Threat.convertToJson(relatedThreat));

    NodeValue nodeValue2 =
        NodeValueImpl("recommendationType", recommendation.recommendationType!);

    NodeValue nodeValue3 =
        NodeValueImpl("short", recommendation.description.shortDescription);

    NodeValue nodeValue4 =
        NodeValueImpl("long", recommendation.description.longDescription!);

    if (language != null) {
      nodeValue1.setValue(Threat.convertToJson(relatedThreat), language);
      nodeValue2.setValue(recommendation.recommendationType!, language);
      nodeValue3.setValue(
          recommendation.description.shortDescription, language);
      nodeValue4.setValue(
          recommendation.description.longDescription.toString(), language);
    }
    await _storageController.update(_node!);
  }

  void _setThreatsNodeValueException(
      Locale? language,
      Recommendations recommendation,
      Node recomIdNode,
      List<Threat> relatedThreat) async {
    //create a NodeValue
    //create a NodeValue
    NodeValue nodeValue1 =
        NodeValueImpl("relatedThreat", Threat.convertToJson(relatedThreat));

    NodeValue nodeValue2 =
        NodeValueImpl("recommendationType", recommendation.recommendationType!);

    NodeValue nodeValue3 =
        NodeValueImpl("short", recommendation.description.shortDescription);

    NodeValue nodeValue4 =
        NodeValueImpl("long", recommendation.description.longDescription!);

    if (language != null) {
      nodeValue1.setValue(Threat.convertToJson(relatedThreat), language);
      nodeValue2.setValue(recommendation.recommendationType!, language);
      nodeValue3.setValue(
          recommendation.description.shortDescription, language);
      nodeValue4.setValue(
          recommendation.description.longDescription.toString(), language);
    }
    await recomIdNode.addOrUpdateValue(nodeValue1);
    await recomIdNode.addOrUpdateValue(nodeValue2);
    await recomIdNode.addOrUpdateValue(nodeValue3);
    await recomIdNode.addOrUpdateValue(nodeValue4);
    await _storageController.addOrUpdate(recomIdNode);
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

library geiger_dummy_data;

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../src/models/describe_short_long.dart';
import '../src/models/recommendation.dart';
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

  Future<void> setGlobalRecommendationsNode(
      {Locale? language, required List<Recommendation> recommendations}) async {
    try {
      for (Recommendation recommendation in recommendations) {
        _node = await _storageController
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

  Future<void> _setThreatsNodeValue(
      Locale? language, Recommendation recommendation) async {
    //create a NodeValue
    if (recommendation.relatedThreatsWeight != null &&
        recommendation.recommendationType != null) {
      NodeValue relatedThreatsWeightNodeValue = NodeValueImpl(
          "relatedThreatsWeights",
          ThreatWeight.convertToJson(recommendation.relatedThreatsWeight!));

      _node!.addOrUpdateValue(relatedThreatsWeightNodeValue);

      NodeValue recommendationType = NodeValueImpl(
          "recommendationType", recommendation.recommendationType!);
      _node!.addOrUpdateValue(recommendationType);

      NodeValue short =
          NodeValueImpl("short", recommendation.description.shortDescription);
      _node!.addOrUpdateValue(short);

      NodeValue long = NodeValueImpl(
          "long", recommendation.description.longDescription.toString());
      _node!.addOrUpdateValue(long);

      if (language != null) {
        relatedThreatsWeightNodeValue.setValue(
            ThreatWeight.convertToJson(recommendation.relatedThreatsWeight!),
            language);
        recommendationType.setValue(
            recommendation.recommendationType!, language);
        short.setValue(recommendation.description.shortDescription, language);
        long.setValue(
            recommendation.description.longDescription.toString(), language);
      }
    } else {
      NodeValue short =
          NodeValueImpl("short", recommendation.description.shortDescription);
      _node!.addOrUpdateValue(short);

      NodeValue long = NodeValueImpl(
          "long", recommendation.description.longDescription.toString());
      _node!.addOrUpdateValue(long);
    }

    _storageController.update(_node!);
  }

  void _setThreatsNodeValueException(
      Locale? language, Recommendation recommendation, Node recomIdNode) {
    //create a NodeValue
    if (recommendation.relatedThreatsWeight != null &&
        recommendation.recommendationType != null) {
      NodeValue relatedThreatWeight = NodeValueImpl("relatedThreatsWeights",
          ThreatWeight.convertToJson(recommendation.relatedThreatsWeight!));

      recomIdNode.addOrUpdateValue(relatedThreatWeight);

      NodeValue recommendationType = NodeValueImpl(
          "recommendationType", recommendation.recommendationType!);
      recomIdNode.addOrUpdateValue(recommendationType);

      NodeValue short =
          NodeValueImpl("short", recommendation.description.shortDescription);
      recomIdNode.addOrUpdateValue(short);

      NodeValue long = NodeValueImpl(
          "long", recommendation.description.longDescription.toString());
      recomIdNode.addOrUpdateValue(long);

      if (language != null) {
        relatedThreatWeight.setValue(
            ThreatWeight.convertToJson(recommendation.relatedThreatsWeight!),
            language);
        recommendationType.setValue(
            recommendation.recommendationType!, language);
        short.setValue(recommendation.description.shortDescription, language);
        long.setValue(
            recommendation.description.longDescription.toString(), language);
      }
    } else {
      NodeValue short =
          NodeValueImpl("short", recommendation.description.shortDescription);
      recomIdNode.addOrUpdateValue(short);

      NodeValue long = NodeValueImpl(
          "long", recommendation.description.longDescription.toString());
      recomIdNode.addOrUpdateValue(long);
    }

    _storageController.update(recomIdNode);
  }

  ///from return list of recommendations from localStorage
  Future<List<Recommendation>> get getRecommendations async {
    List<Recommendation> r = [];

    _node = await _storageController.get(":Global:recommendations");
    for (String recId
        in await _node!.getChildNodesCsv().then((value) => value.split(','))) {
      Node recNode =
          await _storageController.get(":Global:recommendations:$recId");

      if (await recNode.getValue("recommendationType") != null &&
          await recNode.getValue("relatedThreatsWeights") != null) {
        r.add(Recommendation(
          recommendationId: recId,
          recommendationType: await recNode
              .getValue("recommendationType")
              .then((value) => value!.getValue("en")!),
          relatedThreatsWeight: ThreatWeight.convertFromJson(await recNode
              .getValue("relatedThreatsWeights")
              .then((value) => value!.getValue("en")!)),
          description: DescriptionShortLong(
              shortDescription: await recNode
                  .getValue("short")
                  .then((value) => value!.getValue("en")!),
              longDescription: await recNode
                  .getValue("long")
                  .then((value) => value!.getValue("en")!)),
        ));
      } else {
        r.add(Recommendation(
          recommendationId: recId,
          description: DescriptionShortLong(
              shortDescription: await recNode
                  .getValue("short")
                  .then((value) => value!.getValue("en")!),
              longDescription: await recNode
                  .getValue("long")
                  .then((value) => value!.getValue("en")!)),
        ));
      }
    }
    return r;
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
  Future<List<Recommendation>> getThreatRecommendation(
      {String language: "en", required String recommendationType}) async {
    List<Recommendation> r = [];
    try {
      _node = await _storageController.get(":Global:recommendations");
      for (String recId in await _node!
          .getChildNodesCsv()
          .then((value) => value.split(","))) {
        Node recNode =
            await _storageController.get(":Global:recommendations:$recId");
        DescriptionShortLong descriptionShortLong = DescriptionShortLong(
            shortDescription: await recNode
                .getValue("short")
                .then((value) => value!.getValue(language)!),
            longDescription: await recNode
                .getValue("long")
                .then((value) => value!.getValue(language)!));

        if (await recNode.getValue("recommendationType") != null &&
            await recNode.getValue("relatedThreatsWeights") != null) {
          List<ThreatWeight> relatedThreatsWeight =
              ThreatWeight.convertFromJson(await recNode
                  .getValue("relatedThreatsWeights")
                  .then((value) => value!.getValue(language)!));
          String type = await recNode
              .getValue("recommendationType")
              .then((value) => value!.getValue(language)!);
          if (type == recommendationType) {
            r.add(Recommendation(
                recommendationId: recId,
                description: descriptionShortLong,
                relatedThreatsWeight: relatedThreatsWeight,
                recommendationType: type));
          }
        }
      }
      return r;
    } on StorageException {
      throw Exception("Node not Found");
    }
  }
}

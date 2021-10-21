import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/geiger_aggregate_score.dart';
import 'package:geiger_dummy_data/src/geiger_user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:test/test.dart';

void main() {
  StorageController _storageController =
      GenericController("test", SqliteMapper("./test.db"));

  // geigerUserTest
  GeigerUserTest geigerUserTest = GeigerUserTest(_storageController);
  geigerUserTest.currentUserGroupTest();

  //aggregateTest
  GeigerAggregateScoreTest geigerAggregateScoreTest =
      GeigerAggregateScoreTest(_storageController);
  geigerAggregateScoreTest.aggregateScoreTest();
}

class GeigerUserTest {
  StorageController _storageController;
  GeigerUserTest(this._storageController);

  void currentUserGroupTest() {
    GeigerUser geigerUser = GeigerUser(_storageController);
    group("currentUserGroupTest:", () {
      setUp(() {
        //setCurrentUser
        geigerUser.setCurrentUser =
            '{"firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}';

        //setCurrentGeigerUserScore
        geigerUser.setCurrentGeigerUserScoreNodeAndNodeValue(
            geigerUser.getCurrentUser,
            ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"}]'),
            geigerScore: "50");
      });

      test("getCurrentUser", () {
        expect(
            geigerUser.getCurrentUser,
            equals(User.currentUserFromJSon(
                '{ "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}')));
      });

      test("getCurrentUserGeigerThreatScore", () {
        expect(
            geigerUser.getCurrentGeigerUserThreatScores,
            equals(ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"}]')));
      });

      test("getCurrentUserGeigerScore", () {
        expect(geigerUser.getCurrentGeigerUserScore, equals("50"));
      });
    });
  }
}

class GeigerAggregateScoreTest {
  StorageController _storageController;
  GeigerAggregateScoreTest(this._storageController);

  void aggregateScoreTest() {
    group("GeigerAggregateScore", () {
      setUp(() {
        //set
        GeigerAggregateScore(_storageController).setGeigerScoreAggregate(
            ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"},{"threat":{"threatId":"w1","name":"malware"},"score":"45"}]'),
            GeigerUser(_storageController).getCurrentUser);
      });

      test("getGeigerAggregateThreatScore", () {
        expect(
            GeigerAggregateScore(_storageController).getGeigerScoreAggregate,
            equals(ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"},{"threat":{"threatId":"w1","name":"malware"},"score":"45"}]')));
      });
    });
  }
}

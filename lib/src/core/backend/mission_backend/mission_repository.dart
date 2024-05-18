import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/model/mission.dart';
import 'package:get/get.dart';

class MissionRepository extends GetxController {
  static MissionRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createMission(Mission mission) {
    _db
        .collection("Missions")
        .add(mission.toJson())
        .whenComplete(() => Get.snackbar(
              "Success",
              "Mission created successfully",
              snackPosition: SnackPosition.BOTTOM,
              colorText: AppColor.mainAppColor,
              backgroundColor: AppColor.mainAppColor,
            ))
        .catchError((error) {
      Get.snackbar(
        "Error",
        "Failed to create mission, try again",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColor.mainAppColor,
        backgroundColor: AppColor.mainAppColor,
      );
    });
  }

  Future<void> updateMission(Mission mission) async {
    await _db.collection("Missions").doc().update(mission.toJson());
  }

  Future<Mission> getMissionDetails(String missionName) async {
    final snapshot = await _db
        .collection("Missions")
        .where("missionName", isEqualTo: missionName)
        .get();
    final missionData =
        snapshot.docs.map((e) => Mission.fromJson(e.data())).single;
    return missionData;
  }

  Future<bool> missionExists(String missionName) async {
    try {
      QuerySnapshot missionSnapshot = await _db
          .collection('Missions')
          .where('missionName', isEqualTo: missionName)
          .get();

      return missionSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking mission existence: $e');
      return false;
    }
  }

  Future<List<Mission>> getUserMissions(String userEmail) async {
    List<Mission> userMissions = [];

    try {
      QuerySnapshot missionSnapshot = await _db
          .collection('Missions')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      userMissions = missionSnapshot.docs
          .map((doc) => Mission.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user missions: $e');
    }

    return userMissions;
  }
}

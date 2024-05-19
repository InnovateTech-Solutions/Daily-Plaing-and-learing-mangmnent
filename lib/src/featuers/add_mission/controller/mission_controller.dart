import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/mission_backend/mission_repository.dart';
import 'package:demogp/src/core/model/mission.dart';
import 'package:demogp/src/featuers/add_mission/view/mession_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionController extends GetxController {
  TextEditingController missionNameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController pdfPathController = TextEditingController();
  final MissionRepository _missionRepository = MissionRepository.instance;
  final addformkey = GlobalKey<FormState>();
  RxList<Mission> userMissions = <Mission>[].obs;

  clear() {
    missionNameController.clear();

    typeController.clear();
    startDateController.clear();
    endDateController.clear();
    pdfPathController.clear();
    statusController.clear();
  }

  validateDescription(String? title) {
    if (title!.isNotEmpty) {
      return null;
    }
    return 'Description is not vaild';
  }

  void createMission(Mission mission) {
    _missionRepository.createMission(mission);
    userMissions.add(mission);
  }

  void updateMission(Mission mission) {
    _missionRepository.updateMission(mission);
  }

  Future<void> fetchUserMissions(String userEmail) async {
    final missions = await _missionRepository.getUserMissions(userEmail);
    userMissions.value = missions;
  }

  vaildateServue(String? userName) {
    if (GetUtils.isUsername(userName!)) {
      return null;
    }
    return 'UserName is not vaild';
  }

  vaildateFild(dynamic text) {
    if (GetUtils.isBlank(text!)!) {
      return null;
    }
    return 'UserName is not vaild';
  }

  notEmpty(controller) {
    return controller?.text != null && controller.text.isNotEmpty;
  }

  onadd(Mission mission) {
    if (addformkey.currentState!.validate()) {
      createMission(mission);
      Get.off(MissionViewTest(userEmail: mission.userEmail));
      Get.snackbar("Success", "Added successfult",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.success);
      clear();
    } else if (typeController.text.isEmpty) {
      Get.snackbar("ERROR", "please chose the type",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.error);
    } else {
      Get.snackbar("ERROR", "invild form",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.error);
    }
  }

  @override
  void onClose() {
    // Close resources here if necessary
    super.onClose();
  }
}

// ignore_for_file: avoid_print

import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/authentication/authentication.dart';
import 'package:demogp/src/core/backend/user_repository/user_repository.dart';
import 'package:demogp/src/core/model/user_model.dart';
import 'package:get/get.dart';

class ProfileRepository extends GetxController {
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to get email");
    }
  }

  updateRecord(UserModel user) async {
    try {
      print(' User data : ${user.email}');
      await _userRepo.updateUserRecord(user);
      Get.snackbar("Success", " Account  Created Successfullly",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.success);
    } catch (e) {
      rethrow;
    }
  }
}

// ignore_for_file: unnecessary_null_comparison, body_might_complete_normally_catch_error, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/controller/user_controller.dart';
import 'package:demogp/src/core/model/user_model.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final userController = Get.put(UserController());

  final _db = FirebaseFirestore.instance;

  late UserModel userModel;

  void setUserModel(UserModel userModel) {
    this.userModel = userModel;
  }

  createUser(UserModel user) {
    _db
        .collection("User")
        .add(user.tojason())
        .whenComplete(() => Get.snackbar(
            "Success", "Your account has been created",
            snackPosition: SnackPosition.BOTTOM,
            colorText: AppColor.mainAppColor,
            backgroundColor: AppColor.mainAppColor))
        .catchError((error) {
      Get.snackbar(error.toString(), "Something went wrong , try agin",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.mainAppColor);
    });
  }

  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("User").doc(user.id).update(user.tojason());
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("User").where("Email", isEqualTo: email).get();
    final userdata = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    userModel = userdata;
    userController.saveUserInfo(userdata);
    return userdata;
  }

// to see if user is Exits to make google , Apple Authentication
  Future<bool> userExist(String email) async {
    try {
      CollectionReference users = _db.collection('users');

      QuerySnapshot userSnapshot =
          await users.where('Email', isEqualTo: email).get();

      return userSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    bool exists = false;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User') // Replace with your actual collection name
          .where('Email', isEqualTo: email)
          .get();

      exists = querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email existence: $e');
    }

    return exists;
  }
}

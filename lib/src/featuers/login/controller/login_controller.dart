import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/authentication/authentication.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final formkey = GlobalKey<FormState>();
  final rmkey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  validateEmail(String? email) {
    if (GetUtils.isEmail(email!)) {
      return null;
    }
    return 'Email is not vaild';
  }

  vaildatePassword(String? password) {
    if (!GetUtils.isLengthGreaterOrEqual(password, 6)) {
      return 'Password is not vaild';
    }
    return null;
  }

  Future onLogin() async {
    if (formkey.currentState!.validate()) {
      Future<bool> code = AuthenticationRepository()
          .login(email.text.trim(), password.text.trim());
      if (await code) {
        Get.snackbar("Success", "Login Successful",
            snackPosition: SnackPosition.BOTTOM,
            colorText: AppColor.mainAppColor,
            backgroundColor: AppColor.success);
      } else {
        Get.snackbar("ERROR", "Email or Password is invild",
            snackPosition: SnackPosition.BOTTOM,
            colorText: AppColor.mainAppColor,
            backgroundColor: AppColor.error);
      }
      return;
    } else {
      Get.snackbar("ERROR", "Email or Password is invild",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.error);
    }
  }
}

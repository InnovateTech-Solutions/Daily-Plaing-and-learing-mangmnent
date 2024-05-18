import 'package:demogp/src/core/backend/authentication/authentication.dart';
import 'package:demogp/src/core/controller/user_controller.dart';
import 'package:demogp/src/featuers/profile/model/profile_button_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

class ProfileController extends GetxController {
  List<ProfileButton> profileList = [
    ProfileButton(
        title: 'My Reminder',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () =>
            Get.to(const Scaffold(), transition: Transition.rightToLeft)),
    ProfileButton(
        title: 'my Tasks',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () =>
            Get.to(const Scaffold(), transition: Transition.rightToLeft)),
                ProfileButton(
        title: 'my assigment',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () =>
            Get.to(const Scaffold(), transition: Transition.rightToLeft)),
    ProfileButton(
        title: 'About',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () {}),
    ProfileButton(
      title: 'Logout',
      icon: SvgPicture.asset(
        'assets/arrow.svg',
        matchTextDirection: true,
        width: 15,
        height: 15,
      ),
      onTap: () => {
        AuthenticationRepository().logout(),
        UserController.instance.clearUserInfo()
      },
    ),
  ];
}

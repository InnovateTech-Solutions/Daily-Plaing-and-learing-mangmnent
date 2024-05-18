import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/user_repository/user_repository.dart';
import 'package:demogp/src/core/model/user_model.dart';
import 'package:demogp/src/featuers/profile/controller/profile_controller.dart';
import 'package:demogp/src/featuers/profile/repository/profile_repository.dart';
import 'package:demogp/src/featuers/profile/widget/profile_container.dart';
import 'package:demogp/src/featuers/update_profile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final userController = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    final controllerr = Get.put(ProfileController());
    final profileController = Get.put(ProfileRepository());
    return FutureBuilder(
      future: Future.delayed(
        const Duration(milliseconds: 500),
        () => profileController.getUserData(),
      ),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          if (snapShot.hasData) {
            UserModel userData = snapShot.data as UserModel;
            final userName = TextEditingController(text: userData.name);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Column(
                      children: [
                        const Gap(20),
                        Text(userName.text,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: AppColor.buttonColor))),
                        const Gap(20),
                        Divider(
                          thickness: 2,
                          color: AppColor.subappcolor,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(const UpdateUserWidget());
                          },
                          child: Text('VIEW Profile',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.buttonColor))),
                        ),
                      ],
                    ),
                    const Gap(10),
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controllerr.profileList.length,
                        itemBuilder: ((context, index) {
                          return profileContainer(
                              controllerr.profileList[index]);
                        }),
                        separatorBuilder: (BuildContext context, int index) {
                          return const Gap(30);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapShot.hasError) {
            return Center(child: Text('Error${snapShot.error}'));
          } else {
            return const Text('somthing was wrong ');
          }
        } else if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Text("somthing went wrong");
        }
      },
    );
  }
}

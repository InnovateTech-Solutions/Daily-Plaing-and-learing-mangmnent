// ignore_for_file: avoid_print

import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/user_repository/user_repository.dart';
import 'package:demogp/src/core/model/form_model.dart';
import 'package:demogp/src/core/model/user_model.dart';
import 'package:demogp/src/core/widget/form/form_widget.dart';
import 'package:demogp/src/featuers/login/view/login_page.dart';
import 'package:demogp/src/featuers/profile/repository/profile_repository.dart';
import 'package:demogp/src/featuers/profile/widget/profile_container.dart';
import 'package:demogp/src/featuers/signup/controller/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateUserWidget extends StatefulWidget {
  const UpdateUserWidget({super.key});

  @override
  State<UpdateUserWidget> createState() => _UpdateUserWidgetState();
}

class _UpdateUserWidgetState extends State<UpdateUserWidget> {
  final usercontroller = Get.put(UserRepository());
  final controller = Get.put(ProfileRepository());
  final validator = Get.put(RegisterController());
  @override
  Widget build(BuildContext context) {
    @override
    dispose() {
      super.dispose();
      controller.dispose();
      validator.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('UPDATE Profile',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.buttonColor))),
      ),
      body: FutureBuilder(
          future: Future.delayed(
            const Duration(milliseconds: 500),
            () => controller.getUserData(),
          ),
          builder: ((context, snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              if (snapShot.hasData) {
                UserModel userData = snapShot.data as UserModel;
                final id = TextEditingController(text: userData.id);
                final email = TextEditingController(text: userData.email);
                final userName = TextEditingController(text: userData.name);
                final password = TextEditingController(text: userData.password);

                RxString usernameTitle = userName.text.obs;

                return Form(
                    key: validator.updateKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: AppColor.mainAppColor,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 500,
                            width: double.infinity,
                            child: ListView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              children: [
                                textFieldLabel('Email'),
                                FormWidget(
                                  textForm: FormModel(
                                      enableText: false,
                                      controller: email,
                                      hintText: 'Email',
                                      icon: const Icon(Icons.email_rounded),
                                      invisible: false,
                                      validator: (email) =>
                                          validator.validateEmail(email),
                                      type: TextInputType.emailAddress,
                                      onChange: null,
                                      inputFormat: [],
                                      onTap: () {}),
                                ),
                                const Gap(15),
                                textFieldLabel('user Name'),
                                FormWidget(
                                  textForm: FormModel(
                                      enableText: false,
                                      controller: userName,
                                      hintText: 'Username',
                                      icon: const Icon(Icons.person),
                                      invisible: false,
                                      validator: (userName) =>
                                          validator.vaildateUserName(userName),
                                      type: TextInputType.name,
                                      onChange: null,
                                      inputFormat: [],
                                      onTap: () {}),
                                ),
                                const Gap(15),
                                const Gap(15),
                                const Gap(15),
                                const Gap(15),
                                formscontainer(
                                    onTap: () async {
                                      if ((validator.updateKey.currentState!
                                          .validate())) {
                                        final userData = UserModel(
                                          id: id.text.trim(),
                                          email: email.text.trim(),
                                          name: userName.text.trim(),
                                          password: password.text.trim(),
                                        );
                                        await controller.updateRecord(userData);
                                      }
                                      dispose();
                                      usernameTitle.value =
                                          userName.text.trim();
                                      print(usernameTitle.value);
                                    },
                                    title: 'UPDATE')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              } else if (snapShot.hasError) {
                return Center(child: Text(snapShot.error.toString()));
              } else {
                return const Text("somthing went wrong");
              }
            } else if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Text("somthing went wrong");
            }
          })),
    );
  }
}

import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/model/form_model.dart';
import 'package:demogp/src/core/model/user_model.dart';
import 'package:demogp/src/core/widget/form/form_widget.dart';
import 'package:demogp/src/core/widget/text/text.dart';
import 'package:demogp/src/featuers/login/view/login_page.dart';
import 'package:demogp/src/featuers/signup/controller/register_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.subappcolor,
            )),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(20),
              TextApp.mainAppText('Create Account '),
              TextApp.subAppText('Fist creat your account'),
              Form(
                key: controller.formkey,
                child: SizedBox(
                  height: 450,
                  width: double.infinity,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    children: [
                      FormWidget(
                          textForm: FormModel(
                              controller: controller.userName,
                              enableText: false,
                              hintText: 'User name',
                              icon: const Icon(Icons.person),
                              invisible: false,
                              validator: (username) =>
                                  controller.vaildateUserName(username),
                              type: TextInputType.name,
                              onChange: null,
                              inputFormat: [],
                              onTap: null)),
                      const Gap(15),
                      FormWidget(
                          textForm: FormModel(
                              controller: controller.email,
                              enableText: false,
                              hintText: 'Email',
                              icon: const Icon(Icons.email),
                              invisible: false,
                              validator: (email) =>
                                  controller.validateEmail(email),
                              type: TextInputType.emailAddress,
                              onChange: null,
                              inputFormat: [],
                              onTap: null)),
                      const Gap(15),
                      FormWidget(
                          textForm: FormModel(
                              controller: controller.password,
                              enableText: false,
                              hintText: 'Password',
                              icon: const Icon(Icons.password),
                              invisible: true,
                              validator: (password) =>
                                  controller.vaildatePassword(password),
                              type: TextInputType.visiblePassword,
                              onChange: null,
                              inputFormat: [],
                              onTap: null)),
                      const Gap(30),
                      const Gap(15),
                      formscontainer(
                          title: 'Sign In',
                          onTap: () => controller.onSignup(UserModel(
                                email: controller.email.text,
                                name: controller.userName.text,
                                password: controller.password.text,
                              )))
                    ],
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(const LoginScreen());
                        },
                      text: 'login',
                      style: TextStyle(
                        color: AppColor.subappcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

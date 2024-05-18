import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/user_repository/user_repository.dart';
import 'package:demogp/src/core/controller/user_controller.dart';
import 'package:demogp/src/core/model/form_model.dart';
import 'package:demogp/src/core/widget/form/form_widget.dart';
import 'package:demogp/src/core/widget/text/text.dart';
import 'package:demogp/src/featuers/login/controller/login_controller.dart';
import 'package:demogp/src/featuers/signup/view/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginController());

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void clearText() {
    controller.email.clear();
    controller.password.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColor.subappcolor,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              children: [
                TextApp.mainAppText('Let’s Login.!'),
                TextApp.subAppText(
                    'Login to Your Account to Continue your Courses'),
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
                                controller: controller.email,
                                enableText: false,
                                hintText: "Email",
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
                                hintText: "Password",
                                icon: const Icon(Icons.password),
                                invisible: true,
                                validator: (password) =>
                                    controller.vaildatePassword(password),
                                type: TextInputType.visiblePassword,
                                onChange: null,
                                inputFormat: [],
                                onTap: null)),
                        const Gap(15),
                        formscontainer(
                            title: 'Login',
                            onTap: () => {
                                  controller.onLogin(),
                                  UserRepository()
                                      .getUserDetails(controller.email.text),
                                  UserController().logIn()
                                }),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                RichText(
                  text: TextSpan(
                    text: 'dont have have an account? ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(const RegisterScreen());
                          },
                        text: 'Sign Up',
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
      ),
    );
  }
}

GestureDetector formscontainer(
    {required String title, required Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: AppColor.subappcolor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 221, 212, 212).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Center(
        child: Text(title,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColor.mainAppColor))),
      ),
    ),
  );
}

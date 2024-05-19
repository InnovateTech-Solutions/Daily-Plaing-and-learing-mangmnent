import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/authentication/authentication.dart';
import 'package:demogp/src/core/backend/user_repository/user_repository.dart';
import 'package:demogp/src/core/widget/text/text.dart';
import 'package:demogp/src/featuers/ai_chat/ai_chat.dart';
import 'package:demogp/src/featuers/pdf_extract/view/upload_pdf.dart';
import 'package:demogp/src/featuers/voice_assistant/voice_assistant.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AiDashboard extends StatefulWidget {
  const AiDashboard({super.key});

  @override
  State<AiDashboard> createState() => _AiDashboardState();
}

class _AiDashboardState extends State<AiDashboard> {
  final _authRepo = Get.put(AuthenticationRepository());

  late final email = _authRepo.firebaseUser.value?.email;

  final userRepository = Get.put(UserRepository());

  @override
  void initState() {
    super.initState();
    userRepository.getUserDetails(email ?? '');
  }

  String _getUsernameFromEmail(String email) {
    // Split email by "@"
    List<String> parts = email.split("@");
    // Get the username part (before "@")
    String username = parts[0];
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Gap(100),
          TextApp.mainAppText('Lets talk to the AI'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30,
              ),
              TextApp.mainAppText("chose you favouirte AI pattern "),
            ],
          ),
          const Gap(20),
          dashboardWidget()
        ],
      ),
    ));
  }

  Container dashboardWidget() {
    return Container(
      width: double.infinity,
      height: 535,
      decoration: BoxDecoration(
          color: AppColor.subappcolor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7), topRight: Radius.circular(7))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              subContainer(
                  iconData: Icons.chat_bubble_outline_outlined,
                  title: "Chat With Ai",
                  onTap: () => Get.to(const AiChat())),
              subContainer(
                  iconData: Icons.schedule_outlined,
                  title: "get you schulde from AI",
                  onTap: () => {
                        Get.to(PdfUpload(
                          email: email!,
                        )),
                      }),
            ],
          ),
          subContainer(
              iconData: Icons.voice_chat_outlined,
              title: "voice asstinet advice",
              onTap: () => {Get.to(VoicePage())}),
        ],
      ),
    );
  }

  GestureDetector subContainer(
      {required IconData iconData,
      required String title,
      required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 163,
        height: 200,
        decoration: BoxDecoration(
            color: AppColor.mainAppColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            const Gap(40),
            CircleAvatar(
              backgroundColor: AppColor.subappcolor,
              child: Icon(
                iconData,
                color: AppColor.mainAppColor,
              ),
            ),
            const Gap(35),
            TextApp.subAppText(title)
          ],
        ),
      ),
    );
  }
}

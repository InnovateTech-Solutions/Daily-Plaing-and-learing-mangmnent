import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/authentication/authentication.dart';
import 'package:demogp/src/core/backend/user_repository/user_repository.dart';
import 'package:demogp/src/core/widget/text/text.dart';
import 'package:demogp/src/featuers/add_mission/view/mession_view.dart';
import 'package:demogp/src/featuers/reminder/view/reminder.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Image.asset('assets/untitled.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                TextApp.mainAppText(
                    "Hi , ${_getUsernameFromEmail(email ?? "")}"),
              ],
            ),
            const Gap(20),
            dashboardWidget()
          ],
        ),
      ),
    ));
  }

  Container dashboardWidget() {
    return Container(
      width: double.infinity,
      height: 449.3,
      decoration: BoxDecoration(
          color: AppColor.subappcolor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7), topRight: Radius.circular(7))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          subContainer(
              iconData: Icons.add,
              title: "Add Reminders",
              onTap: () => Get.to(Reminderpage(
                    userEmail: email ?? "",
                  ))),
          subContainer(
              iconData: Icons.book_online_outlined,
              title: "Add Assigment / Task",
              onTap: () => {
                    Get.to(MissionViewTest(
                      userEmail: email ?? "",
                    )),
                    print(email ?? "")
                  }),
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
        height: 227,
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

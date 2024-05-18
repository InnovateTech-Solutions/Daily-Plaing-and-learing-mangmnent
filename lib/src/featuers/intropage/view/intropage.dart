import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/featuers/intropage/view/buttons_page.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.subappcolor,
        body: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ButtonsPage()),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset('assets/AppImage.png')],
          ),
        ),
      ),
    );
  }
}

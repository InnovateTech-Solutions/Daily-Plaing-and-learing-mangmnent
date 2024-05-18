import 'package:demogp/firebase_options.dart';
import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/authentication/authentication.dart';
import 'package:demogp/src/core/backend/mission_backend/mission_repository.dart';
import 'package:demogp/src/core/backend/reminder_backend/reminder_repository.dart';
import 'package:demogp/src/featuers/intropage/view/intropage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  Get.put(MissionRepository());
  Get.put(ReminderRepository());
  Gemini.init(apiKey: 'AIzaSyAhQcAKve6-SjWzfF27DnokawkKi3eitbQ');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DPLMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.subappcolor),
        useMaterial3: true,
      ),
      home: const IntroPage(),
    );
  }
}

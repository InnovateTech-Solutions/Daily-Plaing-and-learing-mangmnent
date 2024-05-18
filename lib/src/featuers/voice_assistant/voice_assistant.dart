import 'package:alan_voice/alan_voice.dart';
import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({
    super.key,
  });

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  RxBool isAlanButtonVisible = false.obs;

  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      //command from alan
      case "open":
        break;
      case "back":
        Navigator.pushNamed(context, '/dashboard');
        break;
      default:
        debugPrint("Unknown command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            AlanVoice.removeButton();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.subappcolor,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 500, child: Image.asset("assets/untitled.png")),
          TextApp.mainAppText('Lets talk to the AI'),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              isAlanButtonVisible.value = !isAlanButtonVisible.value;
              if (isAlanButtonVisible.value) {
                AlanVoice.addButton(
                    "8f48ac12469dba4171030a36d8f244252e956eca572e1d8b807a3e2338fdd0dc/stage",
                    buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

                AlanVoice.onCommand
                    .add((command) => _handleCommand(command.data));
              } else {
                AlanVoice.removeButton();
              }
            },
            child: Container(
              width: 300,
              height: 60,
              decoration: BoxDecoration(
                  color: AppColor.subappcolor,
                  borderRadius: BorderRadius.circular(10)),
              child: Obx(
                () => Center(
                  child: Text(
                    isAlanButtonVisible.value == false ? "Talk" : "Cancel",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

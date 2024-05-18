import 'dart:io';
import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/mission_backend/mission_repository.dart';
import 'package:demogp/src/core/widget/text/text.dart';
import 'package:demogp/src/featuers/add_mission/controller/mission_controller.dart';
import 'package:demogp/src/featuers/add_mission/view/add_mission.dart';
import 'package:demogp/src/featuers/main_page/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demogp/src/core/model/mission.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// ignore: must_be_immutable
class MissionPage extends StatefulWidget {
  MissionPage({super.key, required this.userEmail});

  late String userEmail;

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  final MissionController _missionController = Get.put(MissionController());

  final MissionRepository _missionRepository = Get.put(MissionRepository());

  bool isChecked = false;

  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.to(const MainPage()),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.subappcolor,
            )),
        title: TextApp.mainAppText('TASKS'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.subappcolor,
        child: Icon(
          Icons.add,
          color: AppColor.mainAppColor,
        ),
        onPressed: () => Get.to(MissionFormPage(
          userEmail: widget.userEmail,
        )),
      ),
      body: FutureBuilder(
        future: _missionController.fetchUserMissions(
            widget.userEmail), // Replace "userEmail" with actual user email
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Obx(() {
              final missions = _missionController.userMissions;
              return ListView.builder(
                itemCount: missions.length,
                itemBuilder: (context, index) {
                  Mission mission = missions[index];
                  bool isRunning = mission.status == 'running';
                  mission.status = isChecked ? "running" : "stopped";
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () => {
                        setState(() {
                          mission.status = "stoped";
                        })
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: isChecked ? Colors.blue : Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        child: isChecked
                            ? const Icon(
                                Icons.check,
                                size: 50.0,
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.check_box_outline_blank,
                                size: 50.0,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    title: missions[index].status == 'runinng'
                        ? Text(missions[index].missionName)
                        : Text(
                            missions[index].missionName,
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough),
                          ),
                    subtitle: missions[index].status == 'runinng'
                        ? const Text('running')
                        : const Text(
                            'Done',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough),
                          ),
                  );
                },
              );
            });
          }
        },
      ),
    );
  }

  void _showAddMissionDialog(BuildContext context) {
    TextEditingController missionNameController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    TextEditingController statusController = TextEditingController();
    TextEditingController pdfPathController = TextEditingController();
    // Initialize other controllers for mission fields if needed

    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: 400,
          height: 600,
          child: AlertDialog(
            title: const Text('Add Mission'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: missionNameController,
                    decoration: const InputDecoration(labelText: 'Mission Name'),
                  ),
                  TextField(
                    controller: typeController,
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context, startDateController),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: startDateController,
                        decoration: const InputDecoration(labelText: 'Start Date'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context, endDateController),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: endDateController,
                        decoration: const InputDecoration(labelText: 'End Date'),
                      ),
                    ),
                  ),
                  TextField(
                    controller: statusController,
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );

                      if (result != null) {
                        File file = File(result.files.single.path!);
                        String fileName =
                            'pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

                        try {
                          await firebase_storage.FirebaseStorage.instance
                              .ref('pdfs/$fileName')
                              .putFile(file);
                          String downloadURL = await firebase_storage
                              .FirebaseStorage.instance
                              .ref('pdfs/$fileName')
                              .getDownloadURL();

                          pdfPathController.text = downloadURL;
                        } catch (e) {
                          print('Error uploading PDF: $e');
                        }
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: Text('Choose PDF'),
                  ),
                  if (pdfPathController.text.isNotEmpty)
                    Text('Selected PDF: ${pdfPathController.text}'),
                  // Add more TextFields for other mission fields if needed
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String userEmail =
                      widget.userEmail; // Replace with actual user email
                  Mission newMission = Mission(
                    missionName: missionNameController.text,
                    type: typeController.text,
                    startDate: startDateController.text,
                    endDate: endDateController.text,
                    status: statusController.text,
                    pdfPath: pdfPathController.text,
                    userEmail: userEmail,
                  );
                  _missionController.createMission(newMission);
                  await _missionController.fetchUserMissions(
                      userEmail); // Fetch user missions after adding a new mission
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Restrict to today's date
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.text = formattedDate;
    }
  }
}

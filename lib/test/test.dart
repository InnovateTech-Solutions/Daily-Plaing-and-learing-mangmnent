import 'package:demogp/firebase_options.dart';
import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/widget/text/text.dart';
import 'package:demogp/src/featuers/add_mission/view/add_mission.dart';
import 'package:demogp/src/featuers/main_page/view/main_page.dart';
import 'package:demogp/test/ai_test.dart';
import 'package:demogp/test/pdf.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      home: const PdfTextExtractorScreen(),
    );
  }
}

class MissionViewTest extends StatelessWidget {
  const MissionViewTest({required this.userEmail, super.key});
  final String userEmail;

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
          userEmail: userEmail,
        )),
      ),
      body: MissionList(
        userEmail: userEmail,
      ),
    );
  }
}

class MissionList extends StatefulWidget {
  const MissionList({required this.userEmail, super.key});
  final String userEmail;

  @override
  State createState() => _MissionListState();
}

class _MissionListState extends State<MissionList> {
  String? selectedMissionName;

  // Function to delete mission from Firestore
  void deleteMission(DocumentSnapshot doc) {
    doc.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Missions')
          .where('userEmail', isEqualTo: widget.userEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              String missionName = data['missionName'] ?? '';
              String missionType = data['type'] ?? '';
              String status = data['status'] ?? '';
              bool isChecked = status == 'done';
              String pdfpath = data['pdfpath'] ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Mission Name: $missionName'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mission Type: $missionType'),
                        Text('Status: $status'),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Mission Name: $missionName'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Mission Type: $missionType'),
                                Text('Status: $status'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(MyPdfViewer(
                                      pdfUrl: pdfpath,
                                    ));
                                  },
                                  child: const Text('View PDF'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteMission(doc);
                          },
                        ),
                        Checkbox(
                          value: isChecked,
                          onChanged: (newValue) {
                            // Update Firestore status here based on newValue
                            String newStatus = newValue! ? 'done' : 'running';
                            doc.reference.update({'status': newStatus});
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              );
            },
          );
        }
      },
    );
  }
}

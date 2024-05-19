import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demogp/src/featuers/main_page/view/main_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchuldePage extends StatefulWidget {
  const SchuldePage(
      {required this.pdfText,
      required this.strartDate,
      required this.endDate,
      required this.email,
      super.key});

  final String pdfText;
  final String strartDate;
  final String email;

  final String endDate;

  @override
  _SchuldePageState createState() => _SchuldePageState();
}

class _SchuldePageState extends State<SchuldePage> {
  String schludeData = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> addStudyPlanToFirebase(String userEmail, String startDate,
      String endDate, String studyPlan) async {
    try {
      // Access Firestore instance
      FirebaseFirestore firestore =
          FirebaseFirestore.instance; // Collection reference
      CollectionReference studyPlansCollection =
          firestore.collection('study_plans'); // Add data to Firestore
      await studyPlansCollection.add({
        'user_email': userEmail,
        'start_date': startDate,
        'end_date': endDate,
        'study_plan': studyPlan,
      });
      print('Study plan added successfully!');
    } catch (error) {
      print('Error adding study plan: $error');
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await Dio().get(
        'http://10.0.2.2:5000/ask?query=create for a study plan ${widget.pdfText} that from date ${widget.strartDate} to ${widget.endDate}',
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final String resultData =
            responseData['response']; // Accessing 'response' key
        setState(() {
          schludeData = resultData;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(widget.email);

          await addStudyPlanToFirebase(
              widget.email, widget.strartDate, widget.endDate, schludeData);

          Get.to(
            const MainPage(),
          );
        },
        child: Icon(Icons.exit_to_app),
      ),
      appBar: AppBar(
        title: const Text('schulde'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                schludeData,
                style: TextStyle(),
              )),
        ),
      ),
    );
  }
}

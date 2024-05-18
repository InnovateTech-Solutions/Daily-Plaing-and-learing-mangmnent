import 'dart:io';

import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/model/form_model.dart';
import 'package:demogp/src/core/model/mission.dart';
import 'package:demogp/src/core/widget/form/mission_form.dart';
import 'package:demogp/src/featuers/add_mission/controller/mission_controller.dart';
import 'package:demogp/src/featuers/login/view/login_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MissionFormPage extends StatefulWidget {
  const MissionFormPage({required this.userEmail, super.key});
  final String userEmail;
  @override
  State<MissionFormPage> createState() => _MissionFormPageState();
}

class _MissionFormPageState extends State<MissionFormPage> {
  @override
  Widget build(BuildContext context) {
    MissionController missionController = Get.put(MissionController());
    String dropdownValue = 'Task';
    const List<String> list = <String>['Task', 'Assignment'];
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: SingleChildScrollView(
            child: Form(
              key: missionController.addformkey,
              child: Column(
                children: [
                  MissoionForm(
                    textForm: FormModel(
                        controller: missionController.missionNameController,
                        enableText: false,
                        hintText: "Assigmnet or task name ",
                        icon: const Icon(Icons.assignment_add),
                        invisible: false,
                        validator: (username) =>
                            missionController.validateDescription(username),
                        type: TextInputType.name,
                        onChange: null,
                        inputFormat: [],
                        onTap: null),
                  ),
                  const Gap(35),
                  MissoionForm(
                    textForm: FormModel(
                      controller: missionController.startDateController,
                      enableText: true,
                      hintText: "start date",
                      icon: const Icon(Icons.date_range_outlined),
                      invisible: false,
                      validator: (username) =>
                          missionController.validateDescription(username),
                      type: TextInputType.datetime,
                      onChange: null,
                      inputFormat: [],
                      onTap: () => _selectDate(
                          context, missionController.startDateController),
                    ),
                  ),
                  const Gap(35),
                  MissoionForm(
                    textForm: FormModel(
                      controller: missionController.endDateController,
                      enableText: true,
                      hintText: "End date",
                      icon: const Icon(Icons.date_range_outlined),
                      invisible: false,
                      validator: (username) =>
                          missionController.validateDescription(username),
                      type: TextInputType.datetime,
                      onChange: null,
                      inputFormat: [],
                      onTap: () => _selectDate(
                          context, missionController.endDateController),
                    ),
                  ),
                  const Gap(35),
                  MissoionForm(
                    textForm: FormModel(
                      controller: missionController.pdfPathController,
                      enableText: true,
                      hintText: "chose your pdf",
                      icon: const Icon(Icons.file_copy),
                      invisible: false,
                      validator: (username) =>
                          missionController.validateDescription(username),
                      type: TextInputType.datetime,
                      onChange: null,
                      inputFormat: [],
                      onTap: () async {
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

                            missionController.pdfPathController.text =
                                downloadURL;
                          } catch (e) {
                            print('Error uploading PDF: $e');
                          }
                        } else {
                          // User canceled the picker
                        }
                      },
                    ),
                  ),
                  const Gap(35),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: AppColor.subappcolor,
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: DropdownMenu<String>(
                          menuStyle: MenuStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColor.subappcolor),
                            side: MaterialStateProperty.all(BorderSide.none),
                          ),
                          enableSearch: false,
                          enabled: true,
                          enableFilter: false,
                          controller: missionController.typeController,
                          expandedInsets: const EdgeInsets.all(0),
                          initialSelection: list.first,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                              dropdownValue =
                                  missionController.typeController.text;
                              print(dropdownValue);
                              print(missionController.typeController.text);
                            });
                          },
                          dropdownMenuEntries: list
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        )),
                      ],
                    ),
                  )
                  // Add more TextFields for other mission fields if needed
                  ,
                  const Gap(35),
                  formscontainer(
                      title: 'submit',
                      onTap: () => missionController.onadd(Mission(
                          missionName:
                              missionController.missionNameController.text,
                          type: missionController.typeController.text,
                          startDate: missionController.startDateController.text,
                          endDate: missionController.endDateController.text,
                          status: 'running',
                          pdfPath: missionController.pdfPathController.text,
                          userEmail: widget.userEmail)))
                ],
              ),
            ),
          ),
        ),
      ),
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

class MyDropDown extends StatefulWidget {
  const MyDropDown({super.key});

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  String dropdownValue = 'Task';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: AppColor.subappcolor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: AppColor.subappcolor,
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: DropdownButton<String>(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              focusColor: AppColor.subappcolor,
              dropdownColor: AppColor.subappcolor,
              isExpanded: true,
              underline: Container(),
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Task', 'Assignment']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

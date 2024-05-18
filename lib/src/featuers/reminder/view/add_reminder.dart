import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/model/form_model.dart';
import 'package:demogp/src/core/model/reminder_model.dart';
import 'package:demogp/src/core/widget/form/mission_form.dart';
import 'package:demogp/src/featuers/login/view/login_page.dart';
import 'package:demogp/src/featuers/reminder/controller/reminder_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReminderFormPage extends StatefulWidget {
  const ReminderFormPage({required this.userEmail, super.key});
  final String userEmail;
  @override
  State<ReminderFormPage> createState() => _ReminderFormPageState();
}

class _ReminderFormPageState extends State<ReminderFormPage> {
  @override
  Widget build(BuildContext context) {
    ReminderController reminderController = Get.put(ReminderController());
    String dropdownValue = 'Task';
    const List<String> list = <String>['Task', 'Assignment'];
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: SingleChildScrollView(
            child: Form(
              key: reminderController.addReminder,
              child: Column(
                children: [
                  MissoionForm(
                    textForm: FormModel(
                        controller: reminderController.reminderNameController,
                        enableText: false,
                        hintText: "reminder name ",
                        icon: const Icon(Icons.assignment_add),
                        invisible: false,
                        validator: (username) =>
                            reminderController.validateDescription(username),
                        type: TextInputType.name,
                        onChange: null,
                        inputFormat: [],
                        onTap: null),
                  ),
                  const Gap(35),
                  MissoionForm(
                    textForm: FormModel(
                      controller: reminderController.startDateController,
                      enableText: true,
                      hintText: "start date",
                      icon: const Icon(Icons.date_range_outlined),
                      invisible: false,
                      validator: (username) =>
                          reminderController.validateDescription(username),
                      type: TextInputType.datetime,
                      onChange: null,
                      inputFormat: [],
                      onTap: () => {
                        _selectDate(
                            context, reminderController.startDateController),
                        print(
                            "strat date ${reminderController.startDateController.text}")
                      },
                    ),
                  ),
                  const Gap(35),
                  MissoionForm(
                    textForm: FormModel(
                      controller: reminderController.endDateController,
                      enableText: true,
                      hintText: "End date",
                      icon: const Icon(Icons.date_range_outlined),
                      invisible: false,
                      validator: (username) =>
                          reminderController.validateDescription(username),
                      type: TextInputType.datetime,
                      onChange: null,
                      inputFormat: [],
                      onTap: () => {
                        _selectDate(
                            context, reminderController.endDateController),
                        print(
                            "end date ${reminderController.endDateController.text}")
                      },
                    ),
                  ),
                  const Gap(35),
                  formscontainer(
                      title: 'submit',
                      onTap: () => {
                            reminderController.onAdd(Reminder(
                                reminderName: reminderController
                                    .reminderNameController.text,
                                startDate:
                                    reminderController.startDateController.text,
                                endDate:
                                    reminderController.endDateController.text,
                                userEmail: widget.userEmail)),
                            reminderController.sendEmail(widget.userEmail)
                          })
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

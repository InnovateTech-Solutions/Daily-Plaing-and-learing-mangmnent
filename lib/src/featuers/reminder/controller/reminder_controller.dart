import 'dart:convert';

import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/backend/reminder_backend/reminder_repository.dart';
import 'package:demogp/src/core/model/reminder_model.dart';
import 'package:demogp/src/featuers/reminder/view/reminder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReminderController extends GetxController {
  TextEditingController reminderNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final ReminderRepository _reminderRepository = ReminderRepository.instance;
  final addReminder = GlobalKey<FormState>();
  RxList<Reminder> userReminders = <Reminder>[].obs;

  clear() {
    reminderNameController.clear();
    startDateController.clear();
    endDateController.clear();
  }

  validateDescription(String? title) {
    if (title!.isNotEmpty) {
      return null;
    }
    return 'Description is not valid';
  }

  Future<void> sendEmail(email) async {
    const String apiUrl = "http://localhost:7130/api/sendemailforuser";

    // Create a Reminder object
    final reminder = Reminder(
      reminderName: reminderNameController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      userEmail: email,
    );

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Convert Reminder object to JSON string
      body: jsonEncode(reminder.toJson()),
    );

    if (response.statusCode == 200) {
      // Email sent successfully
      print("Email sent successfully");
      // You can add any further actions here upon successful email sending
    } else {
      // Error occurred while sending email
      print("Failed to send email. Status code: ${response.statusCode}");
      // You can handle error scenarios here
    }
  }

  void createReminder(Reminder reminder) {
    _reminderRepository.createReminder(reminder);
    userReminders.add(reminder);
  }

  void updateReminder(Reminder reminder) {
    _reminderRepository.updateReminder(reminder);
  }

  Future<void> fetchUserReminders(String userEmail) async {
    final reminders = await _reminderRepository.getUserReminders(userEmail);
    userReminders.value = reminders;
  }

  Future<void> fetchUserRemindersForDate(
      String userEmail, String selectedDate) async {
    final reminders = await _reminderRepository.getUserRemindersForDate(
        userEmail, selectedDate);
    userReminders.value = reminders;
  }

  validateService(String? userName) {
    if (GetUtils.isUsername(userName!)) {
      return null;
    }
    return 'UserName is not valid';
  }

  validateField(dynamic text) {
    if (GetUtils.isBlank(text!)!) {
      return null;
    }
    return 'Field is not valid';
  }

  notEmpty(controller) {
    return controller?.text != null && controller.text.isNotEmpty;
  }

  onAdd(Reminder reminder) {
    if (addReminder.currentState!.validate()) {
      createReminder(reminder);
      Get.off(Reminderpage(
        userEmail: reminder.userEmail,
      )); // Assuming you have a ReminderViewTest widget
      Get.snackbar("Success", "Added successfully",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.success);
      clear();
    } else {
      Get.snackbar("ERROR", "invalid form",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.error);
    }
  }

  @override
  void onClose() {
    // Close resources here if necessary
    super.onClose();
  }
}

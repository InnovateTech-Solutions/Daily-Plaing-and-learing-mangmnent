import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/model/reminder_model.dart';
import 'package:get/get.dart';

class ReminderRepository extends GetxController {
  static ReminderRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createReminder(Reminder reminder) {
    _db
        .collection("Reminders")
        .add(reminder.toJson())
        .whenComplete(() => Get.snackbar(
              "Success",
              "Reminder created successfully",
              snackPosition: SnackPosition.BOTTOM,
              colorText: AppColor.mainAppColor,
              backgroundColor: AppColor.mainAppColor,
            ))
        .catchError((error) {
      Get.snackbar(
        "Error",
        "Failed to create reminder, try again",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColor.mainAppColor,
        backgroundColor: AppColor.mainAppColor,
      );
    });
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _db.collection("Reminders").doc().update(reminder.toJson());
  }

  Future<Reminder> getReminderDetails(String reminderName) async {
    final snapshot = await _db
        .collection("Reminders")
        .where("reminderName", isEqualTo: reminderName)
        .get();
    final reminderData =
        snapshot.docs.map((e) => Reminder.fromJson(e.data())).single;
    return reminderData;
  }

  Future<bool> reminderExists(String reminderName) async {
    try {
      QuerySnapshot reminderSnapshot = await _db
          .collection('Reminders')
          .where('reminderName', isEqualTo: reminderName)
          .get();

      return reminderSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking reminder existence: $e');
      return false;
    }
  }

  Future<List<Reminder>> getUserReminders(String userEmail) async {
    List<Reminder> userReminders = [];

    try {
      QuerySnapshot reminderSnapshot = await _db
          .collection('Reminders')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      userReminders = reminderSnapshot.docs
          .map((doc) => Reminder.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user reminders: $e');
    }

    return userReminders;
  }

  Future<List<Reminder>> getUserRemindersForDate(
      String userEmail, String selectedDate) async {
    try {
      final QuerySnapshot reminderSnapshot = await _db
          .collection('Reminders')
          .where('userEmail', isEqualTo: userEmail)
          .where('startDate', isEqualTo: selectedDate)
          .get();

      return reminderSnapshot.docs
          .map((doc) => Reminder.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user reminders for date: $e');
      return [];
    }
  }
}

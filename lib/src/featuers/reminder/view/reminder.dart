import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/model/reminder_model.dart';
import 'package:demogp/src/featuers/reminder/controller/reminder_controller.dart';
import 'package:demogp/src/featuers/reminder/view/add_reminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:get/get.dart';

class Reminderpage extends StatefulWidget {
  const Reminderpage({required this.userEmail , super.key});
final String userEmail;
  @override
  State<Reminderpage> createState() => _ReminderpageState();
}

class _ReminderpageState extends State<Reminderpage> {
  late RxString selectedDate;
  late String datePart;

  @override
  void initState() {
    super.initState();
    selectedDate = (DateTime.now()).toString().obs;
    List<String> parts = selectedDate.value.split(' ');
    datePart = parts[0];
  }

  Future<void> deleteReminder(DocumentSnapshot doc) async {
    try {
      await doc.reference.delete();
      print('Reminder removed successfully');
    } catch (e) {
      print('Error removing reminder: $e');
      throw Exception('Failed to remove reminder');
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ReminderController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.subappcolor,
        onPressed: () {
          Get.to(ReminderFormPage(
            userEmail: widget.userEmail,
          ));
        },
        child: Icon(
          Icons.add,
          color: AppColor.mainAppColor,
        ),
      ),
      body: Column(
        children: [
          TimelineCalendar(
            calendarType: CalendarType.GREGORIAN,
            calendarLanguage: "en",
            calendarOptions: CalendarOptions(
              viewType: ViewType.DAILY,
              toggleViewType: true,
              headerMonthElevation: 10,
              headerMonthShadowColor: Colors.black26,
              headerMonthBackColor: Colors.transparent,
            ),
            dayOptions: DayOptions(
                selectedBackgroundColor: AppColor.subappcolor,
                compactMode: true,
                weekDaySelectedColor: AppColor.subappcolor,
                disableDaysBeforeNow: true),
            headerOptions: HeaderOptions(
                weekDayStringType: WeekDayStringTypes.SHORT,
                monthStringType: MonthStringTypes.FULL,
                backgroundColor: AppColor.mainAppColor,
                headerTextColor: AppColor.mainAppColor,
                resetDateColor: AppColor.mainAppColor,
                calendarIconColor: AppColor.mainAppColor,
                navigationColor: AppColor.mainAppColor),
            onChangeDateTime: (datetime) {
              setState(() {
                selectedDate.value = datetime.getDate().toString();
                List<String> parts = selectedDate.value.split(' ');
                datePart = parts[0];
                print(datePart);
              });
            },
          ),
          FutureBuilder<void>(
            future: Get.find<ReminderController>()
                .fetchUserRemindersForDate(widget.userEmail, datePart),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Display a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Display an error message if fetching data fails
              } else {
                // Display the fetched reminders if available
                return Expanded(
                  child: GetBuilder<ReminderController>(
                    builder: (controller) {
                      if (controller.userReminders.isEmpty) {
                        return Center(
                          child: Text('No reminders found for $selectedDate'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: controller.userReminders.length,
                          itemBuilder: (context, index) {
                            Reminder reminder = controller.userReminders[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  title: Text(
                                    reminder.reminderName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8.0),
                                      Text('Start Date: ${reminder.startDate}'),
                                      SizedBox(height: 4.0),
                                      Text('End Date: ${reminder.endDate}'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class Reminder {
  late String reminderName;
  late String startDate;
  late String endDate;
  late String userEmail;

  Reminder(
      {required this.reminderName,
      required this.startDate,
      required this.endDate,
      required this.userEmail});

  // Convert JSON to Mission object
  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      reminderName:
          json['reminderName'] ?? '', // Add null check and default value
      startDate: json['startDate'] ?? '', // Add null check and default value
      endDate: json['endDate'] ?? '',
      userEmail: json['userEmail'] ?? '', // Add null check and default value
      // Add null check and default value
    );
  }

  // Convert Mission object to JSON
  Map<String, dynamic> toJson() {
    return {
      "reminderName": reminderName,
      "startDate": startDate,
      "endDate": endDate,
      "userEmail": userEmail
    };
  }
}

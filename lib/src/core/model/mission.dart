class Mission {
  late String missionName;
  late String type;
  late String startDate;
  late String endDate;
  late String status;
  late String pdfPath;
  late String userEmail;

  Mission({
    required this.missionName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.pdfPath,
    required this.userEmail,
  });

  // Convert JSON to Mission object
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      missionName:
          json['missionName'] ?? '', // Add null check and default value
      type: json['type'] ?? '', // Add null check and default value
      startDate: json['startDate'] ?? '', // Add null check and default value
      endDate: json['endDate'] ?? '', // Add null check and default value
      status: json['status'] ?? '', // Add null check and default value
      pdfPath: json['pdfpath'] ?? '', // Add null check and default value
      userEmail: json['userEmail'] ?? '', // Add null check and default value
    );
  }

  // Convert Mission object to JSON
  Map<String, dynamic> toJson() {
    return {
      "missionName": missionName,
      "type": type,
      "startDate": startDate,
      "endDate": endDate,
      "status": 'runinng',
      "pdfpath": pdfPath,
      "userEmail": userEmail,
    };
  }
}

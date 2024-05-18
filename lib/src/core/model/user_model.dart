import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  late String name;
  late String password;
  late String email;

  UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  tojason() {
    return {
      "Email": email,
      "Password": password,
      "UserName": name,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return UserModel(
      id: documentSnapshot.id,
      email: data["Email"],
      name: data["UserName"],
      password: data["Password"],
    );
  }
}

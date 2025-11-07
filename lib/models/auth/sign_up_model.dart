import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpModel {
  final String name;
  final String email;
  final Timestamp time;

  SignUpModel({required this.email, required this.name,required this.time});

  // to firebase

  Map<String, dynamic> toFirebase() => {'name': name, 'email': email,'createdAt':time};
}

import 'package:cloud_firestore/cloud_firestore.dart';

class NotiLoiginFirebaseModel {
  final String title;
  final Timestamp time;
  bool isRead;

  NotiLoiginFirebaseModel({
    required this.title,
    required this.isRead,
    required this.time,
  });

  // to firebase

  Map<String, dynamic> toFirebase() {
    return {'title': title, 'time': time, 'isRead': isRead};
  }

  factory NotiLoiginFirebaseModel.fromJson(Map<String, dynamic> json) {
    return NotiLoiginFirebaseModel(
      title: json['title'],
      isRead: json['isRead'],
      time: json['time'],
    );
  }
}

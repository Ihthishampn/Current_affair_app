import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/models/noti_model_firebase_login/noti_loigin_firebase_model.dart';
import 'package:current_affairs/services/login_firebase_notification.dart/login_firebase_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotiProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginFirebaseNotificationServices _firebaseNotificationServices =
      LoginFirebaseNotificationServices();
  List<NotiLoiginFirebaseModel> notiLists = [];

  bool isLoading = false;
  bool isRead = false;
  String message = '';

  bool get hasUnread => notiLists.any((e) => e.isRead == false);

  // handle noti
  //
  void hadleNoti() async {
    isLoading = true;
    isRead = true;
    message = '';

    notifyListeners();

    try {
      final List<NotiLoiginFirebaseModel> val =
          await _firebaseNotificationServices.getNoti();
      for (var noiti in val) {
        notiLists.add(noiti);
      }
    } catch (e) {
      message = 'Some error ocuured,will be fix soon';
      print(e.toString());
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> clearAllNoti() async {
    try {
      // delete from firestore if needed
      final uid = _auth.currentUser!.uid;
      final ref = _firestore
          .collection("User_notifications")
          .doc(uid)
          .collection("notifications");

      final snapshots = await ref.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      notiLists.clear();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // mark all read

Future<void> markAllRead() async {
  try {
    await _firebaseNotificationServices.markAsAllRead();
    for (var n in notiLists) {
      n.isRead = true;
    }
    notifyListeners();
  } catch (e) {}
}

}

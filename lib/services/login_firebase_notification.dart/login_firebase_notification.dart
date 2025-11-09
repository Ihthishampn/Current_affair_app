import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/models/noti_model_firebase_login/noti_loigin_firebase_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginFirebaseNotificationServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // noti logi

  Future<void> loginNotificationAdd(NotiLoiginFirebaseModel model) async {
    try {
      final uid = _firebaseAuth.currentUser!.uid;
      await _firebaseFirestore
          .collection('User_notifications')
          .doc(uid)
          .collection('notifications')
          .add(model.toFirebase());
    } catch (e) {
      rethrow;
    }
  }
  // get noti

  Future<List<NotiLoiginFirebaseModel>> getNoti() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> shots = await _firebaseFirestore
          .collection("User_notifications")
          .doc(_firebaseAuth.currentUser!.uid)
          .collection("notifications")
          .get();
      return shots.docs
          .map((e) => NotiLoiginFirebaseModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsAllRead() async {
    try {
      final docss = await _firebaseFirestore
          .collection('User_notifications')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();
      for (var d in docss.docs) {
        d.reference.update({"isRead": true});
      }
    } catch (e) {
      rethrow;
    }
  }
}

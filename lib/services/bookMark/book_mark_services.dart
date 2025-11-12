import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/models/bookMark_model/bookmaerk_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
class BookMarkServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<BookmarkModel>> getBookMarkQus() async {
    try {
      final list = await _firebaseFirestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('bookmarks')
          .get();

      return list.docs
          .map((e) => BookmarkModel.fromFirebase(e.data(), e.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

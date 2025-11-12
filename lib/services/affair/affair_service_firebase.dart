import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/models/affair/affair_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AffairServiceFirebase {
  final _db = FirebaseFirestore.instance;

  Future<(List<AffairModel>, DocumentSnapshot<Map<String, dynamic>>?)> fetchFirebaseQus({
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
    int limit = 20,
  }) async {
    final query = _db
        .collection('Questions')
        .orderBy(FieldPath.documentId)
        .limit(limit);

    final snap = lastDoc != null
        ? await query.startAfterDocument(lastDoc).get()
        : await query.get();

    final models = snap.docs.map((doc) => AffairModel.fromFirebase(doc.data(),doc.id)).toList();

    final newLastDoc = snap.docs.isNotEmpty ? snap.docs.last : null;

    return (models, newLastDoc);
  }

  Future<void> saveBookmark({
  required String category,
  required String question,
  required List<String> options,
  required int correctAnswer,
}) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance.collection("bookmarks").add({
    "userId": uid,
    "category": category,
    "question": question,
    "options": options,
    "correctAnswer": correctAnswer,
    "time": FieldValue.serverTimestamp(),
  });
}

Future<void> removeBookmark(String question) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final snap = await FirebaseFirestore.instance
      .collection("bookmarks")
      .where("userId", isEqualTo: uid)
      .where("question", isEqualTo: question)
      .get();

  if (snap.docs.isNotEmpty) {
    await snap.docs.first.reference.delete();
  }
}

Future<bool> isBookmarked(String question) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final snap = await FirebaseFirestore.instance
      .collection("bookmarks")
      .where("userId", isEqualTo: uid)
      .where("question", isEqualTo: question)
      .get();

  return snap.docs.isNotEmpty;
}



}

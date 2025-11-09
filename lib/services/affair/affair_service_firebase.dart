import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/models/affair/affair_model.dart';

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

    final models = snap.docs.map((doc) => AffairModel.fromFirebase(doc.data())).toList();

    final newLastDoc = snap.docs.isNotEmpty ? snap.docs.last : null;

    return (models, newLastDoc);
  }
}

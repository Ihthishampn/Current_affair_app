import 'package:current_affairs/services/affair/affair_service_firebase.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/models/affair/affair_model.dart';
class AffairProvider extends ChangeNotifier {
  final AffairServiceFirebase _service = AffairServiceFirebase();

  List<AffairModel> questions = [];
  DocumentSnapshot<Map<String, dynamic>>? lastDoc;

  bool isInitialLoading = false;
  bool isLoadMore = false;
  bool noMore = false;

  Future<void> loadInitial() async {
    isInitialLoading = true;
    notifyListeners();

    final (data, doc) = await _service.fetchFirebaseQus(limit: 20);

    questions = data;
    lastDoc = doc;
    noMore = data.isEmpty;

    isInitialLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadMore || noMore) return;

    isLoadMore = true;
    notifyListeners();

    final (data, doc) = await _service.fetchFirebaseQus(
      lastDoc: lastDoc,
      limit: 20,
    );

    if (data.isEmpty) {
      noMore = true;
    } else {
      questions.addAll(data);
      lastDoc = doc;
    }

    isLoadMore = false;
    notifyListeners();
  }
}

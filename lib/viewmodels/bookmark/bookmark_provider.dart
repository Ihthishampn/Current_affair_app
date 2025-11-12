import 'package:current_affairs/models/bookMark_model/bookmaerk_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  List<BookmarkModel> bookmarks = [];
  bool isLoading = false;
  String? error;
  bool _loadedOnce = false;

  Future<void> initBookmarks() async {
    if (_loadedOnce) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final snap = await _db
          .collection("Users")
          .doc(_uid)
          .collection("bookmarks")
          .get();

      bookmarks = snap.docs
          .map((doc) => BookmarkModel.fromFirebase(doc.data(), doc.id))
          .toList();

      _loadedOnce = true;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Toggle bookmark status
  Future<void> toggleBookmark(BookmarkModel model) async {
    final ref = _db
        .collection("Users")
        .doc(_uid)
        .collection("bookmarks")
        .doc(model.id);

    model.isMarked = !model.isMarked; 

    if (model.isMarked) {
      await ref.set(model.toMap());

      final index = bookmarks.indexWhere((b) => b.id == model.id);
      if (index >= 0) {
        bookmarks[index] = model;
      } else {
        bookmarks.add(model);
      }
    } else {
      await ref.delete();
      bookmarks.removeWhere((b) => b.id == model.id);
    }

    notifyListeners();
  }
}

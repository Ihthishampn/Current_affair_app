  import 'package:current_affairs/models/ownAddQus/ownAddQus.dart';
  import 'package:current_affairs/services/ownAddQus_hive/OwnAddQusService.dart';
  import 'package:flutter/material.dart';
  import 'package:hive/hive.dart';

  class OwnAddQusProvider extends ChangeNotifier {
    final Ownaddqusservice _ownQusServices = Ownaddqusservice();
    List<Ownaddqus> qusLists = [];
    bool loading = false;
    String error = '';
    bool isDone = false;

  Future<void> togleChange(bool val, Ownaddqus qus) async {
    final box = Hive.box<Ownaddqus>('OwnAddQus');
    qus.status = val;

    if (qus.isInBox) {
      await qus.save();
    } else {
      await box.add(qus);
    }

    isDone = val;
    await getQus();
    notifyListeners();
  }







    Future<void> getQus() async {
      loading = true;
      notifyListeners();
      try {
        qusLists.clear();
        final val = await _ownQusServices.getQusFromLoacalStorage();
        qusLists.addAll(val);
      } catch (e) {
        //
      } finally {
        loading = false;
        notifyListeners();
      }
    }

    // add

    Future<void> addQus(Ownaddqus model) async {
      loading = true;
      notifyListeners();
      try {
        await _ownQusServices.addQusToLocalStorage(model);
        print(model.status);
        await getQus();
      } catch (e) {
        error = 'failed to fetch questians';
      } finally {
        notifyListeners();
      }
    }

    //

    // Edit question
    Future<void> editQus(Ownaddqus model, int index) async {
      loading = true;
      notifyListeners();
      try {
        final box = Hive.box<Ownaddqus>('OwnAddQus');
        final key = box.keyAt(index);
        await _ownQusServices.editQusToLocalStorage(model, key);
        await getQus();
      } catch (e) {
        error = 'Failed to edit question';
      } finally {
        loading = false;
        notifyListeners();
      }
    }

    // Delete question
    Future<void> deleteQus(int index) async {
      loading = true;
      notifyListeners();
      try {
        final box = Hive.box<Ownaddqus>('OwnAddQus');
        final key = box.keyAt(index);
        await _ownQusServices.deleteOneQusFromLocalStorage(key);
        await getQus();
      } catch (e) {
        error = 'Failed to delete question';
      } finally {
        loading = false;
        notifyListeners();
      }
    }
      // Delete all questions
  Future<void> deleteAllQus() async {
    loading = true;
    notifyListeners();
    try {
      await _ownQusServices.deleteAllQusFromLocalStorage();
      qusLists.clear();
    } catch (e) {
      error = 'Failed to delete all questions';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  }

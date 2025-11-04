import 'package:current_affairs/models/ownAddQus/ownAddQus.dart';
import 'package:hive/hive.dart';

class Ownaddqusservice {
  static const String _boxname = 'OwnAddQus';
  Future<Box<Ownaddqus>> boxOwnaddQus() async {
    return await Hive.openBox<Ownaddqus>(_boxname);
  }

  // add data
  Future<void> addQusToLocalStorage(Ownaddqus qusModel) async {
    final box = await boxOwnaddQus();
    await box.add(qusModel);
  }

  // get data

  Future<List<Ownaddqus>> getQusFromLoacalStorage() async {
    final box = await boxOwnaddQus();
    return box.values.toList();
  }

  //  edit data

  Future<void> editQusToLocalStorage(Ownaddqus qusmodel, int key) async {
    final box = await boxOwnaddQus();
    box.put(key, qusmodel);
  }



  // delete data

  Future<void> deleteOneQusFromLocalStorage(int key) async {
    final box = await boxOwnaddQus();
    box.delete(key);
  }

    // delete all data
  Future<void> deleteAllQusFromLocalStorage() async {
    final box = await boxOwnaddQus();
    await box.clear();
  }

}

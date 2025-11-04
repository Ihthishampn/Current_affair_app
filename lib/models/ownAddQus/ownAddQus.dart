import 'package:hive_flutter/adapters.dart';

part 'ownAddQus.g.dart';

@HiveType(typeId: 2)
class Ownaddqus extends HiveObject {
  @HiveField(0)
   String questian;

  @HiveField(1)
   String answer;

  @HiveField(2)
  bool status;

  Ownaddqus({
    required this.questian,
    required this.answer,
    required this.status,
  });

   Ownaddqus copyWith({String? questian, String? answer, bool? status}) {
    return Ownaddqus(
      questian: questian ?? this.questian,
      answer: answer ?? this.answer,
      status: status ?? this.status,
    );
  }
}

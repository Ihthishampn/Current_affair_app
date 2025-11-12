class AffairModel {
    final String id;
  final String category;
  final int correctAnswer;
  final List<String> options;
  final String question;

  AffairModel({
        required this.id,
    required this.category,
    required this.correctAnswer,
    required this.options,
    required this.question,
  });

  // from firebase

  factory AffairModel.fromFirebase(Map<String, dynamic> json,String docId) {
    return AffairModel(
       id: docId,
      category: json['category'],
       correctAnswer: json['correctAnswer'] is int
          ? json['correctAnswer']
          : int.parse(json['correctAnswer'].toString()),
      options: (json['options'] as List<dynamic>).map((e)=>e.toString()).toList(),
      question: json['question'],
    );
  }
}

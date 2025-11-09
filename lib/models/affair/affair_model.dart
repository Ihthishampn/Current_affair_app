class AffairModel {
  final String category;
  final String correctAnswer;
  final List<String> options;
  final String question;

  AffairModel({
    required this.category,
    required this.correctAnswer,
    required this.options,
    required this.question,
  });

  // from firebase

  factory AffairModel.fromFirebase(Map<String, dynamic> json) {
    return AffairModel(
      category: json['category'],
      correctAnswer: json['correctAnswer'].toString(),
      options: (json['options'] as List<dynamic>).map((e)=>e.toString()).toList(),
      question: json['question'],
    );
  }
}

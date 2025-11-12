class BookmarkModel {
  final String id;
  final String category;
  final String question;
  final List<String> options;
  final int correctAnswer;
  bool isMarked;

  BookmarkModel({
    required this.id,
    required this.category,
    required this.isMarked,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'isMarked':isMarked,
      'category': category,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }

  factory BookmarkModel.fromFirebase(Map<String, dynamic> map, String id) {
    return BookmarkModel(
      id: id,
      isMarked: map['isMarked'] ?? false,
      category: map['category'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correctAnswer'] ?? 0,
    );
  }
}

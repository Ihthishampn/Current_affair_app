import 'package:current_affairs/models/bookMark_model/bookmaerk_model.dart';
import 'package:current_affairs/viewmodels/bookmark/bookmark_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int totalAttempted = 0;
  List<int?> userAnswers = [];
  bool isAnswered = false;
  int? selectedOption;
  bool quizStarted = false;
  bool quizCompleted = false;
  List<BookmarkModel> quizQuestions = [];

  @override
  void initState() {
    super.initState();
    final provider = context.read<BookmarkProvider>();
    quizQuestions = provider.bookmarks.where((b) => b.isMarked).toList();
  }

  void startQuiz() {
    final provider = context.read<BookmarkProvider>();
    quizQuestions = provider.bookmarks.where((b) => b.isMarked).toList();

    if (quizQuestions.length < 5) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Minimum 5 questions required to start a quiz!'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      quizStarted = true;
      currentQuestionIndex = 0;
      correctAnswers = 0;
      totalAttempted = 0;
      userAnswers = List.filled(quizQuestions.length, null);
      isAnswered = false;
      selectedOption = null;
      quizCompleted = false;
    });
  }

  void selectAnswer(int optionIndex) {
    if (isAnswered) return;

    setState(() {
      selectedOption = optionIndex;
      isAnswered = true;
      totalAttempted++;
      userAnswers[currentQuestionIndex] = optionIndex;

      if (optionIndex == quizQuestions[currentQuestionIndex].correctAnswer) {
        correctAnswers++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnswered = false;
        selectedOption = null;
      });
    } else {
      setState(() {
        quizCompleted = true;
      });
    }
  }

  void restartQuiz() {
    setState(() {
      quizStarted = false;
      quizCompleted = false;
      currentQuestionIndex = 0;
      correctAnswers = 0;
      totalAttempted = 0;
      userAnswers = [];
      isAnswered = false;
      selectedOption = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!quizStarted) {
      return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: const Text('Quiz', style: TextStyle(color: Colors.white)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade900],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade800.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.quiz, size: 80, color: Colors.white),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Ready to Test Your Knowledge?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${quizQuestions.length} bookmarked questions available',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: startQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Colors.blue.shade800,
                  ),
                  child: const Text(
                    'Start Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (quizCompleted) {
      final percentage = (correctAnswers / quizQuestions.length * 100).toInt();
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text(
                'Quiz Results',
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 0, 0, 0),
                        const Color.fromARGB(255, 0, 0, 0),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          size: 80,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Quiz Completed!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            'Score',
                            '$percentage%',
                            Colors.blue.shade700,
                          ),
                          _buildStatCard(
                            'Correct',
                            '$correctAnswers',
                            Colors.green.shade700,
                          ),
                          _buildStatCard(
                            'Wrong',
                            '${quizQuestions.length - correctAnswers}',
                            Colors.red.shade700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final question = quizQuestions[index];
                final userAnswer = userAnswers[index];
                final isCorrect = userAnswer == question.correctAnswer;

                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 71, 70, 70),
                        isCorrect
                            ? const Color.fromARGB(255, 71, 70, 70)
                            : const Color.fromARGB(255, 71, 70, 70),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: isCorrect
                          ? Colors.green.shade600
                          : Colors.red.shade600,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isCorrect ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                question.question,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade800,
                                Colors.green.shade900,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade600),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade500,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Correct Answer: ${question.options[question.correctAnswer]}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (userAnswer != null && !isCorrect)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade800,
                                  Colors.red.shade900,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade600),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade500,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Your Answer: ${question.options[userAnswer]}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }, childCount: quizQuestions.length),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: restartQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Colors.blue.shade800,
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final question = quizQuestions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          'Question ${currentQuestionIndex + 1}/${quizQuestions.length}',
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade800],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade800.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Text(
                  '$correctAnswers/$totalAttempted',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / quizQuestions.length,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade800],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade800.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      question.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(question.options.length, (index) {
                    final isSelected = selectedOption == index;
                    final isCorrect = index == question.correctAnswer;
                    final showResult = isAnswered;

                    Color backgroundColor = Colors.grey.shade800;
                    Color borderColor = Colors.grey.shade600;
                    Color textColor = Colors.white;
                    Color circleColor = Colors.grey.shade600;

                    if (showResult) {
                      if (isSelected) {
                        if (isCorrect) {
                          backgroundColor = Colors.green.shade900;
                          borderColor = Colors.green.shade600;
                          textColor = Colors.white;
                          circleColor = Colors.green;
                        } else {
                          backgroundColor = Colors.red.shade900;
                          borderColor = Colors.red.shade600;
                          textColor = Colors.white;
                          circleColor = Colors.red;
                        }
                      } else if (isCorrect) {
                        backgroundColor = Colors.green.shade900;
                        borderColor = Colors.green.shade600;
                        textColor = Colors.white;
                        circleColor = Colors.green;
                      }
                    } else if (isSelected) {
                      backgroundColor = Colors.blue.shade900;
                      borderColor = Colors.blue.shade500;
                      circleColor = Colors.blue.shade500;
                    }

                    return GestureDetector(
                      onTap: () => selectAnswer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: circleColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: circleColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: showResult
                                    ? Icon(
                                        isCorrect ? Icons.check : Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : Text(
                                        String.fromCharCode(65 + index),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          if (isAnswered)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: Colors.blue.shade800,
                ),
                child: Text(
                  currentQuestionIndex < quizQuestions.length - 1
                      ? 'Next Question'
                      : 'View Results',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

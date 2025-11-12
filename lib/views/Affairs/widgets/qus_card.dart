import 'package:current_affairs/models/bookMark_model/bookmaerk_model.dart';
import 'package:current_affairs/viewmodels/bookmark/bookmark_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionCard extends StatefulWidget {
  final String id;
  final String category;
  final String question;
  final List<String> options;
  final int correctAnswer;

  const QuestionCard({
    super.key,
    required this.id,
    required this.category,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  bool showAnswer = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAnswer() {
    setState(() {
      showAnswer = !showAnswer;
      if (showAnswer) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = context.watch<BookmarkProvider>();
    final isMarked = bookmarkProvider.bookmarks.any(
      (b) => b.id == widget.id && b.isMarked,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Animated Bookmark Icon
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 200),
                  tween: Tween(begin: 1.0, end: isMarked ? 1.2 : 1.0),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: InkWell(
                        onTap: () => bookmarkProvider.toggleBookmark(
                          BookmarkModel(
                            id: widget.id,
                            category: widget.category,
                            question: widget.question,
                            options: widget.options,
                            correctAnswer: widget.correctAnswer,
                            isMarked: isMarked, // initial
                          ),
                        ),
                        child: Icon(
                          isMarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isMarked ? Colors.orangeAccent : Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Question Text
            Text(
              widget.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // Toggle Answer Button with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ElevatedButton.icon(
                onPressed: _toggleAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: showAnswer
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                icon: AnimatedRotation(
                  turns: showAnswer ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    showAnswer ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                ),
                label: Text(
                  showAnswer ? 'Hide Answer' : 'Show Answer',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Animated Answer Display
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: showAnswer
                  ? FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.greenAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.options[widget.correctAnswer],
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

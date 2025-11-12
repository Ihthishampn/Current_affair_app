import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:current_affairs/models/bookMark_model/bookmaerk_model.dart';
import 'package:current_affairs/viewmodels/bookmark/bookmark_provider.dart';

class QusCard2 extends StatefulWidget {
  final BookmarkModel model;
  final VoidCallback? onBookmarkToggle;

  const QusCard2({super.key, required this.model, this.onBookmarkToggle});

  @override
  State<QusCard2> createState() => _QusCard2State();
}

class _QusCard2State extends State<QusCard2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleBookmarkToggle(BookmarkProvider provider) async {
    final wasMarked = widget.model.isMarked;
    widget.model.isMarked = !wasMarked;
    if (!widget.model.isMarked) widget.onBookmarkToggle?.call();
    await provider.toggleBookmark(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookmarkProvider>();
    final isBookmarked = provider.bookmarks.any(
      (b) => b.id == widget.model.id && b.isMarked,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade900, Colors.grey.shade800],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.blue.shade800, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade800],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade800.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.model.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _handleBookmarkToggle(provider),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(6),

                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Colors.amber : Colors.grey.shade400,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.model.question,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.model.options.isNotEmpty &&
                widget.model.correctAnswer >= 0 &&
                widget.model.correctAnswer < widget.model.options.length)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 172, 186, 173),
                      const Color.fromARGB(255, 157, 169, 158),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 132, 143, 132),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade800.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.model.options[widget.model.correctAnswer],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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
  }
}

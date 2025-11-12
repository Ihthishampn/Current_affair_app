import 'package:current_affairs/views/BookMarkAndReminder/bookMark/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:current_affairs/viewmodels/bookmark/bookmark_provider.dart';
import 'package:current_affairs/views/BookMarkAndReminder/bookMark/bookMarkQusCard.dart';


class BookMarkQus extends StatefulWidget {
  const BookMarkQus({super.key});

  @override
  State<BookMarkQus> createState() => _BookMarkQusState();
}

class _BookMarkQusState extends State<BookMarkQus> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    context.read<BookmarkProvider>().initBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookmarkProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

   

    return Scaffold(
      appBar: AppBar(title: const Text('Book Mark')),
      body: provider.bookmarks.isEmpty ? const Center(child: Text('No Bookmarks Yet'),) :AnimatedList(
        key: _listKey,
        initialItemCount: provider.bookmarks.length,
        itemBuilder: (context, index, animation) {
          final model = provider.bookmarks[index];
          return SizeTransition(
            sizeFactor: animation,
            child: QusCard2(
              model: model,
              onBookmarkToggle: () {
                final removedModel = provider.bookmarks[index];

                _listKey.currentState?.removeItem(
                  index,
                  (context, anim) => SizeTransition(
                    sizeFactor: anim,
                    child: QusCard2(model: removedModel),
                  ),
                  duration: const Duration(milliseconds: 400),
                );

                Future.delayed(const Duration(milliseconds: 400), () {
                  provider.bookmarks.removeWhere(
                    (b) => b.id == removedModel.id,
                  );
                  provider.toggleBookmark(removedModel);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                reverseTransitionDuration: Duration.zero,
                transitionDuration: Duration.zero,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    QuizScreen(),
              ),
            );
          },
          icon: const Icon(Icons.quiz, color: Colors.white),
          label: const Text(
            'Start Quiz',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 28, 96, 151),
        ),
      ),
    );
  }
}

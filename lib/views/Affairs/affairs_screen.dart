import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/viewmodels/affair/affair_provider.dart';
import 'package:current_affairs/viewmodels/bookmark/bookmark_provider.dart';
import 'package:current_affairs/viewmodels/noti/noti_provider.dart';
import 'package:current_affairs/views/Affairs/widgets/qus_card.dart';
import 'package:current_affairs/views/notifications/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AffairScreen extends StatefulWidget {
  const AffairScreen({super.key});

  @override
  State<AffairScreen> createState() => _AffairScreenState();
}

class _AffairScreenState extends State<AffairScreen> {
  final ScrollController scroll = ScrollController();
  late final NotiProvider notiProvider;
  late final AffairProvider affairProvider;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notiProvider = context.read<NotiProvider>();
      notiProvider.hadleNoti();
      context.read<BookmarkProvider>().initBookmarks();

      affairProvider = context.read<AffairProvider>();
      if (affairProvider.questions.isEmpty) {
        affairProvider.loadInitial();
      }
    });

    scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (scroll.position.pixels >= scroll.position.maxScrollExtent - 150) {
      affairProvider.loadMore(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        title: const Text('Current Affairs'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Only Pro users can refresh the questions to get the latest current affairs every day. Everyone else can view existing questions.',
                  ),
                  duration: const Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            },
            icon: Icon(Icons.refresh),
          ),
          Consumer<NotiProvider>(
            builder: (context, provider, child) {
              final hasUnread = provider.notiLists.any(
                (n) => n.isRead == false,
              );

              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      final page = const NotificationsScreen();

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 260),
                          reverseTransitionDuration: const Duration(
                            milliseconds: 200,
                          ),
                          pageBuilder:
                              (context, animation, secondaryAnimation) => page,
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                final slide =
                                    Tween(
                                      begin: const Offset(
                                        0.12,
                                        0,
                                      ), 
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    );

                                final fade = Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOut,
                                      ),
                                    );

                                return FadeTransition(
                                  opacity: fade,
                                  child: SlideTransition(
                                    position: slide,
                                    child: child,
                                  ),
                                );
                              },
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications),
                  ),

                  if (hasUnread)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: Consumer<AffairProvider>(
        builder: (context, pro, child) {
          if (pro.isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: scroll, 
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: pro.questions.length + (pro.isLoadMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < pro.questions.length) {
                final q = pro.questions[index];
                return QuestionCard(
                  correctAnswer: q.correctAnswer,
                  options: q.options,
                  category: q.category,
                  question: q.question,
                  id: q.id,
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        },
      ),
    );
  }
}

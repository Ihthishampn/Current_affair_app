import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/viewmodels/affair/affair_provider.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notiProvider = context.read<NotiProvider>();
      notiProvider.hadleNoti();

      affairProvider = context.read<AffairProvider>();
      affairProvider.loadInitial(); // load first batch here
    });

    scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (scroll.position.pixels >= scroll.position.maxScrollExtent - 150) {
      affairProvider.loadMore(); // use stored reference, no lookup
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        title: const Text('Current Affairs'),
        actions: [
          Consumer<NotiProvider>(
            builder: (context, provider, child) {
              final hasUnread = provider.notiLists.any(
                (n) => n.isRead == false,
              );

              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      final page = const NotificationsScreen(); // PREBUILD

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
                                      ), // small slide = smooth
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    );

                                // Fade + Slide to hide the frame hitch
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
            controller: scroll, // IMPORTANT
            padding: const EdgeInsets.symmetric(vertical: 10),
           itemCount: pro.questions.length + (pro.isLoadMore ? 1 : 0),
itemBuilder: (context, index) {
  if (index < pro.questions.length) {
    final q = pro.questions[index];
    return QuestionCard(
      category: q.category,
      question: q.question,
      answer: q.correctAnswer,
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

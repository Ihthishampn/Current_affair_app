import 'dart:math' as math;

import 'package:current_affairs/models/ownAddQus/ownAddQus.dart';
import 'package:current_affairs/viewmodels/own_add_qus/own_add_qus_provider.dart';
import 'package:current_affairs/views/BookMarkAndReminder/saveOwnQus/custumTextField.dart';
import 'package:current_affairs/views/BookMarkAndReminder/saveOwnQus/gradientButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionDialog extends StatefulWidget {
  const QuestionDialog();

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OwnAddQusProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.blue.shade50.withOpacity(0.3)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Animated background particles
                ...List.generate(5, (index) {
                  return AnimatedBuilder(
                    animation: _floatingController,
                    builder: (context, child) {
                      final offset = math.sin(
                        (_floatingController.value + index / 5) * math.pi * 2,
                      );
                      return Positioned(
                        left: 20 + (index * 60.0),
                        top: 20 + (offset * 30),
                        child: Container(
                          width: 40 + (index * 10.0),
                          height: 40 + (index * 10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.blue.withOpacity(0.1),
                                Colors.purple.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Add Question",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final scale =
                                  1.0 +
                                  (math.sin(
                                        _pulseController.value * math.pi * 2,
                                      ) *
                                      0.1);
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade400,
                                        Colors.purple.shade400,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.4),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.lightbulb,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: CustomTextField(
                          controller: _questionController,
                          label: "Your Question",
                          icon: Icons.help_outline_rounded,
                          maxLines: 3,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Answer
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: CustomTextField(
                          controller: _answerController,
                          label: "Answer",
                          icon: Icons.check_circle_outline_rounded,
                          maxLines: 3,
                        ),
                      ),

                      const SizedBox(height: 24),

                      const SizedBox(height: 20),

                      //  buttons
                      Row(
                        children: [
                          Expanded(
                            child: GradientButton(
                              onPressed: () => Navigator.pop(context),
                              colors: [
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                              ],
                              icon: Icons.close,
                              label: "Cancel",
                              textColor: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GradientButton(
                              onPressed: () {
                                final qus = _questionController.text.trim();
                                final ans = _answerController.text.trim();
                                final status = false;

                                if (qus.isEmpty && ans.isEmpty) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Qus is required')),
                                  );
                                } else {
                                  provider.addQus(
                                    Ownaddqus(
                                      questian: qus,
                                      answer: ans,
                                      status: status,
                                    ),
                                  );
                                  Navigator.pop(context);
                                  _questionController.clear();
                                  _answerController.clear();
                                  provider.isDone = false;
                                }
                              },
                              colors: [
                                Colors.blue.shade500,
                                Colors.purple.shade500,
                              ],
                              icon: Icons.save_rounded,
                              label: "Add",
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:current_affairs/viewmodels/own_add_qus/own_add_qus_provider.dart';
import 'package:current_affairs/views/BookMarkAndReminder/saveOwnQus/alertDilogue.dart';
import 'package:current_affairs/views/BookMarkAndReminder/saveOwnQus/qusAndAnsWidget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class SavedQusScreen extends StatefulWidget {
  const SavedQusScreen({super.key});

  @override
  State<SavedQusScreen> createState() => _SavedQusScreenState();
}

class _SavedQusScreenState extends State<SavedQusScreen>
    with TickerProviderStateMixin {
  late final AnimationController _moveController;
  late final AnimationController _shakeController;
  late final AnimationController _explosionController;
  late final Animation<double> _snakePath;
  late final Animation<double> _shakeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _explosionScale;
  late final Animation<double> _explosionOpacity;

  bool _isMoving = false;

  @override
  void initState() {
    super.initState();

    _moveController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _snakePath = CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOutCubic,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _moveController, curve: Curves.easeInOutBack),
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _explosionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _explosionScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.8,
          end: 2.5,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 2.5,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 70,
      ),
    ]).animate(_explosionController);
    _explosionOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _explosionController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) =>
          Provider.of<OwnAddQusProvider>(context, listen: false).getQus(),
    );
  }

  Future<void> _onFabTap() async {
    if (_isMoving) return;
    setState(() => _isMoving = true);

    await _moveController.forward();
    _shakeController.forward();
    await _explosionController.forward();
    _shakeController.reset();

    if (mounted) {
      await _showQuestionDialog(context);
    }

    _explosionController.reset();
    await _moveController.reverse();

    if (mounted) setState(() => _isMoving = false);
  }

  String filter = 'All';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final startX = size.width - 80;
    final startY = size.height - 190;
    final endX = size.width / 2 - 28;
    final endY = size.height / 2 - 28;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add questions"),
        actions: [
          IconButton(
            onPressed: () async {
              final sortOptions = ['All', 'Completed', 'Pending'];
              final selected = await showMenu<String>(
                context: context,
                position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                items: sortOptions
                    .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
                    .toList(),
              );

              if (selected != null) {
                setState(() => filter = selected);
              }
            },
            icon: Icon(Icons.sort),
          ),

          IconButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: const Color.fromARGB(255, 58, 57, 57),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.blueAccent.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(color: Colors.white24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                            size: 60,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Delete All?",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Are you sure you want to delete all your saved questions?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    34,
                                    33,
                                    33,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

              if (confirm == true) {
                final provider = Provider.of<OwnAddQusProvider>(
                  context,
                  listen: false,
                );
                await provider.deleteAllQus();
              }
            },
            icon: const Icon(Icons.delete_forever, color: Colors.red),
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<OwnAddQusProvider>(
            builder: (context, value, child) {
              if (value.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredList = filter == 'All'
                  ? value.qusLists
                  : filter == 'Completed'
                  ? value.qusLists.where((e) => e.status == true).toList()
                  : value.qusLists.where((e) => e.status == false).toList();

              if (filteredList.isEmpty) {
                return const Center(child: Text('No Questions Found'));
              }

              return ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final qus = filteredList[index];
                  return QAWidget(
                    index: index,
                    question: qus.questian,
                    answer: qus.answer,
                    status: qus.status,
                  );
                },
              );
            },
          ),

          // FAB Animation
          AnimatedBuilder(
            animation: Listenable.merge([
              _moveController,
              _shakeController,
              _explosionController,
            ]),
            builder: (context, child) {
              final t = _snakePath.value;
              final sineWave = math.sin(t * math.pi * 3) * 40 * (1 - t);
              final x = startX + (endX - startX) * t + sineWave;
              final y = startY + (endY - startY) * t;

              final shake = _shakeAnimation.value;
              final shakeX = math.sin(shake * math.pi * 8) * 12 * (1 - shake);
              final shakeY = math.cos(shake * math.pi * 6) * 8 * (1 - shake);
              final rotation = t * math.pi * 2;

              final moveScale = _scaleAnimation.value;
              final explosionScale = _explosionScale.value;
              final scale = _explosionController.isAnimating
                  ? explosionScale
                  : moveScale;

              return Positioned(
                left: x + shakeX,
                top: y + shakeY,
                child: IgnorePointer(
                  ignoring: _isMoving,
                  child: Transform.scale(
                    scale: scale,
                    child: Transform.rotate(angle: rotation, child: child!),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1), 
                    Color(0xFF8B5CF6),
                    Color(0xFFA855F7), 
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _onFabTap,
                  borderRadius: BorderRadius.circular(28),
                  splashColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ),

          // Blue Explosion 
          AnimatedBuilder(
            animation: _explosionController,
            builder: (context, child) {
              if (_explosionController.value == 0) return const SizedBox();
              final t = _explosionController.value;
              final cx = size.width / 2;
              final cy = size.height / 2;
              return Stack(
                children: List.generate(8, (i) {
                  final a = (i / 8) * math.pi * 2;
                  final d = 80 * t;
                  final x = cx + math.cos(a) * d - 20;
                  final y = cy + math.sin(a) * d - 20;
                  final o = (1 - t).clamp(0.0, 1.0);
                  return Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: o,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.blueAccent.withOpacity(0.8),
                              Colors.lightBlue.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // White flash
          AnimatedBuilder(
            animation: _explosionController,
            builder: (context, child) {
              if (_explosionController.value == 0) return const SizedBox();
              final t = _explosionController.value;
              final o = _explosionOpacity.value * (1 - t);
              final s = 1.0 + (t * 3);
              return Positioned(
                left: size.width / 2 - 50,
                top: size.height / 2 - 50,
                child: Opacity(
                  opacity: o.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: s,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.blueAccent.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _moveController.dispose();
    _shakeController.dispose();
    _explosionController.dispose();

    super.dispose();
  }

  Future<void> _showQuestionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => const QuestionDialog(),
    );
  }
}

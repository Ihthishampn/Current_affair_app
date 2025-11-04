import 'package:current_affairs/viewmodels/own_add_qus/own_add_qus_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QAWidget extends StatefulWidget {
  final String question;
  final String answer;
  final int index;
  final bool status;

  const QAWidget({
    super.key,
    required this.question,
    required this.status,
    required this.answer,
    required this.index,
  });

  @override
  State<QAWidget> createState() => _QAWidgetState();
}

class _QAWidgetState extends State<QAWidget> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _statusController;
  late AnimationController _hoverController;

  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _statusBounceAnimation;
  late Animation<double> _hoverElevation;

  bool _isHovered = false;
  bool _showAnswer = true;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _entryController.forward();
  }

  void _initAnimations() {
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _statusController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _statusBounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _statusController, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _statusController, curve: Curves.easeInOut),
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _hoverElevation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _entryController.dispose();
    _statusController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _handleStatusChange(bool val, OwnAddQusProvider provider) async {
    _statusController.forward(from: 0); // Start bounce animation
    final qus = provider.qusLists[widget.index];
    await provider.togleChange(val, qus);
  }

  void _showEditDialog(BuildContext context, OwnAddQusProvider provider) {
    final questionController = TextEditingController(text: widget.question);
    final answerController = TextEditingController(text: widget.answer);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2A2A2A), Color(0xFF1F1F1F)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                blurRadius: 40,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Edit Question',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: questionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Question',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF6366F1),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: answerController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF6366F1),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            final currentQus = provider.qusLists[widget.index];
                            currentQus.questian = questionController.text.trim();
                            currentQus.answer = answerController.text.trim();
                            provider.editQus(currentQus, widget.index);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Text('Question updated successfully!'),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, OwnAddQusProvider provider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2A2A2A), Color(0xFF1F1F1F)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withOpacity(0.2),
                blurRadius: 40,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Delete Question?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This action cannot be undone. The question will be permanently deleted.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          provider.deleteQus(widget.index);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 12),
                                  Text('Question deleted successfully!'),
                                ],
                              ),
                              backgroundColor: const Color(0xFFEF4444),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMenuOptions(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF2A2A2A),
      elevation: 12,
      constraints: const BoxConstraints(minWidth: 160),
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          height: 56,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          height: 56,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      final provider = Provider.of<OwnAddQusProvider>(context, listen: false);
      if (value == 'edit') {
        _showEditDialog(context, provider);
      } else if (value == 'delete') {
        _showDeleteDialog(context, provider);
      }
    });
  }

  double _getResponsiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return mobile;
    if (width < 1024) return tablet;
    return desktop;
  }

  EdgeInsets _getCardMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    } else if (width < 1024) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  }

  EdgeInsets _getContentPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return const EdgeInsets.all(16);
    } else if (width < 1024) {
      return const EdgeInsets.all(20);
    }
    return const EdgeInsets.all(26);
  }

  double _getBorderRadius(BuildContext context) {
    return _getResponsiveValue(context, mobile: 16, tablet: 20, desktop: 24);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _entryController,
        _statusController,
        _hoverController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: MouseRegion(
                onEnter: (_) {
                  setState(() => _isHovered = true);
                  _hoverController.forward();
                },
                onExit: (_) {
                  setState(() => _isHovered = false);
                  _hoverController.reverse();
                },
                child: _buildCard(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context) {
    final borderRadius = _getBorderRadius(context);

    return Container(
      margin: _getCardMargin(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: _getGradientColors().first.withOpacity(0.3),
            blurRadius: 20 + _hoverElevation.value,
            offset: Offset(0, 10 + _hoverElevation.value / 2),
            spreadRadius: -5,
          ),
          if (_isHovered)
            BoxShadow(
              color: _getGradientColors().last.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: -3,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            _buildGradientBackground(context),
            _buildContent(context),
            if (_isHovered) _buildShimmerEffect(),
            _buildMenuButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Positioned(
      top: 15,
      right: 15,
      child: Builder(
        builder: (context) => Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showMenuOptions(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: Colors.white.withOpacity(0.9),
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientBackground(BuildContext context) {
    final borderRadius = _getBorderRadius(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius - 2),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Positioned.fill(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: -1.0, end: 2.0),
        duration: const Duration(milliseconds: 1500),
        builder: (context, value, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: [
                  (value - 0.3).clamp(0.0, 1.0),
                  value.clamp(0.0, 1.0),
                  (value + 0.3).clamp(0.0, 1.0),
                ],
              ),
            ),
          );
        },
        onEnd: () {
          if (_isHovered && mounted) {
            setState(() {});
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final spacing = _getResponsiveValue(
      context,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );

    return Padding(
      padding: _getContentPadding(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: spacing),
          _buildQuestionSection(context),
          SizedBox(height: spacing),
          _buildDivider(context),
          SizedBox(height: spacing),
          _buildAnswerSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionBadge(context),
          const SizedBox(height: 12),
          _buildStatusToggle(context),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionBadge(context),
        Expanded(child: _buildStatusToggle(context)),
      ],
    );
  }

  Widget _buildQuestionBadge(BuildContext context) {
    final iconSize = _getResponsiveValue(
      context,
      mobile: 18.0,
      tablet: 20.0,
      desktop: 22.0,
    );

    final fontSize = _getResponsiveValue(
      context,
      mobile: 10.0,
      tablet: 10.5,
      desktop: 11.0,
    );

    final padding = _getResponsiveValue(
      context,
      mobile: 10.0,
      tablet: 12.0,
      desktop: 14.0,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: padding * 0.6,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.12),
                  const Color(0xFF8B5CF6).withOpacity(0.12),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.psychology_rounded,
                  color: const Color(0xFF6366F1),
                  size: iconSize,
                ),
                SizedBox(width: padding * 0.6),
                Text(
                  "Q",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: const Color(0xFF6366F1),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusToggle(BuildContext context) {
    final iconSize = _getResponsiveValue(
      context,
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );

    final fontSize = _getResponsiveValue(
      context,
      mobile: 10.0,
      tablet: 10.5,
      desktop: 11.0,
    );

    final padding = _getResponsiveValue(
      context,
      mobile: 9.0,
      tablet: 12.0,
      desktop: 14.0,
    );

    final switchScale = _getResponsiveValue(
      context,
      mobile: 0.75,
      tablet: 0.8,
      desktop: 0.85,
    );

    return Consumer<OwnAddQusProvider>(
      builder: (context, provider, child) {
        final isCompleted = provider.qusLists[widget.index].status;

        return Transform.scale(
          scale: _statusBounceAnimation.value,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 5),
            child: Align(
              alignment: Alignment.bottomRight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: padding * 0.6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [
                            const Color(0xFF10B981).withOpacity(0.15),
                            const Color(0xFF059669).withOpacity(0.15),
                          ]
                        : [
                            const Color(0xFFF59E0B).withOpacity(0.15),
                            const Color(0xFFEF4444).withOpacity(0.15),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xFF10B981).withOpacity(0.3)
                        : const Color(0xFFF59E0B).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: RotationTransition(
                            turns: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.pending_rounded,
                        key: ValueKey(isCompleted),
                        color: isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                        size: iconSize,
                      ),
                    ),
                    SizedBox(width: padding * 0.6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: fontSize,
                        color: isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                      child: Text(isCompleted ? "COMPLETED" : "PENDING"),
                    ),
                    SizedBox(width: padding * 0.6),
                    Transform.scale(
                      scale: switchScale,
                      child: Switch(
                        value: isCompleted,
                        onChanged: (val) => _handleStatusChange(val, provider),
                        activeColor: const Color(0xFF10B981),
                        activeTrackColor: const Color(
                          0xFF10B981,
                        ).withOpacity(0.3),
                        inactiveThumbColor: const Color(0xFFF59E0B),
                        inactiveTrackColor: const Color(
                          0xFFF59E0B,
                        ).withOpacity(0.3),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionSection(BuildContext context) {
    final fontSize = _getResponsiveValue(
      context,
      mobile: 16.0,
      tablet: 19.0,
      desktop: 22.0,
    );

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 400),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: const Color.fromARGB(255, 169, 172, 177),
        height: 1.4,
        letterSpacing: -0.5,
        decoration: widget.status ? TextDecoration.lineThrough : null,
        decorationColor: const Color(0xFF10B981),
        decorationThickness: 2.5,
      ),
      child: Text(widget.question),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final width = _getResponsiveValue(
      context,
      mobile: 40.0,
      tablet: 50.0,
      desktop: 60.0,
    );

    final height = _getResponsiveValue(
      context,
      mobile: 4.0,
      tablet: 4.5,
      desktop: 5.0,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: width * value,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.status
                  ? [const Color(0xFF10B981), const Color(0xFF059669)]
                  : [const Color(0xFF6366F1), const Color(0xFFA855F7)],
            ),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color:
                    (widget.status
                            ? const Color(0xFF10B981)
                            : const Color(0xFF6366F1))
                        .withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnswerSection(BuildContext context) {
    final spacing = _getResponsiveValue(
      context,
      mobile: 10.0,
      tablet: 12.0,
      desktop: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnswerBadge(context),
        SizedBox(height: spacing),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _showAnswer ? 1.0 : 0.0,
          child: _buildAnswerText(context),
        ),
      ],
    );
  }

  Widget _buildAnswerText(BuildContext context) {
    final fontSize = _getResponsiveValue(
      context,
      mobile: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 400),
      style: TextStyle(
        fontSize: fontSize,
        color: const Color.fromARGB(255, 202, 204, 206),
        height: 1.7,
        fontWeight: FontWeight.w500,
        decoration: widget.status ? TextDecoration.lineThrough : null,
        decorationColor: const Color(0xFF10B981),
        decorationThickness: 2.5,
      ),
      child: Text(widget.answer),
    );
  }

  Widget _buildAnswerBadge(BuildContext context) {
    final iconSize = _getResponsiveValue(
      context,
      mobile: 18.0,
      tablet: 20.0,
      desktop: 22.0,
    );

    final fontSize = _getResponsiveValue(
      context,
      mobile: 10.0,
      tablet: 10.5,
      desktop: 11.0,
    );

    final padding = _getResponsiveValue(
      context,
      mobile: 10.0,
      tablet: 12.0,
      desktop: 14.0,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: padding * 0.6,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withOpacity(0.12),
                  const Color(0xFF059669).withOpacity(0.12),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: const Color(0xFF10B981),
                  size: iconSize,
                ),
                SizedBox(width: padding * 0.6),
                Text(
                  "ANSWER",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Color> _getGradientColors() {
    return widget.status
        ? [
            const Color(0xFF10B981),
            const Color(0xFF059669),
            const Color(0xFF047857),
          ]
        : [
            const Color(0xFF6366F1),
            const Color(0xFF8B5CF6),
            const Color(0xFFA855F7),
          ];
  }
}

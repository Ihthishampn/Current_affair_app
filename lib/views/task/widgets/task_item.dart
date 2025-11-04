
import 'package:current_affairs/viewmodels/tasks/task_prvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskItemWidget extends StatefulWidget {
  final dynamic task;
  final int index;

  const TaskItemWidget({super.key, required this.task, required this.index});

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _completeController;
  late AnimationController _hoverController;
  late AnimationController _deleteController;

  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _completeBounceAnimation;
  late Animation<double> _hoverElevation;
  late Animation<double> _deleteShakeAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _entryController.forward();
  }

  void _initAnimations() {
    // Entry animation
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    // Complete animation
    _completeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _completeBounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _completeController, curve: Curves.elasticOut),
    );

    // Hover animation
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _hoverElevation = Tween<double>(
      begin: 0.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    // Delete shake animation
    _deleteController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _deleteShakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _deleteController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _completeController.dispose();
    _hoverController.dispose();
    _deleteController.dispose();
    super.dispose();
  }

  // Responsive helpers
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
    if (width < 600) return const EdgeInsets.only(bottom: 10);
    if (width < 1024) return const EdgeInsets.only(bottom: 11);
    return const EdgeInsets.only(bottom: 12);
  }

  EdgeInsets _getContentPadding(BuildContext context) {
    return EdgeInsets.all(
      _getResponsiveValue(context, mobile: 14.0, tablet: 16.0, desktop: 18.0),
    );
  }

  void _handleComplete(TaskPrvider provider) {
    _completeController.forward(from: 0.0).then((_) {
      _completeController.reverse();
    });
    provider.toggleCompleted(!widget.task.completed, widget.index);
  }

  Future<void> _handleDelete(BuildContext context, TaskPrvider provider) async {
    _deleteController.forward(from: 0.0);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDeleteDialog(context),
    );

    if (confirm == true) {
      await provider.deleteTask(widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskPrvider>(context, listen: false);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _entryController,
        _completeController,
        _hoverController,
        _deleteController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_deleteShakeAnimation.value, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _isHovered = true);
                _hoverController.forward();
              },
              onExit: (_) {
                setState(() => _isHovered = false);
                _hoverController.reverse();
              },
              child: _buildCard(context, taskProvider),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, TaskPrvider taskProvider) {
    final borderRadius = _getResponsiveValue(
      context,
      mobile: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );

    return Container(
      key: Key(widget.task.title),
      margin: _getCardMargin(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: _getGradientColors().first.withOpacity(0.25),
            blurRadius: 15 + _hoverElevation.value,
            offset: Offset(0, 8 + _hoverElevation.value / 2),
            spreadRadius: -4,
          ),
          if (_isHovered)
            BoxShadow(
              color: _getGradientColors().last.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 12),
              spreadRadius: -2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            _buildGradientBackground(context),
            _buildContent(context, taskProvider),
            if (_isHovered && !widget.task.completed) _buildShimmerEffect(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBackground(BuildContext context) {
    final borderRadius = _getResponsiveValue(
      context,
      mobile: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );

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
                  Colors.white.withOpacity(0.08),
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
          if (_isHovered && mounted && !widget.task.completed) {
            setState(() {});
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, TaskPrvider taskProvider) {
    return Padding(
      padding: _getContentPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, taskProvider),
          if (widget.task.content.isNotEmpty) ...[
            SizedBox(
              height: _getResponsiveValue(
                context,
                mobile: 10.0,
                tablet: 12.0,
                desktop: 14.0,
              ),
            ),
            _buildDescription(context),
          ],
          SizedBox(
            height: _getResponsiveValue(
              context,
              mobile: 12.0,
              tablet: 14.0,
              desktop: 16.0,
            ),
          ),
          _buildDivider(context),
          SizedBox(
            height: _getResponsiveValue(
              context,
              mobile: 10.0,
              tablet: 12.0,
              desktop: 14.0,
            ),
          ),
          _buildMetadata(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TaskPrvider taskProvider) {
    return Row(
      children: [
        Transform.scale(
          scale: _completeBounceAnimation.value,
          child: _buildCheckButton(context, taskProvider),
        ),
        SizedBox(
          width: _getResponsiveValue(
            context,
            mobile: 8.0,
            tablet: 10.0,
            desktop: 12.0,
          ),
        ),
        Expanded(child: _buildTitle(context)),
        SizedBox(
          width: _getResponsiveValue(
            context,
            mobile: 4.0,
            tablet: 6.0,
            desktop: 8.0,
          ),
        ),
        _buildDeleteButton(context, taskProvider),
      ],
    );
  }

  Widget _buildCheckButton(BuildContext context, TaskPrvider taskProvider) {
    final size = _getResponsiveValue(
      context,
      mobile: 26.0,
      tablet: 28.0,
      desktop: 30.0,
    );

    return InkWell(
      onTap: () => _handleComplete(taskProvider),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: widget.task.completed
              ? LinearGradient(
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.2),
                    const Color(0xFF059669).withOpacity(0.2),
                  ],
                )
              : null,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: RotationTransition(turns: animation, child: child),
            );
          },
          child: Icon(
            widget.task.completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            key: ValueKey(widget.task.completed),
            color: widget.task.completed
                ? const Color(0xFF10B981)
                : const Color(0xFF94A3B8),
            size: size,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final fontSize = _getResponsiveValue(
      context,
      mobile: 16.0,
      tablet: 17.0,
      desktop: 18.0,
    );

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        color: widget.task.completed
            ? const Color(0xFF64748B)
            : const Color.fromARGB(255, 165, 167, 169),
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 1.3,
        decoration: widget.task.completed ? TextDecoration.lineThrough : null,
        decorationColor: const Color(0xFF10B981),
        decorationThickness: 2.0,
      ),
      child: Text(
        widget.task.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, TaskPrvider taskProvider) {
    final size = _getResponsiveValue(
      context,
      mobile: 20.0,
      tablet: 22.0,
      desktop: 24.0,
    );

    return InkWell(
      onTap: () => _handleDelete(context, taskProvider),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              const Color(0xFFEF4444).withOpacity(0.1),
              const Color(0xFFDC2626).withOpacity(0.1),
            ],
          ),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: const Color(0xFFEF4444),
          size: size,
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final fontSize = _getResponsiveValue(
      context,
      mobile: 13.0,
      tablet: 13.5,
      desktop: 14.0,
    );

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        color: widget.task.completed
            ? const Color(0xFF94A3B8)
            : const Color(0xFF64748B),
        fontSize: fontSize,
        height: 1.6,
        fontWeight: FontWeight.w500,
        decoration: widget.task.completed ? TextDecoration.lineThrough : null,
        decorationColor: const Color(0xFF10B981),
        decorationThickness: 1.5,
      ),
      child: Text(widget.task.content, softWrap: true),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            (widget.task.completed
                    ? const Color(0xFF10B981)
                    : const Color(0xFF6366F1))
                .withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final fontSize = _getResponsiveValue(
      context,
      mobile: 11.0,
      tablet: 11.5,
      desktop: 12.0,
    );

    final iconSize = _getResponsiveValue(
      context,
      mobile: 13.0,
      tablet: 13.5,
      desktop: 14.0,
    );

    return Wrap(
      spacing: 16,
      runSpacing: 10,
      children: [
        _buildMetadataItem(
          context,
          icon: Icons.calendar_today_rounded,
          text: widget.task.day,
          fontSize: fontSize,
          iconSize: iconSize,
        ),
        _buildMetadataItem(
          context,
          icon: Icons.access_time_rounded,
          text: '${widget.task.starttime} - ${widget.task.endtime}',
          fontSize: fontSize,
          iconSize: iconSize,
        ),
        _buildImportantBadge(context, fontSize, iconSize),
      ],
    );
  }

  Widget _buildMetadataItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required double fontSize,
    required double iconSize,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
            (widget.task.completed
                    ? const Color(0xFF10B981)
                    : const Color(0xFF6366F1))
                .withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              (widget.task.completed
                      ? const Color(0xFF10B981)
                      : const Color(0xFF6366F1))
                  .withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: widget.task.completed
                ? const Color(0xFF10B981)
                : const Color(0xFF6366F1),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: widget.task.completed
                  ? const Color(0xFF059669)
                  : const Color(0xFF475569),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantBadge(
    BuildContext context,
    double fontSize,
    double iconSize,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.task.important
              ? [
                  const Color(0xFFFBBF24).withOpacity(0.15),
                  const Color(0xFFF59E0B).withOpacity(0.15),
                ]
              : [
                  const Color(0xFF94A3B8).withOpacity(0.08),
                  const Color(0xFF64748B).withOpacity(0.08),
                ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.task.important
              ? const Color(0xFFFBBF24).withOpacity(0.3)
              : const Color(0xFF94A3B8).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.task.important
                ? Icons.star_rounded
                : Icons.star_outline_rounded,
            size: iconSize + 1,
            color: widget.task.important
                ? const Color(0xFFF59E0B)
                : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 6),
          Text(
            widget.task.important ? 'Important' : 'Normal',
            style: TextStyle(
              color: widget.task.important
                  ? const Color(0xFFD97706)
                  : const Color(0xFF64748B),
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 28),
          SizedBox(width: 12),
          Text(
            'Delete Task',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: const Text(
        'Are you sure you want to delete this task? This action cannot be undone.',
        style: TextStyle(color: Color(0xFF64748B), fontSize: 15, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Color> _getGradientColors() {
    if (widget.task.completed) {
      return [
        const Color(0xFF10B981),
        const Color(0xFF059669),
        const Color(0xFF047857),
      ];
    }
    return [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFFA855F7),
    ];
  }
}
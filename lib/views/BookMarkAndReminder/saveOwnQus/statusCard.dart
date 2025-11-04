
import 'package:flutter/material.dart';

class StatusCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final List<Color> colors;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.colors,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<StatusCard> createState() => StatusCardState();
}

class StatusCardState extends State<StatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _bounceController.forward(),
      onTapUp: (_) {
        _bounceController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _bounceController.reverse(),
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          final scale = 1.0 - (_bounceController.value * 0.05);
          return Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? LinearGradient(colors: widget.colors)
                    : LinearGradient(
                        colors: [Colors.grey.shade100, Colors.grey.shade200],
                      ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.colors.first
                      : Colors.grey.shade300,
                  width: widget.isSelected ? 3 : 1,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: widget.colors.first.withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Icon(
                    widget.icon,
                    color: widget.isSelected
                        ? Colors.white
                        : Colors.grey.shade600,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isSelected ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: widget.isSelected
                          ? Colors.white.withOpacity(0.9)
                          : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

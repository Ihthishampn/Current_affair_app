import 'package:current_affairs/viewmodels/tasks/task_prvider.dart';
import 'package:current_affairs/views/task/widgets/delete_confirmation_dilougue.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAllButton extends StatefulWidget {
  const DeleteAllButton({super.key});

  @override
  State<DeleteAllButton> createState() => _DeleteAllButtonState();
}

class _DeleteAllButtonState extends State<DeleteAllButton> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() => isAnimating = true);

        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => isAnimating = false);

        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => const DeleteConfirmationDialog(),
        );

        if (confirm == true) {
          final provider = Provider.of<TaskPrvider>(context, listen: false);
          provider.delete();
        }
      },
      child: AnimatedScale(
        scale: isAnimating ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: AnimatedRotation(
          turns: isAnimating ? 2 : 0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Task status chip - hiển thị trạng thái task
class TaskStatusChip extends StatelessWidget {
  final String status;
  final bool small;

  const TaskStatusChip({super.key, required this.status, this.small = false});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(small ? 4 : 6),
        border: Border.all(color: config.color.withOpacity(0.25)),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.color,
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _StatusConfig _getConfig(String status) {
    switch (status) {
      case 'todo':
        return _StatusConfig('Todo', AppColors.statusTodo);
      case 'in-progress':
        return _StatusConfig('In Progress', AppColors.statusInProgress);
      case 'ready-for-review':
        return _StatusConfig('Review', AppColors.statusReview);
      case 'done':
        return _StatusConfig('Done', AppColors.statusDone);
      default:
        return _StatusConfig(status, AppColors.textMuted);
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  _StatusConfig(this.label, this.color);
}

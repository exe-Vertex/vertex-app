import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/project.dart';

/// Project card widget
class ProjectCard extends StatelessWidget {
  final ProjectSummary project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      project.name.isNotEmpty ? project.name[0].toUpperCase() : 'P',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (project.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          project.description!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.textMuted, size: 20),
              ],
            ),

            const SizedBox(height: 14),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: project.progress / 100,
                backgroundColor: AppColors.bgInput,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _progressColor(project.progress),
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 10),

            // Bottom info
            Row(
              children: [
                _InfoChip(
                  icon: Icons.task_alt,
                  text: '${project.taskCount} tasks',
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.people_outline,
                  text: '${project.memberCount}',
                ),
                const Spacer(),
                Text(
                  '${project.progress.toInt()}%',
                  style: TextStyle(
                    color: _progressColor(project.progress),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _progressColor(double progress) {
    if (progress >= 80) return AppColors.statusDone;
    if (progress >= 50) return AppColors.statusInProgress;
    if (progress >= 25) return AppColors.statusReview;
    return AppColors.statusTodo;
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

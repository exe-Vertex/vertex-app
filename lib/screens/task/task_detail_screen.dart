import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../api/project_service.dart';
import '../../api/lecturer_service.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../widgets/task_status_chip.dart';

class TaskDetailScreen extends StatefulWidget {
  final String orgId;
  final String projectId;
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.orgId,
    required this.projectId,
    required this.task,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;
  List<TaskComment> _comments = [];
  bool _isLoadingComments = true;
  final _commentController = TextEditingController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    try {
      _comments = await ProjectService.listComments(
          widget.orgId, widget.projectId, _task.id);
    } catch (e) {
      debugPrint('Error loading comments: $e');
    }
    if (mounted) setState(() => _isLoadingComments = false);
  }

  Future<void> _sendComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSending = true);
    try {
      final user = context.read<AuthProvider>().user;
      if (user?.role == 'lecturer') {
        await LecturerService.addComment(_task.id, content);
        await _loadComments();
        _commentController.clear();
      } else {
        final comment = await ProjectService.addComment(
            widget.orgId, widget.projectId, _task.id, content);
        setState(() {
          _comments.add(comment);
          _commentController.clear();
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    setState(() => _isSending = false);
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      final updated = await ProjectService.updateTaskStatus(
          widget.orgId, widget.projectId, _task.id, newStatus);
      setState(() => _task = updated);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final isLecturer = user?.role == 'lecturer';

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text('Chi tiết Task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _task.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status & Priority row
                  Row(
                    children: [
                      TaskStatusChip(status: _task.status),
                      const SizedBox(width: 8),
                      _PriorityChip(priority: _task.priority),
                      const Spacer(),
                      // Status change button
                      if (isLecturer && _task.status == 'ready-for-review')
                        _buildLecturerActions()
                      else if (!isLecturer)
                        _buildStatusButton(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Info cards
                  _buildInfoSection(),
                  const SizedBox(height: 20),

                  // Description
                  if (_task.description != null &&
                      _task.description!.isNotEmpty) ...[
                    const Text(
                      'Mô tả',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        _task.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Subtasks
                  if (_task.subtasks.isNotEmpty) ...[
                    _buildSubtasksSection(),
                    const SizedBox(height: 20),
                  ],

                  // Comments
                  _buildCommentsSection(),
                ],
              ),
            ),
          ),

          // Comment input
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildLecturerActions() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              await LecturerService.approveTask(_task.id);
              setState(() => _task = _task.copyWith(status: 'done'));
            } catch (e) {
              debugPrint('Approve error: $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.statusDone,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            minimumSize: const Size(0, 36),
          ),
          child: const Text('Phê duyệt', style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            try {
              await LecturerService.requestChanges(_task.id);
              setState(() => _task = _task.copyWith(status: 'in-progress'));
            } catch (e) {
              debugPrint('Request changes error: $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            minimumSize: const Size(0, 36),
          ),
          child: const Text('Yêu cầu sửa', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildStatusButton() {
    return PopupMenuButton<String>(
      onSelected: _updateStatus,
      color: AppColors.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.border),
      ),
      itemBuilder: (context) => [
        _statusMenuItem('todo', 'Todo', AppColors.statusTodo),
        _statusMenuItem('in-progress', 'In Progress', AppColors.statusInProgress),
        _statusMenuItem(
            'ready-for-review', 'Review', AppColors.statusReview),
        _statusMenuItem('done', 'Done', AppColors.statusDone),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              'Đổi status',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _statusMenuItem(
      String value, String label, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(label,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          if (_task.status == value) ...[
            const Spacer(),
            const Icon(Icons.check, size: 16, color: AppColors.primary),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_outline,
            label: 'Assignee',
            value: _task.assignee?.name ?? 'Chưa phân công',
          ),
          const Divider(color: AppColors.border, height: 20),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Bắt đầu',
            value: _formatDate(_task.startDate),
          ),
          const Divider(color: AppColors.border, height: 20),
          _InfoRow(
            icon: Icons.event_outlined,
            label: 'Deadline',
            value: _formatDate(_task.endDate),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtasksSection() {
    final completed = _task.subtasks.where((s) => s.isCompleted).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Subtasks',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$completed/${_task.subtasks.length}',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...(_task.subtasks.map((subtask) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    subtask.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color: subtask.isCompleted
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      subtask.title,
                      style: TextStyle(
                        fontSize: 13,
                        color: subtask.isCompleted
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        decoration: subtask.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ))),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments (${_comments.length})',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoadingComments)
          const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
        else if (_comments.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text(
                'Chưa có comment nào',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
          )
        else
          ..._comments.map((comment) => _buildCommentItem(comment)),
      ],
    );
  }

  Widget _buildCommentItem(TaskComment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    comment.userName.isNotEmpty
                        ? comment.userName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColors.info,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                comment.userName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(comment.createdAt),
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Viết comment...',
                  hintStyle:
                      const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  filled: true,
                  fillColor: AppColors.bgSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isSending ? null : _sendComment,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: _isSending
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return isoDate;
    }
  }
}

class _PriorityChip extends StatelessWidget {
  final String priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _getColor() {
    switch (priority) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      case 'low':
        return AppColors.priorityLow;
      default:
        return AppColors.textMuted;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Text(label,
            style:
                const TextStyle(fontSize: 13, color: AppColors.textMuted)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

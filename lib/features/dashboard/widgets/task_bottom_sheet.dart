import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/task_model.dart';
import '../../../core/providers/task_provider.dart';
import '../../../core/providers/task_detail_provider.dart';
import 'package:intl/intl.dart';

class TaskBottomSheet extends StatefulWidget {
  final TaskModel task;
  final String orgId;
  final String projectId;

  const TaskBottomSheet({
    super.key,
    required this.task,
    required this.orgId,
    required this.projectId,
  });

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  final _commentController = TextEditingController();
  final _subtaskController = TextEditingController();
  late String _currentStatus;
  bool _isAddingSubtask = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.task.status;
  }

  @override
  void dispose() {
    _commentController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  void _onStatusChanged(String? newStatus) {
    if (newStatus != null && newStatus != _currentStatus) {
      setState(() {
        _currentStatus = newStatus;
      });
      context.read<TaskProvider>().updateTaskStatus(widget.task.id, newStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskDetailProvider(
        orgId: widget.orgId,
        projectId: widget.projectId,
        taskId: widget.task.id,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F1A2A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize
              .min, // Keep min so it only takes needed space, but can scroll if needed
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Text(
              widget.task.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.task.description ?? 'No description provided.',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),

            // Subtasks and Comments need to be scrollable if there are many
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subtasks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSubtaskList(),
                    _buildAddSubtask(),

                    const SizedBox(height: 24),
                    const Text(
                      'Comments',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCommentList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildCommentInput(),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _currentStatus == 'Done'
                ? Colors.green.withValues(alpha: 0.2)
                : _currentStatus == 'In Progress'
                ? Colors.blue.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: ['Todo', 'In Progress', 'Done'].contains(_currentStatus)
                  ? _currentStatus
                  : 'Todo',
              dropdownColor: const Color(0xFF162032),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white70,
                size: 20,
              ),
              style: TextStyle(
                color: _currentStatus == 'Done'
                    ? Colors.green
                    : _currentStatus == 'In Progress'
                    ? Colors.blue
                    : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              items: const [
                DropdownMenuItem(value: 'Todo', child: Text('Todo')),
                DropdownMenuItem(
                  value: 'In Progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem(value: 'Done', child: Text('Done')),
              ],
              onChanged: _onStatusChanged,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSubtaskList() {
    return Consumer<TaskDetailProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.subtasks.isEmpty && !_isAddingSubtask) {
          return const Text(
            'No subtasks.',
            style: TextStyle(color: Colors.grey),
          );
        }
        return Column(
          children: provider.subtasks.map((st) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => provider.toggleSubtask(st.id, !st.isCompleted),
                    icon: Icon(
                      st.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: st.isCompleted
                          ? Theme.of(context).primaryColor
                          : Colors.grey[600],
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      st.title,
                      style: TextStyle(
                        decoration: st.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: st.isCompleted ? Colors.grey[500] : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAddSubtask() {
    return Consumer<TaskDetailProvider>(
      builder: (context, provider, child) {
        if (_isAddingSubtask) {
          return Row(
            children: [
              const Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _subtaskController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'New subtask...',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      provider.addSubtask(val.trim());
                    }
                    setState(() {
                      _isAddingSubtask = false;
                      _subtaskController.clear();
                    });
                  },
                ),
              ),
            ],
          );
        }
        return InkWell(
          onTap: () => setState(() => _isAddingSubtask = true),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.cyanAccent, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Add subtask',
                  style: TextStyle(color: Colors.cyanAccent),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentList() {
    return Consumer<TaskDetailProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.comments.isEmpty) {
          return const Text(
            'No comments yet.',
            style: TextStyle(color: Colors.grey),
          );
        }
        return Column(
          children: provider.comments.map((comment) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.2),
                    child: Text(
                      comment.userName.isNotEmpty
                          ? comment.userName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              comment.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat(
                                'MMM d, HH:mm',
                              ).format(comment.createdAt.toLocal()),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comment.content,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCommentInput() {
    return Consumer<TaskDetailProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  filled: true,
                  fillColor: const Color(0xFF162032),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, size: 18, color: Colors.black),
                onPressed: () {
                  final text = _commentController.text.trim();
                  if (text.isNotEmpty) {
                    provider.addComment(text);
                    _commentController.clear();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

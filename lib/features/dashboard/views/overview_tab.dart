import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/task_provider.dart';
import '../../../core/providers/workspace_provider.dart';
import '../../../core/models/task_model.dart';
import '../widgets/task_bottom_sheet.dart';
import '../widgets/create_task_dialog.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  void _showTaskDetails(
    BuildContext context,
    TaskModel task,
    String orgId,
    String projectId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TaskBottomSheet(task: task, orgId: orgId, projectId: projectId),
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context, String initialStatus) {
    showDialog(
      context: context,
      builder: (context) => CreateTaskDialog(initialStatus: initialStatus),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    if (taskProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taskProvider.errorMessage != null) {
      return Center(
        child: Text(
          taskProvider.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final tasks = taskProvider.tasks;
    final todoTasks = tasks.where((t) => t.status.toLowerCase() == 'todo').toList();
    final inProgressTasks = tasks
        .where((t) => t.status.toLowerCase() == 'in progress' || t.status.toLowerCase() == 'in-progress')
        .toList();
    final doneTasks = tasks.where((t) => t.status.toLowerCase() == 'done').toList();
    
    // Catch-all for tasks with unrecognized statuses
    final otherTasks = tasks.where((t) => 
      t.status.toLowerCase() != 'todo' && 
      t.status.toLowerCase() != 'in progress' && 
      t.status.toLowerCase() != 'in-progress' && 
      t.status.toLowerCase() != 'done'
    ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Tasks',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.cyanAccent),
                onPressed: () => _showCreateTaskDialog(context, 'Todo'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildSectionTitle('To Do'),
          ...todoTasks.map((t) => _buildTaskCard(context, t)),
          _buildAddTaskButton(context, 'Todo'),
          const SizedBox(height: 16),

          if (inProgressTasks.isNotEmpty) ...[
            _buildSectionTitle('In Progress'),
            ...inProgressTasks.map((t) => _buildTaskCard(context, t)),
            const SizedBox(height: 16),
          ],

          if (doneTasks.isNotEmpty) ...[
            _buildSectionTitle('Done'),
            ...doneTasks.map((t) => _buildTaskCard(context, t)),
            const SizedBox(height: 16),
          ],
          
          if (otherTasks.isNotEmpty) ...[
            _buildSectionTitle('Other Statuses'),
            ...otherTasks.map((t) => _buildTaskCard(context, t)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAddTaskButton(BuildContext context, String status) {
    return InkWell(
      onTap: () => _showCreateTaskDialog(context, status),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.cyanAccent, size: 20),
            const SizedBox(width: 12),
            Text(
              'Add Task',
              style: TextStyle(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskModel task) {
    final workspaceProvider = context.read<WorkspaceProvider>();
    final orgId = workspaceProvider.activeWorkspace?.id ?? '';
    final projectId = workspaceProvider.activeProjectId ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _showTaskDetails(context, task, orgId, projectId),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  task.status == 'Done'
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: task.status == 'Done' ? Colors.green : Colors.grey[400],
                ),
                onPressed: () {
                  final newStatus = task.status == 'Done' ? 'Todo' : 'Done';
                  context.read<TaskProvider>().updateTaskStatus(task.id, newStatus);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: task.status == 'Done'
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.status == 'Done'
                        ? Colors.grey[500]
                        : Colors.white,
                  ),
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/workspace_provider.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<WorkspaceProvider>().activeWorkspaceProjects;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.folder, color: Theme.of(context).primaryColor),
            ),
            title: Text(
              project.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Updated 2 days ago'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.read<WorkspaceProvider>().selectProject(project.id);
            },
          ),
        );
      },
    );
  }
}

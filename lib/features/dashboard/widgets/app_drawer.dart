import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/workspace_provider.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback? onProjectSelected;

  const AppDrawer({super.key, this.onProjectSelected});

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = context.watch<WorkspaceProvider>();
    final activeWorkspace = workspaceProvider.activeWorkspace;
    final workspaces = workspaceProvider.workspaces;
    final projects = workspaceProvider.activeWorkspaceProjects;
    final activeProjectId = workspaceProvider.activeProjectId;

    return Drawer(
      backgroundColor: const Color(0xFF0F1A2A), // Card background
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Workspace Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.business,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: activeWorkspace?.id,
                        dropdownColor: const Color(0xFF162032),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            workspaceProvider.switchWorkspace(newValue);
                          }
                        },
                        items: workspaces.map<DropdownMenuItem<String>>((ws) {
                          return DropdownMenuItem<String>(
                            value: ws.id,
                            child: Text(
                              ws.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10),

            // Projects List
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'YOUR PROJECTS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    color: Colors.grey[500],
                    onPressed: () {
                      // Handle create project
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  final isActive = project.id == activeProjectId;

                  return ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: isActive
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.15)
                        : null,
                    leading: Icon(
                      Icons.folder_open,
                      color: isActive
                          ? Theme.of(context).primaryColor
                          : Colors.grey[500],
                      size: 20,
                    ),
                    title: Text(
                      project.name,
                      style: TextStyle(
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : Colors.grey[400],
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      workspaceProvider.selectProject(project.id);
                      Navigator.pop(context); // Close drawer after selection
                      onProjectSelected?.call(); // Navigate to overview tab
                    },
                  );
                },
              ),
            ),

            // Upgrade Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      const Color(0xFFEAB308).withValues(alpha: 0.1), // Yellow
                    ],
                  ),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.2),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upgrade to Pro',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get unlimited projects and team members.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'View Plans',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text(
                'Log out',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}

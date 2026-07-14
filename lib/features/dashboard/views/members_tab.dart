import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/workspace_provider.dart';

class MembersTab extends StatelessWidget {
  const MembersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = context.watch<WorkspaceProvider>();

    if (workspaceProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final members = workspaceProvider.activeProjectMembers;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Project Members',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ElevatedButton.icon(
              onPressed: () {}, // Future: Invite Member API
              icon: const Icon(Icons.person_add, size: 16),
              label: const Text('Invite'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (members.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Center(
              child: Text(
                'No members found.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ...members.map(
          (m) => _buildMemberCard(context, m.name, m.email, m.role),
        ),
      ],
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    String name,
    String email,
    String role,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withValues(alpha: 0.2),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(email.isNotEmpty ? email : 'No email'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF162032),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            role,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ),
      ),
    );
  }
}

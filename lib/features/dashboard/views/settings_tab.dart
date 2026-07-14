import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/auth_service.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  void _handleLogout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),

        // Profile Section
        if (authProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (user != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.2),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF162032),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.role,
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 24),
        const Text(
          'GENERAL',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildSettingsCard(
          children: [
            _buildSettingsTile(
              Icons.notifications_none,
              'Notifications',
              onTap: () {},
            ),
            _buildSettingsTile(
              Icons.language,
              'Language & Region',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'ACCOUNT',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildSettingsCard(
          children: [
            _buildSettingsTile(
              Icons.logout,
              'Log Out',
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      child: Column(
        children: children.map((child) {
          final index = children.indexOf(child);
          if (index == children.length - 1) {
            return child;
          }
          return Column(
            children: [child, const Divider(height: 1, indent: 56)],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title, {
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey[400]),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/workspace_provider.dart';
import '../../../core/providers/auth_provider.dart';
import 'widgets/app_drawer.dart';
import 'views/overview_tab.dart';
import 'views/projects_tab.dart';
import 'views/members_tab.dart';
import 'views/settings_tab.dart';
import '../ai/ai_chat_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        context.read<WorkspaceProvider>().fetchInitialData();
        context.read<AuthProvider>().fetchMe();
        _isInitialized = true;
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _showAiChat(BuildContext context, String? orgId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AiChatWidget(orgId: orgId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = context.watch<WorkspaceProvider>();
    final activeWorkspace = workspaceProvider.activeWorkspace;
    final activeProject = workspaceProvider.activeWorkspaceProjects
        .where((p) => p.id == workspaceProvider.activeProjectId)
        .firstOrNull;

    final List<Widget> tabs = [
      const OverviewTab(),
      ProjectsTab(onProjectSelected: () => _onTabTapped(0)),
      const MembersTab(),
      const SettingsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activeWorkspace?.name ?? 'Dashboard',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (activeProject != null)
              Text(
                'Project: ${activeProject.name}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(onProjectSelected: () => _onTabTapped(0)),
      body: workspaceProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : workspaceProvider.errorMessage != null
          ? Center(
              child: Text(
                workspaceProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : tabs[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAiChat(context, activeWorkspace?.id),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.secondary, // Cyan accent color
        child: const Icon(Icons.auto_awesome, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F1A2A),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[500],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Members'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

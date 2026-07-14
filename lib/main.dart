import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/workspace_provider.dart';
import 'core/providers/task_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/ai_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WorkspaceProvider()),
        ChangeNotifierProxyProvider<WorkspaceProvider, TaskProvider>(
          create: (_) => TaskProvider(),
          update: (_, workspaceProvider, taskProvider) {
            taskProvider!.updateContext(
              workspaceProvider.activeWorkspace?.id,
              workspaceProvider.activeProjectId,
            );
            return taskProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => AiProvider()),
      ],
      child: const VertexApp(),
    ),
  );
}

class VertexApp extends StatelessWidget {
  const VertexApp({super.key});

  @override
  Widget build(BuildContext context) {
    // In the future, we can wrap MaterialApp.router with MultiProvider here
    return MaterialApp.router(
      title: 'Vertex',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

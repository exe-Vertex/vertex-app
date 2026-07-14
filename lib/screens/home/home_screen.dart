import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../api/project_service.dart';
import '../../api/lecturer_service.dart';
import '../../models/project.dart';
import '../../models/organization.dart';
import '../../widgets/project_card.dart';
import '../../widgets/task_status_chip.dart';
import '../../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<OrgSummary> _orgs = [];
  List<ProjectSummary> _projects = [];
  ProjectDetail? _activeProject;
  bool _isLoading = true;
  String? _activeOrgId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final user = context.read<AuthProvider>().user;
      if (user?.role == 'lecturer') {
        _projects = await LecturerService.getGroups();
      } else {
        _orgs = await ProjectService.listOrgs();
        if (_orgs.isNotEmpty) {
          _activeOrgId = _orgs.first.id;
          _projects = await ProjectService.listProjects(_activeOrgId!);
          if (_projects.isNotEmpty) {
            _activeProject = await ProjectService.getProjectDetail(
                _activeOrgId!, _projects.first.id);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.bgCard,
                onRefresh: _loadData,
                child: CustomScrollView(
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: _buildHeader(user?.name ?? 'User'),
                    ),

                    // Stats cards
                    if (user?.role != 'lecturer') 
                      SliverToBoxAdapter(child: _buildStatsRow()),

                    // My Tasks Today
                    if (user?.role != 'lecturer')
                      SliverToBoxAdapter(child: _buildMyTasksSection()),

                    // Projects Header
                    SliverToBoxAdapter(child: _buildProjectsHeader()),

                    // Projects List
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final project = _projects[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ProjectCard(
                              project: project,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/project-detail',
                                  arguments: {
                                    'orgId': _activeOrgId ?? '',
                                    'projectId': project.id,
                                  },
                                );
                              },
                            ),
                          );
                        },
                        childCount: _projects.length,
                      ),
                    ),

                    // Bottom padding
                    const SliverToBoxAdapter(
                        child: SizedBox(height: 100)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Shimmer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading.text(width: 100, height: 14),
                      const SizedBox(height: 8),
                      ShimmerLoading.text(width: 150, height: 26),
                    ],
                  ),
                ),
                ShimmerLoading.box(width: 60, height: 32),
              ],
            ),
          ),
          
          // Stats Shimmer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < 3 ? 10.0 : 0),
                    child: ShimmerLoading.statCard(),
                  ),
                ),
              ),
            ),
          ),
          
          // Tasks Shimmer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading.text(width: 120, height: 20),
                const SizedBox(height: 12),
                ShimmerLoading.taskItem(),
                ShimmerLoading.taskItem(),
              ],
            ),
          ),
          
          // Projects Shimmer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading.text(width: 100, height: 20),
                const SizedBox(height: 12),
                ShimmerLoading.projectCard(),
                ShimmerLoading.projectCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String userName) {
    final firstName = userName.split(' ').last;
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Chào buổi sáng';
    } else if (hour < 18) {
      greeting = 'Chào buổi chiều';
    } else {
      greeting = 'Chào buổi tối';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting 👋',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  firstName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Org indicator
          if (_orgs.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.borderPrimary),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _orgs.first.name,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final todoCount = _activeProject?.todoCount ?? 0;
    final inProgressCount = _activeProject?.inProgressCount ?? 0;
    final reviewCount = _activeProject?.reviewCount ?? 0;
    final doneCount = _activeProject?.doneCount ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          _StatCard(
            label: 'Cần làm',
            value: '$todoCount',
            color: AppColors.statusTodo,
            icon: Icons.radio_button_unchecked,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Đang làm',
            value: '$inProgressCount',
            color: AppColors.statusInProgress,
            icon: Icons.timelapse,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Review',
            value: '$reviewCount',
            color: AppColors.statusReview,
            icon: Icons.rate_review_outlined,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Xong',
            value: '$doneCount',
            color: AppColors.statusDone,
            icon: Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildMyTasksSection() {
    final myTasks = _activeProject?.tasks
            .where((t) =>
                t.status != 'done' &&
                (t.assignee?.userId == 'u1' || t.assignee == null))
            .toList() ??
        [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tasks của bạn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${myTasks.length} tasks',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (myTasks.isEmpty)
            _buildEmptyState('Không có task nào 🎉')
          else
            ...myTasks.take(3).map((task) => _buildTaskItem(task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Priority indicator
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _priorityColor(task.priority),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    TaskStatusChip(status: task.status, small: true),
                    const SizedBox(width: 8),
                    if (task.commentCount > 0) ...[
                      Icon(Icons.chat_bubble_outline,
                          size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 3),
                      Text('${task.commentCount}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Assignee avatar
          if (task.assignee != null)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  task.assignee!.initials,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProjectsHeader() {
    final user = context.watch<AuthProvider>().user;
    final title = user?.role == 'lecturer' ? 'Các nhóm hướng dẫn' : 'Dự án';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ),
    );
  }

  Color _priorityColor(String priority) {
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

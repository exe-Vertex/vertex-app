import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/lecturer.dart';
import '../../api/lecturer_service.dart';
import 'lecturer_group_detail_screen.dart';

class LecturerDashboardScreen extends StatefulWidget {
  const LecturerDashboardScreen({super.key});

  @override
  State<LecturerDashboardScreen> createState() => _LecturerDashboardScreenState();
}

class _LecturerDashboardScreenState extends State<LecturerDashboardScreen> {
  bool _isLoading = true;
  String? _error;
  List<LecturerGroup> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final groups = await LecturerService.getGroups();
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        title: const Text(
          'Quản lý lớp',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              'Lỗi khi tải dữ liệu',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGroups,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_groups.isEmpty) {
      return Center(
        child: Text(
          'Bạn chưa quản lý nhóm nào.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGroups,
      color: AppColors.primary,
      backgroundColor: AppColors.bgCard,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          final group = _groups[index];
          return _buildGroupCard(context, group);
        },
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, LecturerGroup group) {
    final needsReview = group.inReviewTasks > 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: needsReview ? AppColors.warning.withValues(alpha: 0.5) : AppColors.border,
          width: 1,
        ),
        boxShadow: needsReview ? [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LecturerGroupDetailScreen(
                  projectId: group.id,
                  projectName: group.name,
                ),
              ),
            ).then((_) => _loadGroups());
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        group.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (needsReview)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.pending_actions, size: 14, color: AppColors.warning),
                            const SizedBox(width: 4),
                            Text(
                              '${group.inReviewTasks} cần duyệt',
                              style: const TextStyle(
                                color: AppColors.warning,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  group.organizationName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: group.progress / 100,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          color: AppColors.success,
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${group.progress}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: AppColors.border),
                const SizedBox(height: 12),
                
                // Footer metrics
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricRow(Icons.group_outlined, '${group.memberCount} thành viên'),
                    _buildMetricRow(Icons.check_circle_outline, '${group.approvedTasks}/${group.totalTasks} Tasks'),
                    _buildMetricRow(Icons.event_outlined, group.deadline),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.5)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/lecturer.dart';
import '../../api/lecturer_service.dart';

class LecturerGroupDetailScreen extends StatefulWidget {
  final String projectId;
  final String projectName;

  const LecturerGroupDetailScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<LecturerGroupDetailScreen> createState() => _LecturerGroupDetailScreenState();
}

class _LecturerGroupDetailScreenState extends State<LecturerGroupDetailScreen> {
  bool _isLoading = true;
  String? _error;
  LecturerGroupDetail? _detail;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final detail = await LecturerService.getGroupDetail(widget.projectId);
      setState(() {
        _detail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleApprove(String taskId) async {
    try {
      await LecturerService.approveTask(taskId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã phê duyệt Task thành công')),
      );
      _loadDetail(); // Reload list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  Future<void> _handleRequestChanges(String taskId) async {
    try {
      await LecturerService.requestChanges(taskId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi yêu cầu sửa đổi cho sinh viên')),
      );
      _loadDetail();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  void _showReviewDialog(LecturerTask task) {
    final commentController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review Task',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    Text(
                      task.description!,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  TextField(
                    controller: commentController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Nhập nhận xét của bạn...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                      filled: true,
                      fillColor: AppColors.bgCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isSubmitting ? null : () async {
                            setModalState(() => isSubmitting = true);
                            if (commentController.text.isNotEmpty) {
                              await LecturerService.addComment(task.id, commentController.text);
                            }
                            Navigator.pop(context);
                            _handleRequestChanges(task.id);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error),
                            foregroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Yêu cầu sửa'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : () async {
                            setModalState(() => isSubmitting = true);
                            if (commentController.text.isNotEmpty) {
                              await LecturerService.addComment(task.id, commentController.text);
                            }
                            Navigator.pop(context);
                            _handleApprove(task.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Phê duyệt (Pass)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        title: Text(
          widget.projectName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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

    if (_error != null || _detail == null) {
      return Center(
        child: Text(
          _error ?? 'Lỗi không xác định',
          style: const TextStyle(color: AppColors.error),
        ),
      );
    }

    final reviewTasks = _detail!.tasks.where((t) => t.status == 'ready-for-review').toList();
    
    return RefreshIndicator(
      onRefresh: _loadDetail,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBubble('${_detail!.progress}%', 'Tiến độ', AppColors.primary),
              _buildStatBubble('${_detail!.memberCount}', 'Thành viên', Colors.blue),
              _buildStatBubble('${reviewTasks.length}', 'Cần duyệt', reviewTasks.isNotEmpty ? AppColors.warning : AppColors.success),
            ],
          ),
          
          const SizedBox(height: 32),
          const Text(
            'Tasks Cần Duyệt',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          if (reviewTasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Tuyệt vời! Không có task nào đang chờ duyệt.',
                  style: TextStyle(color: AppColors.success),
                ),
              ),
            )
          else
            ...reviewTasks.map((task) => _buildTaskItem(task)),
        ],
      ),
    );
  }

  Widget _buildStatBubble(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(LecturerTask task) {
    return Card(
      color: AppColors.bgCard,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          task.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (task.assigneeName != null)
              Text(
                '👤 ${task.assigneeName}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
            const SizedBox(height: 4),
            Text(
              'Deadline: ${task.endDate}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _showReviewDialog(task),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Review', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

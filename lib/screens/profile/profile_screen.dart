import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../api/skill_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> _skills = [];
  bool _isLoadingSkills = true;

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    try {
      final skills = await SkillService.getSkills();
      if (mounted) {
        setState(() {
          _skills = skills;
          _isLoadingSkills = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingSkills = false);
      }
    }
  }

  void _showEditSkillsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: _EditSkillsSheet(
          initialSkills: _skills,
          onSaved: (newSkills) async {
            setState(() => _isLoadingSkills = true);
            try {
              await SkillService.updateSkills(newSkills);
              if (mounted) {
                setState(() {
                  _skills = newSkills;
                  _isLoadingSkills = false;
                });
              }
            } catch (e) {
              if (mounted) {
                setState(() => _isLoadingSkills = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không thể cập nhật kỹ năng')),
                );
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Header
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hồ sơ',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Avatar
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    user?.initials ?? '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                user?.name ?? 'User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (user?.role ?? 'member').toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Skills Section
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kỹ năng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: _showEditSkillsDialog,
                      child: const Text('Chỉnh sửa'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (_isLoadingSkills)
                const CircularProgressIndicator()
              else if (_skills.isEmpty)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chưa có kỹ năng nào. Bấm Chỉnh sửa để thêm.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skills.map((skill) => Chip(
                      label: Text(skill, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      side: BorderSide.none,
                      labelStyle: const TextStyle(color: AppColors.primary),
                    )).toList(),
                  ),
                ),
              
              const SizedBox(height: 32),

              // Menu items
              _buildMenuItem(
                icon: Icons.person_outline,
                label: 'Chỉnh sửa hồ sơ',
                onTap: () {}, // Not implemented yet per user choice
              ),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                label: 'Cài đặt thông báo',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.palette_outlined,
                label: 'Giao diện',
                onTap: () {},
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bgInput,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Dark',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ),
              _buildMenuItem(
                icon: Icons.language_outlined,
                label: 'Ngôn ngữ',
                onTap: () {},
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bgInput,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Tiếng Việt',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                label: 'Về Vertex',
                onTap: () {},
              ),

              const SizedBox(height: 16),

              // Logout
              _buildMenuItem(
                icon: Icons.logout,
                label: 'Đăng xuất',
                color: AppColors.error,
                onTap: () => _showLogoutDialog(context),
              ),

              const SizedBox(height: 32),

              // Version
              const Text(
                'Vertex Mobile v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDisabled,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    Widget? trailing,
  }) {
    final itemColor = color ?? AppColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: itemColor.withValues(alpha: 0.7)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: itemColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ?trailing,
            if (trailing == null)
              const Icon(Icons.chevron_right,
                  size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text('Đăng xuất',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Bạn có chắc muốn đăng xuất?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}

class _EditSkillsSheet extends StatefulWidget {
  final List<String> initialSkills;
  final Function(List<String>) onSaved;

  const _EditSkillsSheet({required this.initialSkills, required this.onSaved});

  @override
  State<_EditSkillsSheet> createState() => _EditSkillsSheetState();
}

class _EditSkillsSheetState extends State<_EditSkillsSheet> {
  late List<String> _currentSkills;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentSkills = List.from(widget.initialSkills);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addSkill(String skill) {
    final s = skill.trim();
    if (s.isNotEmpty && !_currentSkills.contains(s)) {
      setState(() {
        _currentSkills.add(s);
        _controller.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _currentSkills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chỉnh sửa Kỹ năng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Nhập tên kỹ năng (VD: Flutter) và nhấn Xong',
              hintStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.bgInput,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add, color: AppColors.primary),
                onPressed: () => _addSkill(_controller.text),
              ),
            ),
            onSubmitted: _addSkill,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _currentSkills.map((skill) => Chip(
              label: Text(skill, style: const TextStyle(fontSize: 13)),
              backgroundColor: AppColors.bgInput,
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => _removeSkill(skill),
              side: BorderSide.none,
            )).toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              widget.onSaved(_currentSkills);
              Navigator.pop(context);
            },
            child: const Text('Lưu thay đổi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

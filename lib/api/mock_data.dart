import '../models/user.dart';
import '../models/project.dart';
import '../models/organization.dart';
import '../models/notification.dart';

/// Mock data cho local development
/// Khi chuyển sang server thật, chỉ cần set ApiConfig.useMockData = false
class MockData {
  // ── Users ──
  static final User currentUser = User(
    id: 'u1',
    name: 'Nguyễn Văn An',
    email: 'an.nguyen@fpt.edu.vn',
    avatarUrl: null,
    role: 'member',
  );

  static final List<ProjectMember> members = [
    ProjectMember(
      id: 'pm1',
      userId: 'u1',
      name: 'Nguyễn Văn An',
      email: 'an.nguyen@fpt.edu.vn',
      role: 'Leader',
    ),
    ProjectMember(
      id: 'pm2',
      userId: 'u2',
      name: 'Trần Thị Bình',
      email: 'binh.tran@fpt.edu.vn',
      role: 'Member',
    ),
    ProjectMember(
      id: 'pm3',
      userId: 'u3',
      name: 'Lê Minh Châu',
      email: 'chau.le@fpt.edu.vn',
      role: 'Member',
    ),
    ProjectMember(
      id: 'pm4',
      userId: 'u4',
      name: 'Phạm Đức Dũng',
      email: 'dung.pham@fpt.edu.vn',
      role: 'Member',
    ),
  ];

  // ── Organizations ──
  static final List<OrgSummary> organizations = [
    OrgSummary(
      id: 'org1',
      name: 'SE1856-NET',
      slug: 'se1856-net',
      plan: 'free',
      memberCount: 25,
      maxMembers: 30,
      createdAt: '2026-06-01T00:00:00Z',
    ),
    OrgSummary(
      id: 'org2',
      name: 'SWP391-Team5',
      slug: 'swp391-team5',
      plan: 'pro',
      memberCount: 5,
      maxMembers: 10,
      createdAt: '2026-05-15T00:00:00Z',
    ),
  ];

  // ── Projects ──
  static final List<ProjectSummary> projects = [
    ProjectSummary(
      id: 'p1',
      name: 'Vertex Platform',
      description: 'Hệ thống quản lý dự án cho sinh viên FPT',
      deadline: '2026-08-15T00:00:00Z',
      taskCount: 12,
      memberCount: 4,
      progress: 65,
      createdAt: '2026-06-01T00:00:00Z',
    ),
    ProjectSummary(
      id: 'p2',
      name: 'E-Commerce App',
      description: 'Ứng dụng bán hàng trực tuyến',
      deadline: '2026-09-01T00:00:00Z',
      taskCount: 8,
      memberCount: 3,
      progress: 30,
      createdAt: '2026-06-15T00:00:00Z',
    ),
    ProjectSummary(
      id: 'p3',
      name: 'IoT Dashboard',
      description: 'Dashboard giám sát thiết bị IoT',
      deadline: '2026-07-30T00:00:00Z',
      taskCount: 15,
      memberCount: 5,
      progress: 85,
      createdAt: '2026-05-01T00:00:00Z',
    ),
  ];

  // ── Tasks ──
  static final List<Task> tasks = [
    Task(
      id: 't1',
      title: 'Thiết kế database schema',
      description: 'Thiết kế các bảng cho PostgreSQL, bao gồm Users, Projects, Tasks, Organizations',
      status: 'done',
      priority: 'high',
      assignee: members[0],
      startDate: '2026-06-01T00:00:00Z',
      endDate: '2026-06-10T00:00:00Z',
      createdAt: '2026-06-01T00:00:00Z',
      subtasks: [
        Subtask(id: 'st1', taskId: 't1', title: 'Tạo ERD diagram', isCompleted: true),
        Subtask(id: 'st2', taskId: 't1', title: 'Viết migration scripts', isCompleted: true),
      ],
      commentCount: 3,
    ),
    Task(
      id: 't2',
      title: 'Implement Auth API',
      description: 'Xây dựng API Login, Register, Refresh Token với JWT',
      status: 'done',
      priority: 'high',
      assignee: members[0],
      startDate: '2026-06-10T00:00:00Z',
      endDate: '2026-06-15T00:00:00Z',
      createdAt: '2026-06-10T00:00:00Z',
      commentCount: 2,
    ),
    Task(
      id: 't3',
      title: 'Xây dựng UI Dashboard',
      description: 'Giao diện trang Dashboard chính với tổng quan dự án',
      status: 'in-progress',
      priority: 'high',
      assignee: members[1],
      startDate: '2026-06-15T00:00:00Z',
      endDate: '2026-07-01T00:00:00Z',
      createdAt: '2026-06-15T00:00:00Z',
      subtasks: [
        Subtask(id: 'st3', taskId: 't3', title: 'Header & sidebar', isCompleted: true),
        Subtask(id: 'st4', taskId: 't3', title: 'Statistics cards', isCompleted: true),
        Subtask(id: 'st5', taskId: 't3', title: 'Project list widget', isCompleted: false),
      ],
      commentCount: 5,
    ),
    Task(
      id: 't4',
      title: 'Kanban Board',
      description: 'Implement drag & drop Kanban Board cho quản lý tasks',
      status: 'in-progress',
      priority: 'medium',
      assignee: members[2],
      startDate: '2026-06-20T00:00:00Z',
      endDate: '2026-07-05T00:00:00Z',
      createdAt: '2026-06-20T00:00:00Z',
      commentCount: 1,
    ),
    Task(
      id: 't5',
      title: 'Push Notification',
      description: 'Tích hợp Firebase Cloud Messaging cho push notification',
      status: 'todo',
      priority: 'medium',
      assignee: members[3],
      startDate: '2026-07-01T00:00:00Z',
      endDate: '2026-07-15T00:00:00Z',
      createdAt: '2026-07-01T00:00:00Z',
      commentCount: 0,
    ),
    Task(
      id: 't6',
      title: 'Tích hợp AI Chat',
      description: 'Kết nối Google Gemini API để hỗ trợ AI trong dự án',
      status: 'todo',
      priority: 'low',
      assignee: null,
      startDate: '2026-07-10T00:00:00Z',
      endDate: '2026-07-25T00:00:00Z',
      createdAt: '2026-07-10T00:00:00Z',
      commentCount: 0,
    ),
    Task(
      id: 't7',
      title: 'API Documentation',
      description: 'Viết tài liệu API sử dụng Swagger',
      status: 'ready-for-review',
      priority: 'medium',
      assignee: members[0],
      startDate: '2026-06-25T00:00:00Z',
      endDate: '2026-07-05T00:00:00Z',
      createdAt: '2026-06-25T00:00:00Z',
      commentCount: 4,
    ),
    Task(
      id: 't8',
      title: 'Unit Tests',
      description: 'Viết unit tests cho service layer',
      status: 'ready-for-review',
      priority: 'low',
      assignee: members[1],
      startDate: '2026-07-01T00:00:00Z',
      endDate: '2026-07-10T00:00:00Z',
      createdAt: '2026-07-01T00:00:00Z',
      commentCount: 2,
    ),
  ];

  // ── Project Detail ──
  static ProjectDetail get projectDetail => ProjectDetail(
        id: 'p1',
        name: 'Vertex Platform',
        description: 'Hệ thống quản lý dự án cho sinh viên FPT',
        deadline: '2026-08-15T00:00:00Z',
        progress: 65,
        createdAt: '2026-06-01T00:00:00Z',
        tasks: tasks,
        members: members,
      );

  // ── Comments ──
  static final List<TaskComment> comments = [
    TaskComment(
      id: 'c1',
      taskId: 't3',
      userId: 'u1',
      userName: 'Nguyễn Văn An',
      content: 'Mình đã hoàn thành phần header, các bạn review giúp nhé!',
      createdAt: '2026-06-20T10:30:00Z',
    ),
    TaskComment(
      id: 'c2',
      taskId: 't3',
      userId: 'u2',
      userName: 'Trần Thị Bình',
      content: 'Looks good! Nhưng nên thêm responsive cho mobile.',
      createdAt: '2026-06-20T14:15:00Z',
    ),
    TaskComment(
      id: 'c3',
      taskId: 't3',
      userId: 'u3',
      userName: 'Lê Minh Châu',
      content: 'Đồng ý với Bình. Mình sẽ hỗ trợ phần sidebar.',
      createdAt: '2026-06-21T09:00:00Z',
    ),
  ];

  // ── Notifications ──
  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      type: 'info',
      message: 'Trần Thị Bình đã hoàn thành task "Header & sidebar"',
      isRead: false,
      createdAt: '2026-07-14T08:30:00Z',
    ),
    AppNotification(
      id: 'n2',
      type: 'warning',
      message: 'Task "Kanban Board" sắp hết hạn (còn 2 ngày)',
      isRead: false,
      createdAt: '2026-07-14T07:00:00Z',
    ),
    AppNotification(
      id: 'n3',
      type: 'info',
      message: 'Lê Minh Châu đã comment trong task "Xây dựng UI Dashboard"',
      isRead: false,
      createdAt: '2026-07-13T16:45:00Z',
    ),
    AppNotification(
      id: 'n4',
      type: 'invite',
      message: 'Bạn được mời vào tổ chức "AI Research Lab"',
      isRead: true,
      createdAt: '2026-07-12T10:00:00Z',
    ),
    AppNotification(
      id: 'n5',
      type: 'info',
      message: 'Task "Thiết kế database schema" đã được đánh dấu hoàn thành',
      isRead: true,
      createdAt: '2026-07-11T14:20:00Z',
    ),
    AppNotification(
      id: 'n6',
      type: 'error',
      message: 'Deadline dự án "IoT Dashboard" đã quá hạn 3 ngày',
      isRead: true,
      createdAt: '2026-07-10T09:00:00Z',
    ),
  ];

  // ── Auth tokens ──
  static AuthTokens get mockTokens => AuthTokens(
        accessToken: 'mock-access-token-12345',
        refreshToken: 'mock-refresh-token-12345',
        accessTokenExpiresAt: '2026-12-31T23:59:59Z',
        refreshTokenExpiresAt: '2026-12-31T23:59:59Z',
      );
}

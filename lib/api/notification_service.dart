import '../models/notification.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'mock_data.dart';

/// Notification service
class NotificationService {
  static Future<List<AppNotification>> getNotifications() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.notifications;
    }

    final response =
        await ApiClient.request('GET', '/api/lecturer/notifications');
    return ApiClient.parseResponse(
      response,
      (json) =>
          (json as List).map((j) => AppNotification.fromJson(j)).toList(),
    );
  }

  static Future<void> markAsRead(String notificationId) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      return;
    }

    await ApiClient.request(
      'PUT',
      '/api/lecturer/notifications/$notificationId/read',
    );
  }

  static Future<void> markAllAsRead() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      return;
    }

    await ApiClient.request(
      'PUT',
      '/api/lecturer/notifications/read-all',
    );
  }
}

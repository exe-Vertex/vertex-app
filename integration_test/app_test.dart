import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vertex_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E App Flow Test', () {
    testWidgets('Login -> Home -> Project Detail -> Task Detail flow', (WidgetTester tester) async {
      app.main();
      
      // Wait for splash screen to finish
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // --- 1. LOGIN SCREEN ---
      // Verify we are on login screen
      expect(find.text('Đăng nhập'), findsWidgets);
      
      // Find TextFields (Email and Password)
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      
      await tester.enterText(emailField, 'test@test.com');
      await tester.enterText(passwordField, '123456');
      await tester.pump();
      
      // Tap login button
      final loginBtn = find.text('Đăng nhập').last; // Last one is inside the button
      await tester.tap(loginBtn);
      
      // Wait for login API (mock) and navigation
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // --- 2. HOME SCREEN ---
      // We should be on Home now
      expect(find.text('Tasks của bạn'), findsOneWidget);
      expect(find.text('Dự án'), findsOneWidget);
      
      // Find the first project card ("Vertex Platform")
      final projectCard = find.text('Vertex Platform').first;
      expect(projectCard, findsOneWidget);
      
      // Tap on the project to go to Project Detail
      await tester.tap(projectCard);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // --- 3. PROJECT DETAIL SCREEN ---
      expect(find.text('Tiến độ'), findsOneWidget);
      
      // Find the first task card in the list
      final taskCard = find.text('Thiết kế database schema').first;
      expect(taskCard, findsOneWidget);
      
      // Tap the task to go to Task Detail
      await tester.tap(taskCard);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // --- 4. TASK DETAIL SCREEN ---
      expect(find.text('Chi tiết Task'), findsOneWidget);
      expect(find.text('Assignee'), findsOneWidget);
      
      // Write a comment
      final commentField = find.byType(TextField).first;
      await tester.enterText(commentField, 'Test comment từ Integration Test!');
      await tester.pump();
      
      // Tap send button (Icon.send)
      final sendBtn = find.byIcon(Icons.send);
      await tester.tap(sendBtn);
      
      // Wait for mock API
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Verify comment appears
      expect(find.text('Test comment từ Integration Test!'), findsOneWidget);
      
      // --- 5. GO BACK TO HOME ---
      // Pop task detail
      final backBtn = find.byIcon(Icons.arrow_back_ios);
      await tester.tap(backBtn);
      await tester.pumpAndSettle();
      
      // Pop project detail
      await tester.tap(backBtn);
      await tester.pumpAndSettle();
      
      // Verify back on home
      expect(find.text('Tasks của bạn'), findsOneWidget);
    });
  });
}

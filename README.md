# Vertex App 🚀

Vertex is an AI-powered project management workspace designed for students, creatives, and dynamic teams. Built with **Flutter** for cross-platform performance and integrated with a robust C# .NET Backend, Vertex helps you plan, track, and execute your projects effortlessly.

## 🌟 Key Features

- **Workspaces & Projects**: Organize your tasks logically into multiple workspaces and dedicated projects.
- **Kanban Board**: Drag-and-drop or seamlessly change status (Todo, In Progress, Done) for tasks.
- **Deep Task Details**: Break down complex work with **Subtasks** and collaborate via **Comments**.
- **Team Collaboration**: Manage project members in real-time.
- **Vertex AI Assistant**: A built-in AI chatbot connected to Gemini that understands your workspace context and helps generate project plans and subtasks.
- **Secure Authentication**: JWT-based login with Refresh Token support and automated session management.
- **Optimistic UI & UX**: Silky smooth interactions with instant visual feedback, auto-login, and typing indicators.

## 📱 Screenshots
*(Add your app screenshots here)*

## 🛠 Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Provider (ChangeNotifier, MultiProvider, ProxyProvider)
- **Navigation**: go_router
- **Network**: http (REST API)
- **Local Storage**: shared_preferences

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/exe-Vertex/vertex-app.git
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure API Endpoint:**
   - Open `lib/core/network/api_config.dart`
   - Set the `baseUrl` to match your local or production backend.
     - For Android Emulator: `http://10.0.2.2:5000/api`
     - For Physical Device: `http://<your-ipv4>:5000/api`
4. **Run the app:**
   ```bash
   flutter run
   ```

## 🔒 Build for Production
This app is fully configured for release builds. Note that Android requires the `INTERNET` permission and cleartext configuration if connecting to non-HTTPS endpoints.
```bash
flutter build apk --release
```

---
*Developed by the Vertex Team.*

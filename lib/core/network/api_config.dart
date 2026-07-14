class ApiConfig {
  // If running on an Android Emulator and the backend is on the host machine (localhost),
  // use 10.0.2.2 instead of localhost or 127.0.0.1.
  // Example for .NET standard ports: 5000 (HTTP) or 7110/7000 (HTTPS)
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // If using physical device, replace with your PC's IP address (e.g., http://192.168.1.10:5000/api)
}

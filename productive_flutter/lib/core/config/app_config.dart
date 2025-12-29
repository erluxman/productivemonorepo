/// Application configuration service
/// Following cursor rules: No hardcoded URLs - use configuration/constants

class AppConfig {
  // Base URL for API - should be loaded from environment/config
  // For now, keeping the same URL but in a configurable location
  static const String baseUrl =
      "https://29ded1690a77.ngrok-free.app/productive-78c0e/us-central1/api";

  // API endpoints
  static String get todosEndpoint => '$baseUrl/todos';

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);

  // Other config values can be added here
  // In production, these should be loaded from environment variables
  // or Firebase Remote Config
}

class ApiConstants {
  // Private constructor to prevent instantiation.
  ApiConstants._();

  // Base URL for the backend API. Update this to match your actual server URL.
  static const String baseUrl = 'https://api.cochat.click';

  // Example endpoint paths (optional, add as needed).
  static const String reportEndpoint = '/apis/v2/safety/report';
  static const String blockEndpoint = '/apis/v2/safety/block';
}

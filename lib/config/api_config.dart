class ApiConfig {
  // Base URL for API endpoints
  static const String baseUrl = "https://api.registerevent.com"; 
  
  static const String bearerToken = "your_auth_token";
  
  // API timeout duration in seconds
  static const int timeoutDuration = 15;
  
  // Endpoint paths
  static const String registerEndpoint = "/submit";

  
  // Response keys
  static const String successKey = "success";
  static const String messageKey = "message";
  static const String dataKey = "data";
  static const String errorKey = "error";
}
 class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.distritomallos.com';
  static const String apiVersion = '/v1';
  
  // App Information
  static const String appName = 'Distrito Mallos';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String isFirstTimeKey = 'is_first_time';
  
  // Default Values
  static const int defaultPointsValue = 100;
  static const String defaultCurrency = 'EUR';
  
  // Validation
  static const int minPasswordLength = 6;
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // Colors (en caso de que no uses el theme)
  static const String primaryColorHex = '#2E7D32';
  static const String secondaryColorHex = '#4CAF50';
  static const String accentColorHex = '#FF9800';
}

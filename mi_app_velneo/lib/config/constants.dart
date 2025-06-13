// lib/config/constants.dart - SOLO CONSTANTES
class AppConstants {
  // ✅ API Configuration - NUEVA URL DE API REAL
  static const String baseUrl = 'https://distritomallos.consultoraprincipado.com';
  static const String apiPath = '/api/vERP_2_dat_dat/v1';
  static const String apiKey = 'api123Berges29';
  
  // ✅ API Endpoints
  static const String newsEndpoint = '/news';
  static const String merchantsEndpoint = '/merchants'; // Para futuro uso
  static const String promotionsEndpoint = '/promotions'; // Para futuro uso
  static const String restaurantsEndpoint = '/restaurants'; // Para futuro uso
  
  // ✅ Complete API URLs
  static String get newsApiUrl => '$baseUrl$apiPath$newsEndpoint?api_key=$apiKey';
  static String get merchantsApiUrl => '$baseUrl$apiPath$merchantsEndpoint?api_key=$apiKey';
  static String get promotionsApiUrl => '$baseUrl$apiPath$promotionsEndpoint?api_key=$apiKey';
  static String get restaurantsApiUrl => '$baseUrl$apiPath$restaurantsEndpoint?api_key=$apiKey';
  
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
  
  // Network Configuration
  static const int connectionTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos
  
  // Validation
  static const int minPasswordLength = 6;
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // Colors (en caso de que no uses el theme)
  static const String primaryColorHex = '#2E7D32';
  static const String secondaryColorHex = '#4CAF50';
  static const String accentColorHex = '#FF9800';
  
  // Error Messages
  static const String networkErrorMessage = 'Error de conexión. Verifica tu internet.';
  static const String serverErrorMessage = 'Error del servidor. Inténtalo más tarde.';
  static const String unknownErrorMessage = 'Error desconocido. Inténtalo más tarde.';
}
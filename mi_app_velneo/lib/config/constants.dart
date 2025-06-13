// lib/config/constants.dart - COMPLETO CORREGIDO
class AppConstants {
  // ✅ API Configuration - URL REAL CORREGIDA
  static const String baseUrl = 'https://distritomallos.consultoraprincipado.com';
  static const String apiPath = '/api/vERP_2_dat_dat/v1';
  static const String apiKey = 'api123Berges29';
  
  // ✅ API Endpoints REALES - CORREGIDOS
  static const String sociosEndpoint = '/soc'; // ✅ Endpoint real de socios
  static const String categoriasEndpoint = '/cat_soc'; // Endpoint de categorías
  static const String newsEndpoint = '/news'; // Para futuro uso
  static const String merchantsEndpoint = '/merchants'; // Para futuro uso
  static const String promotionsEndpoint = '/promotions'; // Para futuro uso
  
  // ✅ Complete API URLs - ACTUALIZADAS Y CORREGIDAS
  static String get sociosApiUrl => '$baseUrl$apiPath$sociosEndpoint?api_key=$apiKey&limit=500';
  static String get categoriasApiUrl => '$baseUrl$apiPath$categoriasEndpoint?&api_key=$apiKey';
  static String get newsApiUrl => '$baseUrl$apiPath$newsEndpoint?api_key=$apiKey';
  static String get merchantsApiUrl => '$baseUrl$apiPath$merchantsEndpoint?api_key=$apiKey';
  static String get promotionsApiUrl => '$baseUrl$apiPath$promotionsEndpoint?api_key=$apiKey';
  
  // ✅ ALIAS para compatibilidad - los restaurantes vienen del endpoint de socios
  static String get restaurantsApiUrl => sociosApiUrl;
  
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
  
  // ✅ CONSTANTES PARA RESTAURANTES - ACTUALIZADAS
  static const int restaurantCategoryId = 1; // cat_soc = 1 para "A nosa hostalería"
  static const int defaultPromotionPoints = 5;
  
  // ✅ NUEVAS CONSTANTES PARA VALIDACIÓN DE DATOS
  static const List<String> validImageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
  static const int maxImageCacheSize = 100; // MB
  static const int maxNetworkTimeout = 30; // segundos
  
  // Network Configuration
  static const int connectionTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos
  
  // Validation
  static const int minPasswordLength = 6;
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // ✅ PATRONES DE VALIDACIÓN PARA LA API
  static const String phonePattern = r'^[+]?[0-9\s\-\(\)]{9,}$';
  static const String urlPattern = r'^https?://[^\s/$.?#].[^\s]*$';
  
  // Colors (en caso de que no uses el theme)
  static const String primaryColorHex = '#2E7D32';
  static const String secondaryColorHex = '#4CAF50';
  static const String accentColorHex = '#FF9800';
  
  // ✅ MENSAJES DE ERROR ESPECÍFICOS
  static const String networkErrorMessage = 'Sin conexión a internet. Verifica tu conexión.';
  static const String serverErrorMessage = 'Error del servidor. Inténtalo más tarde.';
  static const String unknownErrorMessage = 'Error desconocido. Inténtalo más tarde.';
  static const String noDataErrorMessage = 'No se encontraron datos.';
  static const String apiErrorMessage = 'Error en la API. Contacta al soporte.';
  
  // ✅ MENSAJES ESPECÍFICOS PARA RESTAURANTES
  static const String noRestaurantsMessage = 'No se encontraron restaurantes.';
  static const String loadingRestaurantsMessage = 'Cargando restaurantes...';
  static const String searchRestaurantsHint = 'Buscar restaurantes...';
  
  // ✅ CONFIGURACIÓN DE CACHÉ
  static const Duration cacheExpiration = Duration(minutes: 30);
  static const int maxCacheEntries = 50;
  
  // ✅ CONFIGURACIÓN DE LA UI
  static const double defaultCardElevation = 2.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  
  // ✅ LÍMITES DE TEXTO
  static const int maxDescriptionLines = 2;
  static const int maxNameLines = 2;
  static const int maxAddressLines = 1;
  
  // ✅ CONFIGURACIÓN DE MAPAS
  static const double defaultMapZoom = 15.0;
  static const String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=';
  
  // ✅ CONFIGURACIÓN DE REDES SOCIALES
  static const String instagramBaseUrl = 'https://instagram.com/';
  static const String facebookBaseUrl = 'https://facebook.com/';
  static const String whatsappBaseUrl = 'https://wa.me/';
  
  // ✅ MÉTODO HELPER PARA VALIDAR URLs DE IMÁGENES
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) return false;
      
      final path = uri.path.toLowerCase();
      return validImageExtensions.any((ext) => path.endsWith(ext));
    } catch (e) {
      return false;
    }
  }
  
  // ✅ MÉTODO HELPER PARA VALIDAR TELÉFONOS
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return RegExp(phonePattern).hasMatch(phone);
  }
  
  // ✅ MÉTODO HELPER PARA VALIDAR EMAILS
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return RegExp(emailPattern).hasMatch(email);
  }
  
  // ✅ MÉTODO HELPER PARA VALIDAR URLs
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return RegExp(urlPattern).hasMatch(url);
  }
  
  // ✅ MÉTODO PARA LIMPIAR NÚMEROS DE TELÉFONO
  static String cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }
}
// lib/services/news_service.dart - CONECTADO A API REAL CON CACHE
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/api_service.dart';
import 'package:mi_app_velneo/config/constants.dart';

class NewsService {
  // ✅ CACHE PARA OPTIMIZAR VELOCIDAD
  static List<NewsModel>? _cachedNews;
  static DateTime? _lastCacheTime;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  /// ✅ OPTIMIZADO: Obtener solo noticias de HOME (port: true)
  static Future<List<NewsModel>> getHomeNews() async {
    try {
      print('🏠 Cargando noticias para HOME (port=true)...');
      
      // ✅ Verificar cache primero
      if (_cachedNews != null && _lastCacheTime != null) {
        final cacheAge = DateTime.now().difference(_lastCacheTime!);
        if (cacheAge < _cacheExpiration) {
          print('📦 Usando cache (edad: ${cacheAge.inSeconds}s)');
          final homeNews = _cachedNews!.where((item) => item.isHighlighted).toList();
          print('🏠 ${homeNews.length} noticias HOME desde cache');
          return homeNews;
        }
      }

      // ✅ Si no hay cache válido, llamar a API
      final response = await ApiService.get(AppConstants.newsApiUrl);
      
      List<NewsModel> newsList = [];
      
      // Tu API devuelve: {"count": 714, "total_count": 714, "news": [...]}
      if (response['news'] is List) {
        final List<dynamic> dataList = response['news'] as List<dynamic>;
        newsList = dataList
            .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
            .where((news) => news.isActive) // Solo noticias activas
            .toList();
      } else {
        print('⚠️ Formato de respuesta no reconocido');
        return _getMockNews().where((news) => news.isHighlighted).toList();
      }
      
      // ✅ Guardar en cache
      _cachedNews = newsList;
      _lastCacheTime = DateTime.now();
      
      // ✅ Filtrar solo las de HOME (port: true)
      final homeNews = newsList.where((item) => item.isHighlighted).toList();
      
      // Ordenar por fecha (más recientes primero)
      homeNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      
      print('🏠 ${homeNews.length} noticias HOME cargadas desde API');
      return homeNews;
      
    } on ApiException catch (e) {
      print('❌ Error de API: ${e.message}');
      // Fallback a mock
      return _getMockNews().where((news) => news.isHighlighted).toList();
    } catch (e) {
      print('❌ Error general: $e');
      // Fallback a mock
      return _getMockNews().where((news) => news.isHighlighted).toList();
    }
  }

  /// Obtener todas las noticias desde la API (usa cache si está disponible)
  static Future<List<NewsModel>> getAllNews() async {
    try {
      print('🔄 Cargando todas las noticias...');
      
      // ✅ Verificar cache primero
      if (_cachedNews != null && _lastCacheTime != null) {
        final cacheAge = DateTime.now().difference(_lastCacheTime!);
        if (cacheAge < _cacheExpiration) {
          print('📦 Usando cache para todas las noticias');
          return _cachedNews!;
        }
      }
      
      // ✅ Si no hay cache válido, llamar a API
      final response = await ApiService.get(AppConstants.newsApiUrl);
      
      print('✅ Respuesta recibida: ${response.keys}');
      
      List<NewsModel> newsList = [];
      
      // Tu API devuelve: {"count": 714, "total_count": 714, "news": [...]}
      if (response['news'] is List) {
        final List<dynamic> dataList = response['news'] as List<dynamic>;
        newsList = dataList
            .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
            .where((news) => news.isActive) // Solo noticias activas
            .toList();
      } else {
        print('⚠️ Formato de respuesta no reconocido');
        print('📄 Estructura recibida: ${response.keys}');
        return _getMockNews();
      }
      
      // ✅ Guardar en cache
      _cachedNews = newsList;
      _lastCacheTime = DateTime.now();
      
      // Ordenar por fecha de publicación (más recientes primero)
      newsList.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      
      print('📰 ${newsList.length} noticias cargadas desde API');
      return newsList;
      
    } on ApiException catch (e) {
      print('❌ Error de API: ${e.message}');
      
      // Si hay error de conexión, usar datos mock como fallback
      if (e.statusCode == 0) {
        print('🔄 Sin conexión, usando datos mock');
        return _getMockNews();
      }
      
      rethrow; // Re-lanzar otros errores de API
      
    } catch (e) {
      print('❌ Error general en NewsService: $e');
      
      // En caso de cualquier error, usar datos mock
      print('🔄 Error desconocido, usando datos mock');
      return _getMockNews();
    }
  }

  /// Obtener noticia por ID desde la API
  static Future<NewsModel?> getNewsById(String id) async {
    try {
      print('🔍 Buscando noticia con ID: $id');
      
      // Primero intentar obtener todas las noticias y filtrar
      final allNews = await getAllNews();
      
      try {
        final news = allNews.firstWhere((item) => item.id == id);
        print('✅ Noticia encontrada: ${news.title}');
        return news;
      } catch (e) {
        print('⚠️ Noticia con ID $id no encontrada');
        return null;
      }
      
    } catch (e) {
      print('❌ Error al buscar noticia: $e');
      return null;
    }
  }

  /// Obtener noticias destacadas (alias para getHomeNews)
  static Future<List<NewsModel>> getFeaturedNews() async {
    return getHomeNews(); // Redirigir al método de HOME
  }

  /// Obtener noticias por categoría
  static Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      print('📂 Cargando noticias de categoría: $category');
      
      final allNews = await getAllNews();
      final filteredNews = allNews
          .where((item) => 
              item.category != null && 
              item.category!.toLowerCase() == category.toLowerCase())
          .toList();
      
      print('📂 ${filteredNews.length} noticias de categoría $category');
      return filteredNews;
      
    } catch (e) {
      print('❌ Error al cargar noticias por categoría: $e');
      return [];
    }
  }

  /// Buscar noticias por texto
  static Future<List<NewsModel>> searchNews(String query) async {
    try {
      print('🔍 Buscando noticias con: "$query"');
      
      if (query.isEmpty) return getAllNews();
      
      final allNews = await getAllNews();
      final queryLower = query.toLowerCase();
      
      final searchResults = allNews.where((news) {
        return news.title.toLowerCase().contains(queryLower) ||
               news.content.toLowerCase().contains(queryLower) ||
               (news.category?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
      
      print('🔍 ${searchResults.length} noticias encontradas para "$query"');
      return searchResults;
      
    } catch (e) {
      print('❌ Error en búsqueda: $e');
      return [];
    }
  }

  /// Obtener noticias recientes (últimos 30 días)
  static Future<List<NewsModel>> getRecentNews() async {
    try {
      final allNews = await getAllNews();
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      
      final recentNews = allNews
          .where((news) => news.publishDate.isAfter(thirtyDaysAgo))
          .toList();
      
      print('📅 ${recentNews.length} noticias recientes (últimos 30 días)');
      return recentNews;
      
    } catch (e) {
      print('❌ Error al cargar noticias recientes: $e');
      return [];
    }
  }

  /// Verificar conectividad con la API
  static Future<bool> checkApiConnection() async {
    try {
      await ApiService.get(AppConstants.newsApiUrl);
      return true;
    } catch (e) {
      print('❌ API no disponible: $e');
      return false;
    }
  }

  /// Limpiar cache manualmente
  static void clearCache() {
    _cachedNews = null;
    _lastCacheTime = null;
    print('🗑️ Cache de noticias limpiado');
  }

  /// Datos mock como fallback (mantener los datos existentes)
  static List<NewsModel> _getMockNews() {
    return [
      NewsModel(
        id: '1',
        title: 'Pascua no meu barrio',
        content: '''
Esta Pascua celebramos en nuestro querido barrio con actividades especiales para toda la familia.

Disfruta de:
• Actividades para niños
• Conciertos al aire libre
• Mercadillo de artesanía local
• Gastronomía tradicional

¡Te esperamos para vivir juntos estas fiestas tan especiales!

Más información en nuestros comercios asociados.
        ''',
        imageUrl: "assets/images/naimallos_campaign.jpg",
        publishDate: DateTime(2025, 3, 28),
        category: 'Eventos',
        isHighlighted: true,
      ),
      NewsModel(
        id: '2',
        title: 'Campaña NaiMallos',
        content: '''
¡Nueva campaña promocional NaiMallos!

Durante todo el mes de abril, disfruta de promociones especiales en todos nuestros comercios asociados.

Beneficios de la campaña:
• Descuentos exclusivos
• Puntos dobles en tu tarjeta EU MALLOS
• Sorteos semanales
• Productos de temporada

No te pierdas esta oportunidad única de ahorrar mientras apoyas el comercio local.

¡Participa ya en la campaña NaiMallos!
        ''',
        imageUrl: "assets/images/naimallos_campaign.jpg",
        publishDate: DateTime(2025, 4, 25),
        category: 'Promociones',
        isHighlighted: false,
      ),
      NewsModel(
        id: '3',
        title: 'Nuevo comercio asociado',
        content: '''
Damos la bienvenida a un nuevo comercio a nuestra asociación.

La familia de Distrito Mallos sigue creciendo con nuevos establecimientos que se unen a nuestro proyecto de revitalización del barrio.

¡Bienvenidos!
        ''',
        imageUrl: null,
        publishDate: DateTime(2025, 4, 10),
        category: 'Asociación',
        isHighlighted: false,
      ),
    ];
  }
}
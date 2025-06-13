// lib/services/news_service.dart - OPTIMIZADO SIN REFERENCIAS A CATEGORÍAS
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/api_service.dart';
import 'package:mi_app_velneo/config/constants.dart';
import 'package:flutter/foundation.dart';

class NewsService {
  // ✅ CACHE PARA OPTIMIZAR VELOCIDAD
  static List<NewsModel>? _cachedNews;
  static DateTime? _lastCacheTime;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  // ✅ LOGGING HELPER
  static void _log(String message) {
    if (kDebugMode) {
      print('NewsService: $message');
    }
  }

  /// ✅ OPTIMIZADO: Obtener solo noticias de HOME (port: true) con datos mínimos
  static Future<List<NewsModel>> getHomeNews() async {
    try {
      _log('Cargando noticias para HOME (port=true)...');
      
      // ✅ Verificar cache primero
      if (_cachedNews != null && _lastCacheTime != null) {
        final cacheAge = DateTime.now().difference(_lastCacheTime!);
        if (cacheAge < _cacheExpiration) {
          _log('Usando cache (edad: ${cacheAge.inSeconds}s)');
          final homeNews = _cachedNews!.where((item) => item.isHighlighted).toList();
          
          // ✅ ORDENAR DE MÁS NUEVA A MÁS ANTIGUA
          homeNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
          
          _log('${homeNews.length} noticias HOME desde cache');
          return homeNews;
        }
      }

      // ✅ Si no hay cache válido, llamar a API
      final response = await ApiService.get(AppConstants.newsApiUrl);
      
      List<NewsModel> newsList = [];
      
      if (response['news'] is List) {
        final List<dynamic> dataList = response['news'] as List<dynamic>;
        newsList = dataList
            .map((item) => NewsModel.fromJsonMinimal(item as Map<String, dynamic>))
            .where((news) => 
                news.isActive && 
                news.categoryId == 0 &&
                news.isValidForDisplay // ✅ USAR VALIDADOR INTEGRADO
            )
            .toList();
      } else {
        _log('Formato de respuesta no reconocido');
        return _getMockNews().where((news) => news.isHighlighted).toList();
      }
      
      // ✅ Guardar en cache
      _cachedNews = newsList;
      _lastCacheTime = DateTime.now();
      
      // ✅ Filtrar solo las de HOME (port: true)
      final homeNews = newsList.where((item) => item.isHighlighted).toList();
      
      // ✅ ORDENAR DE MÁS NUEVA A MÁS ANTIGUA
      homeNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      
      _log('${homeNews.length} noticias HOME cargadas desde API');
      return homeNews;
      
    } on ApiException catch (e) {
      _log('Error de API: ${e.message}');
      // Fallback a mock
      final mockNews = _getMockNews().where((news) => news.isHighlighted).toList();
      mockNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      return mockNews;
    } catch (e) {
      _log('Error general: $e');
      // Fallback a mock
      final mockNews = _getMockNews().where((news) => news.isHighlighted).toList();
      mockNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      return mockNews;
    }
  }

  /// ✅ Obtener todas las noticias desde la API con datos mínimos (solo para listado)
  static Future<List<NewsModel>> getAllNews() async {
    try {
      _log('Cargando todas las noticias...');
      
      // ✅ Verificar cache primero
      if (_cachedNews != null && _lastCacheTime != null) {
        final cacheAge = DateTime.now().difference(_lastCacheTime!);
        if (cacheAge < _cacheExpiration) {
          _log('Usando cache para todas las noticias');
          final sortedNews = List<NewsModel>.from(_cachedNews!);
          
          // ✅ ORDENAR DE MÁS NUEVA A MÁS ANTIGUA
          sortedNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
          
          return sortedNews;
        }
      }
      
      // ✅ Si no hay cache válido, llamar a API
      final response = await ApiService.get(AppConstants.newsApiUrl);
      
      _log('Respuesta recibida: ${response.keys}');
      
      List<NewsModel> newsList = [];
      
      if (response['news'] is List) {
        final List<dynamic> dataList = response['news'] as List<dynamic>;
        newsList = dataList
            .map((item) => NewsModel.fromJsonMinimal(item as Map<String, dynamic>))
            .where((news) => 
                news.isActive && 
                news.categoryId == 0 &&
                news.isValidForDisplay // ✅ USAR VALIDADOR INTEGRADO
            )
            .toList();
      } else {
        _log('Formato de respuesta no reconocido');
        _log('Estructura recibida: ${response.keys}');
        return _getMockNews();
      }
      
      // ✅ Guardar en cache
      _cachedNews = newsList;
      _lastCacheTime = DateTime.now();
      
      // ✅ ORDENAR DE MÁS NUEVA A MÁS ANTIGUA
      newsList.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      
      _log('${newsList.length} noticias cargadas desde API');
      return newsList;
      
    } on ApiException catch (e) {
      _log('Error de API: ${e.message}');
      
      if (e.statusCode == 0) {
        _log('Sin conexión, usando datos mock');
        final mockNews = _getMockNews();
        mockNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
        return mockNews;
      }
      
      rethrow;
      
    } catch (e) {
      _log('Error general en NewsService: $e');
      
      _log('Error desconocido, usando datos mock');
      final mockNews = _getMockNews();
      mockNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      return mockNews;
    }
  }

  /// ✅ Obtener noticia por ID con datos COMPLETOS (solo para detalle)
  static Future<NewsModel?> getNewsById(String id) async {
    try {
      _log('Buscando noticia con ID: $id');
      
      // ✅ Primero cargar todas las noticias (que incluyen todo el contenido)
      final response = await ApiService.get(AppConstants.newsApiUrl);
      
      if (response['news'] is List) {
        final List<dynamic> dataList = response['news'] as List<dynamic>;
        
        // ✅ Buscar la noticia específica por ID
        try {
          final newsData = dataList.firstWhere(
            (item) => item['id'].toString() == id &&
                      (item['name'] as String? ?? '').trim().isNotEmpty, // ✅ ASEGURAR QUE TIENE TÍTULO
          ) as Map<String, dynamic>;
          
          // ✅ Crear con datos completos
          final news = NewsModel.fromJsonComplete(newsData);
          _log('Noticia completa encontrada: ${news.title}');
          return news;
          
        } catch (e) {
          _log('Noticia con ID $id no encontrada en la lista');
          return null;
        }
      }
      
      _log('Formato de respuesta no reconocido para detalle');
      return null;
      
    } catch (e) {
      _log('Error al buscar noticia: $e');
      return null;
    }
  }

  /// Obtener noticias destacadas (alias para getHomeNews)
  static Future<List<NewsModel>> getFeaturedNews() async {
    return getHomeNews();
  }

  /// Obtener noticias por categoría
  static Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      _log('Cargando noticias de categoría: $category');
      
      final allNews = await getAllNews();
      final filteredNews = allNews
          .where((item) => 
              item.category != null && 
              item.category!.toLowerCase() == category.toLowerCase())
          .toList();
      
      // ✅ Ya están ordenadas por getAllNews()
      
      _log('${filteredNews.length} noticias de categoría $category');
      return filteredNews;
      
    } catch (e) {
      _log('Error al cargar noticias por categoría: $e');
      return [];
    }
  }

  /// Buscar noticias por texto
  static Future<List<NewsModel>> searchNews(String query) async {
    try {
      _log('Buscando noticias con: "$query"');
      
      if (query.isEmpty) return getAllNews();
      
      final allNews = await getAllNews();
      final queryLower = query.toLowerCase();
      
      final searchResults = allNews.where((news) {
        return news.title.toLowerCase().contains(queryLower) ||
               (news.category?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
      
      // ✅ Ya están ordenadas por getAllNews()
      
      _log('${searchResults.length} noticias encontradas para "$query"');
      return searchResults;
      
    } catch (e) {
      _log('Error en búsqueda: $e');
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
      
      // ✅ Ya están ordenadas por getAllNews()
      
      _log('${recentNews.length} noticias recientes (últimos 30 días)');
      return recentNews;
      
    } catch (e) {
      _log('Error al cargar noticias recientes: $e');
      return [];
    }
  }

  /// Verificar conectividad con la API
  static Future<bool> checkApiConnection() async {
    try {
      await ApiService.get(AppConstants.newsApiUrl);
      return true;
    } catch (e) {
      _log('API no disponible: $e');
      return false;
    }
  }

  /// ✅ Limpiar cache manualmente
  static void clearCache() {
    _cachedNews = null;
    _lastCacheTime = null;
    _log('Cache de noticias limpiado');
  }

  /// ✅ Datos mock como fallback (solo categoría 0)
  static List<NewsModel> _getMockNews() {
    return [
      NewsModel(
        id: '1',
        title: 'Pascua no meu barrio',
        content: 'Contenido completo de la noticia...', // Solo se usa en detalle
        imageUrl: "assets/images/naimallos_campaign.jpg",
        publishDate: DateTime(2025, 3, 28),
        category: 'General',
        categoryId: 0, // ✅ CATEGORÍA 0
        isHighlighted: true,
      ),
      NewsModel(
        id: '2',
        title: 'Campaña NaiMallos',
        content: 'Contenido completo de la campaña...', // Solo se usa en detalle
        imageUrl: "assets/images/naimallos_campaign.jpg",
        publishDate: DateTime(2025, 4, 25),
        category: 'General',
        categoryId: 0, // ✅ CATEGORÍA 0
        isHighlighted: false,
      ),
      NewsModel(
        id: '3',
        title: 'Nuevo comercio asociado',
        content: 'Contenido completo del nuevo comercio...', // Solo se usa en detalle
        imageUrl: null,
        publishDate: DateTime(2025, 4, 10),
        category: 'General',
        categoryId: 0, // ✅ CATEGORÍA 0
        isHighlighted: false,
      ),
    ];
  }
}
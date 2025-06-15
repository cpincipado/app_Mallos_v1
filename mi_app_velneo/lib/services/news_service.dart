// lib/services/news_service.dart - DETAIL ULTRA OPTIMIZADO

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/api_service.dart';
import 'package:mi_app_velneo/config/constants.dart';

class NewsService {
  // ✅ CACHE MEMORIA Y DISCO
  static final Map<String, CacheItem> _memoryCache = {};
  static SharedPreferences? _prefs;

  // ✅ TTL OPTIMIZADOS
  static const Duration _cacheExpiration = Duration(hours: 1);
  static const Duration _detailCacheExpiration = Duration(hours: 4);
  static const Duration _homeCacheExpiration = Duration(minutes: 30);

  // ✅ CACHE KEYS
  static const String _homeNewsKey = 'home_news_cache';
  static const String _allNewsKey = 'all_news_cache';
  static const String _fullNewsKey = 'full_news_cache'; // ✅ NUEVO
  static const String _newsDetailPrefix = 'news_detail_';

  /// ✅ LOGGING CONDICIONAL
  static void _log(String message) {
    if (kDebugMode) {
      print('NewsService: $message');
    }
  }

  /// ✅ INICIALIZAR CACHE
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    _log('Cache inicializado');
  }

  /// ✅ OPTIMIZADO: getHomeNews (MANTENER IGUAL)
  static Future<List<NewsModel>> getHomeNews() async {
    const cacheKey = _homeNewsKey;

    try {
      // 1. MEMORIA CACHE
      final memoryCached = _getFromMemoryCache(cacheKey);
      if (memoryCached != null) {
        _log('✅ Home news desde MEMORIA (${memoryCached.length} items)');
        return memoryCached;
      }

      // 2. DISCO CACHE
      final diskCached = await _getFromDiskCache(
        cacheKey,
        _homeCacheExpiration,
      );
      if (diskCached != null && diskCached.isNotEmpty) {
        _saveToMemoryCache(cacheKey, diskCached, _homeCacheExpiration);
        _log('✅ Home news desde DISCO (${diskCached.length} items)');
        return diskCached;
      }

      // 3. API
      _log('📡 Cargando home news desde API...');
      final response = await ApiService.get(AppConstants.newsApiUrl);

      List<NewsModel> newsList = [];

      if (response['news'] is List) {
        final List<dynamic> dataList = response['news'] as List<dynamic>;
        newsList = dataList
            .map(
              (item) => NewsModel.fromJsonMinimal(item as Map<String, dynamic>),
            )
            .where(
              (news) =>
                  news.isActive &&
                  news.categoryId == 0 &&
                  news.isValidForDisplay &&
                  news.isHighlighted,
            )
            .toList();
      } else {
        _log('Formato de respuesta API no reconocido');
        return _getMockNews().where((news) => news.isHighlighted).toList();
      }

      newsList.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      _saveToMemoryCache(cacheKey, newsList, _homeCacheExpiration);
      await _saveToDiskCache(cacheKey, newsList);

      _log('✅ ${newsList.length} home news cargadas desde API');
      return newsList;
    } on ApiException catch (e) {
      _log('Error de API: ${e.message}');
      final expiredCache = await _getExpiredFromDiskCache(cacheKey);
      if (expiredCache != null && expiredCache.isNotEmpty) {
        _log('⚠️ Usando cache expirado como fallback');
        return expiredCache;
      }

      final mockNews = _getMockNews()
          .where((news) => news.isHighlighted)
          .toList();
      mockNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      return mockNews;
    } catch (e) {
      _log('Error general: $e');
      final mockNews = _getMockNews()
          .where((news) => news.isHighlighted)
          .toList();
      mockNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      return mockNews;
    }
  }

  /// ✅ OPTIMIZADO: getAllNews (MANTENER IGUAL)
  static Future<List<NewsModel>> getAllNews() async {
    const cacheKey = _allNewsKey;

    try {
      // 1. MEMORIA CACHE
      final memoryCached = _getFromMemoryCache(cacheKey);
      if (memoryCached != null) {
        _log('✅ All news desde MEMORIA (${memoryCached.length} items)');
        return memoryCached;
      }

      // 2. DISCO CACHE
      final diskCached = await _getFromDiskCache(cacheKey, _cacheExpiration);
      if (diskCached != null && diskCached.isNotEmpty) {
        _saveToMemoryCache(cacheKey, diskCached, _cacheExpiration);
        _log('✅ All news desde DISCO (${diskCached.length} items)');
        return diskCached;
      }

      // 3. API
      _log('📡 Cargando todas las noticias desde API...');
      final response = await ApiService.get(AppConstants.newsApiUrl);

      List<NewsModel> newsList = [];

      if (response['news'] is List) {
        final List<dynamic> dataList = response['news'] as List<dynamic>;
        newsList = dataList
            .map(
              (item) => NewsModel.fromJsonMinimal(item as Map<String, dynamic>),
            )
            .where(
              (news) =>
                  news.isActive &&
                  news.categoryId == 0 &&
                  news.isValidForDisplay,
            )
            .toList();
      } else {
        _log('Formato de respuesta no reconocido');
        return _getMockNews();
      }

      newsList.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      _saveToMemoryCache(cacheKey, newsList, _cacheExpiration);
      await _saveToDiskCache(cacheKey, newsList);

      _log('✅ ${newsList.length} noticias cargadas desde API');
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
      final mockNews = _getMockNews();
      mockNews.sort((a, b) => b.publishDate.compareTo(a.publishDate));
      return mockNews;
    }
  }

  /// ✅ ULTRA OPTIMIZADO: getNewsById - AHORA USA CACHE INTELIGENTE
  static Future<NewsModel?> getNewsById(String id) async {
    final cacheKey = '$_newsDetailPrefix$id';

    try {
      // 1. ✅ MEMORIA CACHE para detalles (ULTRA RÁPIDO)
      final memoryCachedList = _getFromMemoryCache(cacheKey);
      if (memoryCachedList != null && memoryCachedList.isNotEmpty) {
        _log('⚡ News detail desde MEMORIA - ID: $id');
        return memoryCachedList.first;
      }

      // 2. ✅ DISCO CACHE para detalles (RÁPIDO)
      final diskCachedList = await _getFromDiskCache(
        cacheKey,
        _detailCacheExpiration,
      );
      if (diskCachedList != null && diskCachedList.isNotEmpty) {
        _saveToMemoryCache(cacheKey, diskCachedList, _detailCacheExpiration);
        _log('⚡ News detail desde DISCO - ID: $id');
        return diskCachedList.first;
      }

      // 3. ✅ BUSCAR EN CACHE DE LISTA PRIMERO (SÚPER RÁPIDO)
      final allNewsCached = _getFromMemoryCache(_allNewsKey);
      if (allNewsCached != null) {
        final foundInList = allNewsCached.firstWhere(
          (news) => news.id == id,
          orElse: () => NewsModel(
            id: '',
            title: '',
            content: '',
            publishDate: DateTime.now(),
          ),
        );

        if (foundInList.id.isNotEmpty) {
          _log(
            '⚡ News encontrada en LISTA CACHE - intentando obtener contenido completo',
          );

          // Si tiene contenido completo, usarla directamente
          if (foundInList.hasFullContent) {
            _saveToMemoryCache(cacheKey, [foundInList], _detailCacheExpiration);
            await _saveToDiskCache(cacheKey, [foundInList]);
            _log('✅ News detail desde LISTA con contenido completo');
            return foundInList;
          }

          // Si no tiene contenido, buscar en cache completo
          final fullNewsCached = _getFromMemoryCache(_fullNewsKey);
          if (fullNewsCached != null) {
            final foundComplete = fullNewsCached.firstWhere(
              (news) => news.id == id,
              orElse: () => NewsModel(
                id: '',
                title: '',
                content: '',
                publishDate: DateTime.now(),
              ),
            );

            if (foundComplete.id.isNotEmpty) {
              _saveToMemoryCache(cacheKey, [
                foundComplete,
              ], _detailCacheExpiration);
              await _saveToDiskCache(cacheKey, [foundComplete]);
              _log('✅ News detail desde CACHE COMPLETO');
              return foundComplete;
            }
          }
        }
      }

      // 4. ✅ API COMPLETA solo si no está en cache (LENTO pero necesario)
      _log('📡 Cargando noticia completa desde API - ID: $id');
      final response = await ApiService.get(AppConstants.newsApiUrl);

      if (response['news'] is List) {
        final List<dynamic> dataList = response['news'] as List<dynamic>;

        // ✅ CACHEAR TODAS LAS NOTICIAS COMPLETAS para futuros accesos
        final allCompleteNews = dataList
            .map(
              (item) =>
                  NewsModel.fromJsonComplete(item as Map<String, dynamic>),
            )
            .where(
              (news) =>
                  news.isActive &&
                  news.categoryId == 0 &&
                  news.isValidForDisplay,
            )
            .toList();

        // ✅ GUARDAR CACHE COMPLETO
        _saveToMemoryCache(_fullNewsKey, allCompleteNews, _cacheExpiration);
        await _saveToDiskCache(_fullNewsKey, allCompleteNews);
        _log('💾 ${allCompleteNews.length} noticias completas cacheadas');

        // ✅ BUSCAR LA NOTICIA ESPECÍFICA
        try {
          final newsData =
              dataList.firstWhere(
                    (item) =>
                        item['id'].toString() == id &&
                        (item['name'] as String? ?? '').trim().isNotEmpty,
                  )
                  as Map<String, dynamic>;

          final news = NewsModel.fromJsonComplete(newsData);
          _saveToMemoryCache(cacheKey, [news], _detailCacheExpiration);
          await _saveToDiskCache(cacheKey, [news]);

          _log('✅ Noticia completa encontrada: ${news.title}');
          return news;
        } catch (e) {
          _log('❌ Noticia con ID $id no encontrada en la API');
          return null;
        }
      }

      _log('❌ Formato de respuesta no reconocido para detalle');
      return null;
    } catch (e) {
      _log('❌ Error al buscar noticia: $e');
      return null;
    }
  }

  // ✅ MANTENER MÉTODOS EXISTENTES IGUALES
  static Future<List<NewsModel>> getFeaturedNews() async {
    return getHomeNews();
  }

  static Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      _log('Cargando noticias de categoría: $category');
      final allNews = await getAllNews();
      final filteredNews = allNews
          .where(
            (item) =>
                item.category != null &&
                item.category!.toLowerCase() == category.toLowerCase(),
          )
          .toList();

      _log('${filteredNews.length} noticias de categoría $category');
      return filteredNews;
    } catch (e) {
      _log('Error al cargar noticias por categoría: $e');
      return [];
    }
  }

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

      _log('${searchResults.length} noticias encontradas para "$query"');
      return searchResults;
    } catch (e) {
      _log('Error en búsqueda: $e');
      return [];
    }
  }

  static Future<List<NewsModel>> getRecentNews() async {
    try {
      final allNews = await getAllNews();
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

      final recentNews = allNews
          .where((news) => news.publishDate.isAfter(thirtyDaysAgo))
          .toList();

      _log('${recentNews.length} noticias recientes (últimos 30 días)');
      return recentNews;
    } catch (e) {
      _log('Error al cargar noticias recientes: $e');
      return [];
    }
  }

  static Future<bool> checkApiConnection() async {
    try {
      await ApiService.get(AppConstants.newsApiUrl);
      return true;
    } catch (e) {
      _log('API no disponible: $e');
      return false;
    }
  }

  static void clearCache() {
    _memoryCache.clear();
    _log('Cache de noticias limpiado');
  }

  static Future<void> clearAllCache() async {
    clearCache();
    await _prefs?.clear();
    _log('🧹 Todo el cache limpiado (memoria + disco)');
  }

  // ✅ MÉTODOS PRIVADOS DE CACHE (MANTENER IGUALES)
  static List<NewsModel>? _getFromMemoryCache(String key) {
    final item = _memoryCache[key];
    if (item != null && !item.isExpired) {
      return item.data as List<NewsModel>;
    }
    if (item != null && item.isExpired) {
      _memoryCache.remove(key);
    }
    return null;
  }

  static void _saveToMemoryCache(
    String key,
    List<NewsModel> data,
    Duration ttl,
  ) {
    _memoryCache[key] = CacheItem(
      data: data,
      createdAt: DateTime.now(),
      ttl: ttl,
    );
  }

  static Future<List<NewsModel>?> _getFromDiskCache(
    String key,
    Duration ttl,
  ) async {
    if (_prefs == null) {
      await initialize();
    }

    final jsonData = _prefs!.getString(key);
    final timestampStr = _prefs!.getString('${key}_timestamp');

    if (jsonData != null && timestampStr != null) {
      final timestamp = DateTime.parse(timestampStr);
      final age = DateTime.now().difference(timestamp);

      if (age <= ttl) {
        try {
          final List<dynamic> dataList = jsonDecode(jsonData) as List<dynamic>;
          return dataList
              .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } catch (e) {
          _log('Error parseando cache de disco: $e');
          await _prefs!.remove(key);
          await _prefs!.remove('${key}_timestamp');
        }
      } else {
        await _prefs!.remove(key);
        await _prefs!.remove('${key}_timestamp');
      }
    }

    return null;
  }

  static Future<List<NewsModel>?> _getExpiredFromDiskCache(String key) async {
    if (_prefs == null) return null;

    final jsonData = _prefs!.getString(key);
    if (jsonData != null) {
      try {
        final List<dynamic> dataList = jsonDecode(jsonData) as List<dynamic>;
        return dataList
            .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        _log('Error parseando cache expirado: $e');
      }
    }
    return null;
  }

  static Future<void> _saveToDiskCache(String key, List<NewsModel> data) async {
    if (_prefs == null) return;

    try {
      final jsonData = jsonEncode(data.map((n) => n.toJson()).toList());
      await _prefs!.setString(key, jsonData);
      await _prefs!.setString(
        '${key}_timestamp',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      _log('Error guardando en cache de disco: $e');
    }
  }

  // ✅ MOCK NEWS (MANTENER IGUAL)
  static List<NewsModel> _getMockNews() {
    return [
      NewsModel(
        id: '1',
        title: 'Pascua no meu barrio',
        content: 'Contenido completo de la noticia...',
        imageUrl: "assets/images/naimallos_campaign.jpg",
        publishDate: DateTime(2025, 3, 28),
        category: 'General',
        categoryId: 0,
        isHighlighted: true,
      ),
      NewsModel(
        id: '2',
        title: 'Campaña NaiMallos',
        content: 'Contenido completo de la campaña...',
        imageUrl: "assets/images/naimallos_campaign.jpg",
        publishDate: DateTime(2025, 4, 25),
        category: 'General',
        categoryId: 0,
        isHighlighted: false,
      ),
      NewsModel(
        id: '3',
        title: 'Nuevo comercio asociado',
        content: 'Contenido completo del nuevo comercio...',
        imageUrl: null,
        publishDate: DateTime(2025, 4, 10),
        category: 'General',
        categoryId: 0,
        isHighlighted: false,
      ),
    ];
  }
}

/// ✅ CLASE AUXILIAR PARA CACHE ITEMS (MANTENER IGUAL)
class CacheItem {
  final dynamic data;
  final DateTime createdAt;
  final Duration ttl;

  const CacheItem({
    required this.data,
    required this.createdAt,
    required this.ttl,
  });

  bool get isExpired => DateTime.now().difference(createdAt) > ttl;
}

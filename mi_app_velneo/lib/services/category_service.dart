// lib/services/category_service.dart - SERVICIO SEPARADO PARA CATEGORÍAS
import 'package:mi_app_velneo/services/api_service.dart';
import 'package:mi_app_velneo/config/constants.dart';
import 'package:flutter/foundation.dart';

class CategoryService {
  // ✅ CACHE PARA CATEGORÍAS
  static Map<int, String>? _cachedCategories;
  static DateTime? _lastCacheTime;
  static const Duration _cacheExpiration = Duration(hours: 1);

  /// ✅ LOGGING HELPER
  static void _log(String message) {
    if (kDebugMode) {
      print('CategoryService: $message');
    }
  }

  /// ✅ CARGAR CATEGORÍAS DESDE LA API
  static Future<Map<int, String>> _loadCategories() async {
    try {
      // ✅ Verificar cache de categorías
      if (_cachedCategories != null && _lastCacheTime != null) {
        final cacheAge = DateTime.now().difference(_lastCacheTime!);
        if (cacheAge < _cacheExpiration) {
          _log('Usando cache de categorías');
          return _cachedCategories!;
        }
      }

      _log('Cargando categorías desde API...');
      
      // ✅ Llamar al endpoint de categorías de tu API
      final response = await ApiService.get('${AppConstants.baseUrl}/cat');
      
      Map<int, String> categories = {};
      
      if (response['cat'] is List) {
        final List<dynamic> catList = response['cat'] as List<dynamic>;
        for (var cat in catList) {
          if (cat is Map<String, dynamic>) {
            final id = cat['id'] as int?;
            final name = cat['name'] as String?;
            if (id != null && name != null && name.isNotEmpty) {
              categories[id] = name;
            }
          }
        }
      }
      
      // ✅ Guardar en cache
      _cachedCategories = categories;
      _lastCacheTime = DateTime.now();
      
      _log('${categories.length} categorías cargadas');
      return categories;
      
    } catch (e) {
      _log('Error cargando categorías: $e');
      
      // ✅ Fallback a categorías básicas basadas en tu JSON
      return _getFallbackCategories();
    }
  }

  /// ✅ OBTENER NOMBRE DE CATEGORÍA POR ID
  static Future<String?> getCategoryName(int? catId) async {
    if (catId == null) return null;
    
    final categories = await _loadCategories();
    return categories[catId];
  }

  /// ✅ OBTENER TODAS LAS CATEGORÍAS
  static Future<Map<int, String>> getAllCategories() async {
    return await _loadCategories();
  }

  /// ✅ VERIFICAR SI UNA CATEGORÍA EXISTE
  static Future<bool> categoryExists(int catId) async {
    final categories = await _loadCategories();
    return categories.containsKey(catId);
  }

  /// ✅ BUSCAR CATEGORÍAS POR NOMBRE
  static Future<List<MapEntry<int, String>>> searchCategories(String query) async {
    if (query.isEmpty) return [];
    
    final categories = await _loadCategories();
    final queryLower = query.toLowerCase();
    
    return categories.entries
        .where((entry) => entry.value.toLowerCase().contains(queryLower))
        .toList();
  }

  /// ✅ LIMPIAR CACHE DE CATEGORÍAS
  static void clearCache() {
    _cachedCategories = null;
    _lastCacheTime = null;
    _log('Cache de categorías limpiado');
  }

  /// ✅ CATEGORÍAS FALLBACK BASADAS EN TU JSON REAL
  static Map<int, String> _getFallbackCategories() {
    return {
      0: 'GENERAL', // ✅ CATEGORÍA POR DEFECTO
      1: 'GENERAL',
      2: 'TRANSPORTE',
      3: 'DOCUMENTOS',
      4: 'COMERCIAL',
      5: 'Abejas',
      6: 'Cursos',
      7: 'Miel',
      8: 'Deportes',
      10: 'General',
      11: 'Negocios',
      13: 'Formación',
      14: 'eNotice',
      15: 'General',
      16: 'Actividad asociados',
      17: 'COVID-19',
      18: 'INVERSIÓN GOBIERNO DE CANTABRIA',
      19: 'SECTOR',
      20: 'FORMACIÓN',
      21: 'CONTRATACIÓN PÚBLICA',
      22: 'Económia y Finanzas',
      23: 'LABORAL',
      24: 'PANDEMIA',
      25: 'TRANSPORTE DE MERCANCÍAS',
      26: 'JURÍDICAS Y LEGISLATIVAS',
      27: 'PREVENCIÓN DE RIESGOS',
      28: 'OBRAS',
      29: 'SOFTWARE',
      30: 'PREVENCIÓN DE RIESGOS LABORALES',
      31: 'Cursos',
      32: 'AYUDAS O SUBVENCIONES',
      33: 'CONVENIOS',
      34: 'Asociación',
      35: 'Formación',
      38: 'Anuncios',
      39: 'Noticias',
      45: 'Alimentación',
      46: 'Bares y Restaurantes',
      47: 'Belleza',
      48: 'Moda y Complementos',
      49: 'Salud',
      50: 'Bricolaje y Hogar',
    };
  }

  /// ✅ OBTENER CATEGORÍAS MÁS USADAS (las principales)
  static Future<List<MapEntry<int, String>>> getMainCategories() async {
    final categories = await _loadCategories();
    
    // IDs de las categorías principales que vi en tu JSON
    final mainCategoryIds = [1, 34, 35, 38, 39, 45, 46, 47, 48, 49, 50];
    
    return categories.entries
        .where((entry) => mainCategoryIds.contains(entry.key))
        .toList();
  }
}
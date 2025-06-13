// lib/services/restaurant_service.dart - COMPLETO PARA API REAL
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mi_app_velneo/models/restaurant_model.dart';
import 'package:mi_app_velneo/config/constants.dart';

class RestaurantService {
  static const int _connectionTimeout = 30;

  /// ✅ Obtener todos los restaurantes desde la API real
  static Future<List<RestaurantModel>> getAllRestaurants() async {
    try {
      print('🔄 Cargando restaurantes desde: ${AppConstants.sociosApiUrl}');
      
      final response = await http.get(
        Uri.parse(AppConstants.sociosApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: _connectionTimeout));

      print('📡 Status Code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('📦 Respuesta recibida: ${responseData.runtimeType}');
        
        List<dynamic> jsonList;
        
        // ✅ Manejar el formato específico de la API que devuelve {"soc": [...]}
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('soc')) {
            jsonList = responseData['soc'] ?? [];
            print('📊 Total de registros en soc: ${jsonList.length}');
          } else if (responseData.containsKey('data')) {
            jsonList = responseData['data'] ?? [];
          } else if (responseData.containsKey('results')) {
            jsonList = responseData['results'] ?? [];
          } else {
            jsonList = [responseData];
          }
        } else if (responseData is List) {
          jsonList = responseData;
        } else {
          throw Exception('Formato de respuesta no válido');
        }

        print('📊 Total de elementos recibidos: ${jsonList.length}');
        
        // ✅ DEBUGGING: Ver todas las categorías disponibles
        final categories = jsonList.map((json) => json['cat_soc']).toSet();
        print('🏷️ Categorías encontradas: $categories');
        
        // ✅ DEBUGGING: Contar elementos por categoría
        final categoryCount = <dynamic, int>{};
        for (final item in jsonList) {
          final cat = item['cat_soc'];
          categoryCount[cat] = (categoryCount[cat] ?? 0) + 1;
        }
        print('📊 Elementos por categoría: $categoryCount');
        
        // ✅ DEBUGGING: Mostrar algunos ejemplos de categoría 1
        final category1Items = jsonList.where((json) {
          final category = json['cat_soc'];
          return category == 1 || category == '1';
        }).take(3).toList();
        
        print('🍽️ Ejemplos de cat_soc=1:');
        for (int i = 0; i < category1Items.length; i++) {
          final item = category1Items[i];
          print('   ${i + 1}. ${item['name']} - ${item['dir']} - cat_soc: ${item['cat_soc']}');
        }

        // ✅ Filtrar solo categoría 1 (restaurantes) y convertir
        final restaurants = jsonList
            .where((json) {
              final category = json['cat_soc'];
              return category == 1 || category == '1';
            })
            .map((json) {
              try {
                return RestaurantModel.fromApiJson(json as Map<String, dynamic>);
              } catch (e) {
                print('⚠️ Error procesando restaurante: $e');
                print('📄 Datos: ${json['name']} - ID: ${json['id']}');
                return null;
              }
            })
            .where((restaurant) => restaurant != null)
            .cast<RestaurantModel>()
            .toList();

        print('🍽️ Restaurantes filtrados (categoría 1): ${restaurants.length}');
        
        // ✅ Ordenar por nombre
        restaurants.sort((a, b) => a.name.compareTo(b.name));
        
        return restaurants;
        
      } else {
        throw HttpException(
          'Error del servidor: ${response.statusCode}\n${response.body}',
          uri: Uri.parse(AppConstants.sociosApiUrl),
        );
      }
    } on SocketException {
      throw Exception('Sin conexión a internet. Verifica tu conexión.');
    } on http.ClientException {
      throw Exception('Error de conexión con el servidor.');
    } on FormatException catch (e) {
      throw Exception('Error en el formato de datos: $e');
    } catch (e) {
      print('❌ Error en getAllRestaurants: $e');
      throw Exception('Error al cargar restaurantes: $e');
    }
  }

  /// ✅ Buscar restaurantes por nombre o dirección
  static Future<List<RestaurantModel>> searchRestaurants(String query) async {
    if (query.isEmpty) {
      return await getAllRestaurants();
    }

    try {
      final allRestaurants = await getAllRestaurants();
      final lowerQuery = query.toLowerCase();
      
      return allRestaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(lowerQuery) ||
               restaurant.address.toLowerCase().contains(lowerQuery) ||
               (restaurant.city?.toLowerCase().contains(lowerQuery) ?? false) ||
               (restaurant.description?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
      
    } catch (e) {
      print('❌ Error en searchRestaurants: $e');
      throw Exception('Error al buscar restaurantes: $e');
    }
  }

  /// ✅ Obtener restaurante por ID
  static Future<RestaurantModel?> getRestaurantById(String id) async {
    try {
      final allRestaurants = await getAllRestaurants();
      return allRestaurants.where((r) => r.id == id).firstOrNull;
    } catch (e) {
      print('❌ Error en getRestaurantById: $e');
      return null;
    }
  }

  /// ✅ Verificar conectividad con la API
  static Future<bool> checkApiConnectivity() async {
    try {
      final response = await http.head(
        Uri.parse(AppConstants.sociosApiUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200 || response.statusCode == 405;
    } catch (e) {
      print('❌ Error de conectividad: $e');
      return false;
    }
  }

  /// ✅ Obtener estadísticas de restaurantes
  static Future<Map<String, int>> getRestaurantStats() async {
    try {
      final restaurants = await getAllRestaurants();
      
      return {
        'total': restaurants.length,
        'with_images': restaurants.where((r) => r.imageUrl != null).length,
        'with_phone': restaurants.where((r) => r.primaryPhone != null).length,
        'with_website': restaurants.where((r) => r.website != null).length,
        'with_social': restaurants.where((r) => r.hasSocialMedia).length,
        'with_location': restaurants.where((r) => r.hasLocation).length,
        'active': restaurants.where((r) => r.isActive).length,
      };
    } catch (e) {
      print('❌ Error en getRestaurantStats: $e');
      return {};
    }
  }

  /// ✅ Obtener todas las categorías disponibles (para debugging)
  static Future<Map<int, String>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.categoriasApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: _connectionTimeout));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        List<dynamic> jsonList;
        if (responseData is Map<String, dynamic>) {
          jsonList = responseData['cat_soc'] ?? responseData['data'] ?? [];
        } else if (responseData is List) {
          jsonList = responseData;
        } else {
          return {};
        }

        final categories = <int, String>{};
        for (final item in jsonList) {
          final id = item['id'];
          final name = item['name'];
          if (id != null && name != null) {
            categories[id] = name;
          }
        }
        
        return categories;
      }
      
      return {};
    } catch (e) {
      print('❌ Error obteniendo categorías: $e');
      return {};
    }
  }
}
// lib/services/restaurant_api_service.dart - NUEVO ARCHIVO COMPLETO
import 'package:mi_app_velneo/models/restaurant_model.dart';
import 'package:mi_app_velneo/services/api_service.dart';
import 'package:mi_app_velneo/config/constants.dart';

class RestaurantApiService {
  /// ✅ Obtener todos los restaurantes (cat_soc = 1 = "A nosa hostalaria")
  static Future<List<RestaurantModel>> getAllRestaurants() async {
    try {
      final response = await ApiService.get(AppConstants.sociosApiUrl);
      
      if (response['soc'] != null) {
        final List<dynamic> sociosData = response['soc'];
        
        // Filtrar solo los restaurantes (cat_soc = 1 = "A nosa hostalaria")
        final restaurantData = sociosData
            .where((socio) => socio['cat_soc'] == AppConstants.restaurantCategoryId)
            .toList();
        
        return restaurantData
            .map((json) => RestaurantModel.fromApiJson(json))
            .toList();
      }
      
      return [];
    } on ApiException catch (e) {
      throw Exception('Error API: ${e.message}');
    } catch (e) {
      throw Exception('Error al cargar restaurantes: $e');
    }
  }

  /// ✅ Obtener restaurante por ID
  static Future<RestaurantModel?> getRestaurantById(String id) async {
    try {
      final restaurants = await getAllRestaurants();
      return restaurants.where((r) => r.id == id).firstOrNull;
    } catch (e) {
      return null;
    }
  }

  /// ✅ Buscar restaurantes por texto
  static Future<List<RestaurantModel>> searchRestaurants(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllRestaurants();
      }

      final restaurants = await getAllRestaurants();
      final queryLower = query.toLowerCase();

      return restaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(queryLower) ||
            restaurant.address.toLowerCase().contains(queryLower) ||
            (restaurant.description?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
    } catch (e) {
      throw Exception('Error en búsqueda: $e');
    }
  }

  /// ✅ Obtener restaurantes con promociones
  static Future<List<RestaurantModel>> getRestaurantsWithPromotions() async {
    try {
      final restaurants = await getAllRestaurants();
      return restaurants.where((restaurant) => restaurant.hasPromotion).toList();
    } catch (e) {
      throw Exception('Error al cargar promociones: $e');
    }
  }

  /// ✅ Obtener categorías de socios (opcional, para referencia)
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await ApiService.get(AppConstants.categoriasApiUrl);
      
      if (response['cat_soc'] != null) {
        return List<Map<String, dynamic>>.from(response['cat_soc']);
      }
      
      return [];
    } on ApiException catch (e) {
      throw Exception('Error API: ${e.message}');
    } catch (e) {
      throw Exception('Error al cargar categorías: $e');
    }
  }
}
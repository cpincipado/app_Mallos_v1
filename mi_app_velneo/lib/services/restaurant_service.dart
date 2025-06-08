// lib/services/restaurant_service.dart
import 'package:mi_app_velneo/models/restaurant_model.dart';

class RestaurantService {
  // Datos mock basados en las imágenes proporcionadas
  static List<RestaurantModel> getMockRestaurants() {
    return [
      const RestaurantModel(
        id: '1',
        name: 'Cafetería Delvy',
        address: 'Ángel Senra, 16',
        description:
            'En plena ría peonil ofrece un espacio agradable con ampla terraza na que gozar de comida caseira.',
        imageUrl: 'assets/images/cafeteria_delvy.jpg',
        phone: '981567890',
        instagram: 'cafeteria_delvy',
        facebook: 'CafeteriaDelvy',
        latitude: 43.3645,
        longitude: -8.4110,
        schedule: RestaurantSchedule(
          monday: '9:00-24:00',
          tuesday: '9:00-14:00',
          wednesday: '9:00-14:00',
          thursday: '9:00-14:00',
          friday: '9:00-14:00',
          saturday: '10:00-14:00',
          sunday: '10:00-24:00',
        ),
        promotion: RestaurantPromotion(
          title: 'Desconto especial',
          description: '5 PUNTOS = 10% de desconto en consumicións',
          pointsRequired: 5,
          discountPercentage: '10%',
        ),
      ),
      const RestaurantModel(
        id: '2',
        name: 'A Pulpeira de Lola',
        address: 'Ronda de Outeiro, 135',
        description:
            'Polbo galego, mexillóns e pratos de queixo nunha taberna acolledora.\n-Carmen-',
        imageUrl: 'assets/images/pulpeira_lola.jpg',
        phone: '981678901',
        instagram: 'pulpeira_lola',
        facebook: 'PulpeiraLola',
        website: 'https://pulpeiralola.com',
        latitude: 43.3625,
        longitude: -8.4090,
        schedule: RestaurantSchedule(
          monday: '12:00-16:00',
          tuesday: '12:00-16:00, 19:00-23:00',
          wednesday: '12:00-16:00, 19:00-23:00',
          thursday: '12:00-16:00, 19:00-23:00',
          friday: '12:00-16:00, 19:00-23:00',
          saturday: '12:00-16:00, 19:00-23:00',
          sunday: '12:00-16:00, 19:00-23:00',
        ),
        promotion: RestaurantPromotion(
          title: 'Ración gratis',
          description: '8 PUNTOS = 1 ración de polbo gratis',
          pointsRequired: 8,
        ),
      ),
      const RestaurantModel(
        id: '3',
        name: 'Marisquería O Porto',
        address: 'Calle Arteixo, 52',
        description:
            'Marisco fresco diario e especialidades do mar. Ambiente familiar con vistas á ría.',
        imageUrl: 'assets/images/marisqueria_porto.jpg',
        phone: '981789012',
        facebook: 'MarisqueriaOPorto',
        whatsapp: '34981789012',
        latitude: 43.3630,
        longitude: -8.4120,
        schedule: RestaurantSchedule(
          monday: null, // Cerrado
          tuesday: '12:00-16:00, 20:00-23:30',
          wednesday: '12:00-16:00, 20:00-23:30',
          thursday: '12:00-16:00, 20:00-23:30',
          friday: '12:00-16:00, 20:00-24:00',
          saturday: '12:00-16:00, 20:00-24:00',
          sunday: '12:00-17:00',
        ),
      ),
      const RestaurantModel(
        id: '4',
        name: 'Taberna dos Mallos',
        address: 'Plaza de los Mallos, 8',
        description:
            'Cociña tradicional galega con produtos da terra. Raxións abundantes e precios populares.',
        phone: '981890123',
        instagram: 'taberna_mallos',
        latitude: 43.3635,
        longitude: -8.4100,
        schedule: RestaurantSchedule(
          monday: '11:00-16:00',
          tuesday: '11:00-16:00, 19:30-23:00',
          wednesday: '11:00-16:00, 19:30-23:00',
          thursday: '11:00-16:00, 19:30-23:00',
          friday: '11:00-16:00, 19:30-24:00',
          saturday: '11:00-17:00, 19:30-24:00',
          sunday: '11:00-17:00',
        ),
        promotion: RestaurantPromotion(
          title: 'Menú especial',
          description: '6 PUNTOS = Menú do día gratis',
          pointsRequired: 6,
        ),
      ),
      const RestaurantModel(
        id: '5',
        name: 'Pizzería Bella Napoli',
        address: 'Travesía Monforte, 12',
        description:
            'Pizzas artesanais ao forno de leña. Masa caseira e ingredientes importados de Italia.',
        phone: '981901234',
        website: 'https://bellanapoli-coruna.com',
        instagram: 'bella_napoli_coruna',
        latitude: 43.3620,
        longitude: -8.4085,
        schedule: RestaurantSchedule(
          monday: null, // Cerrado
          tuesday: '19:00-23:30',
          wednesday: '19:00-23:30',
          thursday: '19:00-23:30',
          friday: '19:00-24:00',
          saturday: '13:00-16:00, 19:00-24:00',
          sunday: '13:00-16:00, 19:00-23:30',
        ),
      ),
    ];
  }

  // Obtener todos los restaurantes
  static Future<List<RestaurantModel>> getAllRestaurants() async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockRestaurants();
  }

  // Obtener restaurante por ID
  static Future<RestaurantModel?> getRestaurantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final restaurants = getMockRestaurants();
    try {
      return restaurants.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Buscar restaurantes por texto (nombre, dirección, descripción)
  static Future<List<RestaurantModel>> searchRestaurants(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) {
      return getMockRestaurants();
    }

    final restaurants = getMockRestaurants();
    final queryLower = query.toLowerCase();

    return restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(queryLower) ||
          restaurant.address.toLowerCase().contains(queryLower) ||
          (restaurant.description?.toLowerCase().contains(queryLower) ?? false);
    }).toList();
  }

  // Obtener restaurantes abiertos ahora
  static Future<List<RestaurantModel>> getOpenRestaurants() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final restaurants = getMockRestaurants();
    final _ = DateTime.now();

    return restaurants.where((restaurant) {
      if (restaurant.schedule == null) return false;

      final todaySchedule = restaurant.schedule!.todaySchedule;
      return todaySchedule != 'Cerrado';
    }).toList();
  }

  // Obtener restaurantes con promociones
  static Future<List<RestaurantModel>> getRestaurantsWithPromotions() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final restaurants = getMockRestaurants();
    return restaurants.where((restaurant) => restaurant.hasPromotion).toList();
  }
}

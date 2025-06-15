// lib/models/restaurant_model.dart - CORREGIDO SIN LIMPIEZA HTML DUPLICADA
import 'package:flutter/foundation.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String address;
  final String? description;
  final String? imageUrl;
  final String? phone;
  final String? mobile;
  final String? email;
  final String? website;
  final String? instagram;
  final String? facebook;
  final String? whatsapp;
  final double? latitude;
  final double? longitude;
  final RestaurantSchedule? schedule;
  final RestaurantPromotion? promotion;
  final String? postalCode;
  final String? city;
  final int totalPoints;
  final bool isActive;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    this.description,
    this.imageUrl,
    this.phone,
    this.mobile,
    this.email,
    this.website,
    this.instagram,
    this.facebook,
    this.whatsapp,
    this.latitude,
    this.longitude,
    this.schedule,
    this.promotion,
    this.postalCode,
    this.city,
    this.totalPoints = 0,
    this.isActive = true,
  });

  /// ✅ LOGGING HELPER
  static void _log(String message) {
    if (kDebugMode) {
      debugPrint('RestaurantModel: $message');
    }
  }

  /// ✅ Constructor desde JSON de la API real - CORREGIDO SIN LIMPIEZA HTML
  factory RestaurantModel.fromApiJson(Map<String, dynamic> json) {
    // ✅ Parsear coordenadas - CORREGIDO
    double? lat, lng;
    if (json['lon_lat'] != null && json['lon_lat'].toString().isNotEmpty) {
      try {
        final coordsStr = json['lon_lat'].toString().trim();

        // Verificar si contiene comas (posibles coordenadas)
        if (coordsStr.contains(',')) {
          final coords = coordsStr.split(',');
          if (coords.length >= 2) {
            // Intentar parsear como números
            lat = double.tryParse(coords[0].trim());
            lng = double.tryParse(coords[1].trim());

            // Validar que estén en rangos válidos
            if (lat != null && lng != null) {
              if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
                lat = null;
                lng = null;
              }
            }
          }
        }
      } catch (e) {
        _log('Error parseando coordenadas para ${json['name']}: $e');
      }
    }

    // ✅ Construir dirección completa
    String fullAddress = json['dir']?.toString() ?? '';
    if (json['loc'] != null && json['loc'].toString().isNotEmpty) {
      fullAddress += fullAddress.isNotEmpty
          ? ', ${json['loc']}'
          : json['loc'].toString();
    }

    // ✅ CAMBIO CLAVE: NO LIMPIAR HTML - ALMACENAR RAW
    final rawDescription = json['obs']?.toString();
    final rawSchedule = json['obs1']?.toString();
    final rawPromotion = json['txt_tar']?.toString();

    // ✅ Crear horario desde obs1 RAW
    RestaurantSchedule? schedule;
    if (rawSchedule != null && rawSchedule.isNotEmpty) {
      schedule = RestaurantSchedule(
        summarySchedule: rawSchedule, // ✅ ALMACENAR RAW
        detailedSchedule: [rawSchedule], // ✅ ALMACENAR RAW
      );
    }

    // ✅ Crear promoción desde txt_tar RAW
    RestaurantPromotion? promotion;
    if (rawPromotion != null && rawPromotion.isNotEmpty) {
      promotion = RestaurantPromotion(
        title: 'Promoción EU MALLOS',
        description: 'Promoción disponible',
        terms: rawPromotion, // ✅ ALMACENAR RAW - SIN LIMPIAR
      );
    } else if (_parseInt(json['tot_pun']) > 0) {
      promotion = RestaurantPromotion(
        title: 'Puntos EU MALLOS',
        description: 'Tienes ${_parseInt(json['tot_pun'])} puntos acumulados',
        pointsRequired: 5,
      );
    }

    // ✅ Limpiar URLs de redes sociales (esto sí se puede limpiar)
    final cleanInstagram = _cleanSocialUrl(json['red_ins'], 'instagram');
    final cleanFacebook = _cleanSocialUrl(json['red_fac'], 'facebook');

    return RestaurantModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['nom_fis']?.toString() ?? '',
      address: fullAddress,
      description: rawDescription, // ✅ ALMACENAR RAW
      imageUrl: json['logo']?.toString(),
      phone: json['tlf']?.toString(),
      mobile: json['mov']?.toString(),
      email: json['eml']?.toString(),
      website: json['web']?.toString(),
      instagram: cleanInstagram,
      facebook: cleanFacebook,
      whatsapp: json['mov']?.toString(), // Usar móvil para WhatsApp
      latitude: lat,
      longitude: lng,
      postalCode: json['cps']?.toString(),
      city: json['loc']?.toString(),
      totalPoints: _parseInt(json['tot_pun']),
      isActive: !(json['off'] == true || json['off'] == 'true'),
      schedule: schedule,
      promotion: promotion,
    );
  }

  /// ✅ ELIMINAR MÉTODO _cleanHtmlText - YA NO SE NECESITA
  // La limpieza HTML ahora se hace en HtmlTextFormatter

  /// ✅ Limpiar URLs de redes sociales (esto SÍ se mantiene)
  static String? _cleanSocialUrl(dynamic url, String platform) {
    if (url == null) return null;

    String cleanUrl = url.toString().trim();
    if (cleanUrl.isEmpty) return null;

    // Si ya es una URL completa, extraer el username
    if (cleanUrl.startsWith('http')) {
      if (platform == 'instagram') {
        final match = RegExp(r'instagram\.com/([^/\?]+)').firstMatch(cleanUrl);
        return match?.group(1);
      } else if (platform == 'facebook') {
        final match = RegExp(r'facebook\.com/([^/\?]+)').firstMatch(cleanUrl);
        return match?.group(1);
      }
    }

    return cleanUrl;
  }

  /// ✅ Parsear entero de forma segura
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// ✅ Constructor desde JSON local (para datos mock)
  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      phone: json['phone'],
      mobile: json['mobile'],
      email: json['email'],
      website: json['website'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      whatsapp: json['whatsapp'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      postalCode: json['postal_code'],
      city: json['city'],
      totalPoints: json['total_points'] ?? 0,
      isActive: json['is_active'] ?? true,
      schedule: json['schedule'] != null
          ? RestaurantSchedule.fromJson(json['schedule'])
          : null,
      promotion: json['promotion'] != null
          ? RestaurantPromotion.fromJson(json['promotion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'image_url': imageUrl,
      'phone': phone,
      'mobile': mobile,
      'email': email,
      'website': website,
      'instagram': instagram,
      'facebook': facebook,
      'whatsapp': whatsapp,
      'latitude': latitude,
      'longitude': longitude,
      'postal_code': postalCode,
      'city': city,
      'total_points': totalPoints,
      'is_active': isActive,
      'schedule': schedule?.toJson(),
      'promotion': promotion?.toJson(),
    };
  }

  // ✅ URL para Google Maps - MEJORADO
  String get googleMapsUrl {
    if (latitude != null && longitude != null) {
      return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }
    // Si no hay coordenadas, usar dirección + ciudad
    final searchAddress = city != null ? '$address, $city' : address;
    final encodedAddress = Uri.encodeComponent(searchAddress);
    return 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
  }

  // Verificar si tiene datos de contacto
  bool get hasContactInfo {
    return phone != null || mobile != null || email != null || website != null;
  }

  // Verificar si tiene redes sociales
  bool get hasSocialMedia {
    return instagram != null || facebook != null;
  }

  // Verificar si tiene promociones
  bool get hasPromotion {
    return promotion != null;
  }

  // Obtener teléfono principal (móvil primero, luego fijo)
  String? get primaryPhone {
    return mobile?.isNotEmpty == true ? mobile : phone;
  }

  // Verificar si tiene ubicación
  bool get hasLocation {
    return latitude != null && longitude != null;
  }
}

// ✅ Modelo para horarios de restaurantes - SIMPLIFICADO
class RestaurantSchedule {
  final String summarySchedule;
  final List<String> detailedSchedule;

  const RestaurantSchedule({
    required this.summarySchedule,
    required this.detailedSchedule,
  });

  factory RestaurantSchedule.fromJson(Map<String, dynamic> json) {
    return RestaurantSchedule(
      summarySchedule: json['summary_schedule'] ?? '',
      detailedSchedule: List<String>.from(json['detailed_schedule'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary_schedule': summarySchedule,
      'detailed_schedule': detailedSchedule,
    };
  }
}

// ✅ Modelo para promociones de restaurantes - SIMPLIFICADO
class RestaurantPromotion {
  final String title;
  final String description;
  final String? terms;
  final int? pointsRequired;
  final String? discountPercentage;

  const RestaurantPromotion({
    required this.title,
    required this.description,
    this.terms,
    this.pointsRequired,
    this.discountPercentage,
  });

  factory RestaurantPromotion.fromJson(Map<String, dynamic> json) {
    return RestaurantPromotion(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      terms: json['terms'],
      pointsRequired: json['points_required'],
      discountPercentage: json['discount_percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'terms': terms,
      'points_required': pointsRequired,
      'discount_percentage': discountPercentage,
    };
  }
}

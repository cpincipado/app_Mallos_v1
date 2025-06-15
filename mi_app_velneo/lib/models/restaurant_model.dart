// lib/models/restaurant_model.dart - COMPLETO PARA API REAL - SIN PRINTS
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
      print('RestaurantModel: $message');
    }
  }

  /// ✅ Constructor desde JSON de la API real - CORREGIDO
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

    // ✅ Limpiar campos HTML
    final cleanDescription = _cleanHtmlText(json['obs']);
    final cleanSchedule = _cleanHtmlText(json['obs1']);
    final cleanPromotion = _cleanHtmlText(json['txt_tar']);

    // ✅ Crear horario desde obs1
    RestaurantSchedule? schedule;
    if (cleanSchedule.isNotEmpty) {
      schedule = _parseScheduleFromText(cleanSchedule);
    }

    // ✅ Crear promoción desde txt_tar o tot_pun
    RestaurantPromotion? promotion;
    if (cleanPromotion.isNotEmpty) {
      promotion = _parsePromotionFromText(cleanPromotion);
    } else if (_parseInt(json['tot_pun']) > 0) {
      promotion = _createPromotionFromPoints(_parseInt(json['tot_pun']));
    }

    // ✅ Limpiar URLs de redes sociales
    final cleanInstagram = _cleanSocialUrl(json['red_ins'], 'instagram');
    final cleanFacebook = _cleanSocialUrl(json['red_fac'], 'facebook');

    return RestaurantModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['nom_fis']?.toString() ?? '',
      address: fullAddress,
      description: cleanDescription.isNotEmpty ? cleanDescription : null,
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

  /// ✅ Limpiar texto HTML
  static String _cleanHtmlText(dynamic htmlText) {
    if (htmlText == null) return '';

    String text = htmlText.toString();
    if (text.isEmpty) return '';

    // Remover DOCTYPE y tags HTML
    text = text.replaceAll(RegExp(r'<!DOCTYPE[^>]*>'), '');
    text = text.replaceAll(RegExp(r'<html[^>]*>'), '');
    text = text.replaceAll(RegExp(r'</html>'), '');
    text = text.replaceAll(RegExp(r'<head[^>]*>.*?</head>'), '');
    text = text.replaceAll(RegExp(r'<body[^>]*>'), '');
    text = text.replaceAll(RegExp(r'</body>'), '');

    // Remover otros tags HTML
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decodificar entidades HTML comunes
    text = text.replaceAll('&lt;', '<');
    text = text.replaceAll('&gt;', '>');
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', "'");
    text = text.replaceAll('&nbsp;', ' ');
    text = text.replaceAll('‑', '-'); // Guión especial

    // Limpiar espacios y saltos de línea excesivos
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    text = text.trim();

    return text;
  }

  /// ✅ Parsear horario desde texto
  static RestaurantSchedule? _parseScheduleFromText(String scheduleText) {
    if (scheduleText.isEmpty) return null;

    try {
      final lowerText = scheduleText.toLowerCase();

      String? monday, tuesday, wednesday, thursday, friday, saturday, sunday;

      // Buscar patrones específicos
      if (lowerText.contains('luns e venres')) {
        final mondayFridayMatch = RegExp(
          r'luns e venres\s+(\d+\.\d+[‑-]\d+\.\d+(?:,\s*\d+\.\d+[‑-]\d+\.\d+)*)',
        ).firstMatch(lowerText);
        final mondayFridaySchedule = mondayFridayMatch
            ?.group(1)
            ?.replaceAll('‑', '-');
        monday = friday = mondayFridaySchedule;
      }

      if (lowerText.contains('martes a xoves')) {
        final tuesdayThursdayMatch = RegExp(
          r'martes a xoves\s+(\d+\.\d+[‑-]\d+\.\d+(?:,\s*\d+\.\d+[‑-]\d+\.\d+)*)',
        ).firstMatch(lowerText);
        final tuesdayThursdaySchedule = tuesdayThursdayMatch
            ?.group(1)
            ?.replaceAll('‑', '-');
        tuesday = wednesday = thursday = tuesdayThursdaySchedule;
      }

      if (lowerText.contains('sábados')) {
        final saturdayMatch = RegExp(
          r'sábados\s+(\d+\.\d+[‑-]\d+\.\d+)',
        ).firstMatch(lowerText);
        saturday = saturdayMatch?.group(1)?.replaceAll('‑', '-');
      }

      // Si no encontró patrones específicos, usar todo como horario general
      if (monday == null && tuesday == null && saturday == null) {
        final generalSchedule = scheduleText
            .replaceAll('‑', '-')
            .replaceAll('-', '');
        monday = tuesday = wednesday = thursday = friday = saturday = sunday =
            generalSchedule;
      }

      return RestaurantSchedule(
        monday: monday,
        tuesday: tuesday,
        wednesday: wednesday,
        thursday: thursday,
        friday: friday,
        saturday: saturday,
        sunday: sunday,
      );
    } catch (e) {
      _log('Error parseando horario: $e');
      return RestaurantSchedule(
        monday: scheduleText,
        tuesday: scheduleText,
        wednesday: scheduleText,
        thursday: scheduleText,
        friday: scheduleText,
        saturday: scheduleText,
        sunday: scheduleText,
      );
    }
  }

  /// ✅ Parsear promoción desde texto
  static RestaurantPromotion? _parsePromotionFromText(String promotionText) {
    if (promotionText.isEmpty) return null;

    try {
      // Buscar patrones como "5 PUNTOS= 5% de desconto"
      final discountMatch = RegExp(
        r'(\d+)\s*PUNTOS?\s*=\s*(\d+%?\s*[^\.]*)',
        caseSensitive: false,
      ).firstMatch(promotionText);

      if (discountMatch != null) {
        final pointsRequired = int.tryParse(discountMatch.group(1) ?? '');
        final discount = discountMatch.group(2)?.trim();

        return RestaurantPromotion(
          title: 'Promoción EU MALLOS',
          description: '$pointsRequired PUNTOS = $discount',
          pointsRequired: pointsRequired,
          terms: promotionText,
        );
      }

      // Si no encuentra patrón específico, usar todo el texto
      return RestaurantPromotion(
        title: 'Promoción disponible',
        description: promotionText,
        terms: promotionText,
      );
    } catch (e) {
      _log('Error parseando promoción: $e');
      return RestaurantPromotion(
        title: 'Promoción disponible',
        description: promotionText,
      );
    }
  }

  /// ✅ Limpiar URLs de redes sociales
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

  /// ✅ Crear promoción basada en puntos
  static RestaurantPromotion? _createPromotionFromPoints(int points) {
    if (points > 0) {
      return RestaurantPromotion(
        title: 'Puntos EU MALLOS',
        description: 'Tienes $points puntos acumulados en este establecimiento',
        pointsRequired: 5,
      );
    }
    return null;
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

// Modelo para horarios de restaurantes
class RestaurantSchedule {
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;
  final String? sunday;

  const RestaurantSchedule({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory RestaurantSchedule.fromJson(Map<String, dynamic> json) {
    return RestaurantSchedule(
      monday: json['monday'],
      tuesday: json['tuesday'],
      wednesday: json['wednesday'],
      thursday: json['thursday'],
      friday: json['friday'],
      saturday: json['saturday'],
      sunday: json['sunday'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };
  }

  // Obtener horario de hoy
  String get todaySchedule {
    final now = DateTime.now();
    switch (now.weekday) {
      case 1:
        return monday ?? 'Cerrado';
      case 2:
        return tuesday ?? 'Cerrado';
      case 3:
        return wednesday ?? 'Cerrado';
      case 4:
        return thursday ?? 'Cerrado';
      case 5:
        return friday ?? 'Cerrado';
      case 6:
        return saturday ?? 'Cerrado';
      case 7:
        return sunday ?? 'Cerrado';
      default:
        return 'Cerrado';
    }
  }

  // Obtener horario resumido para restaurantes
  String get summarySchedule {
    if (monday == tuesday &&
        tuesday == wednesday &&
        wednesday == thursday &&
        thursday == friday &&
        monday != null) {
      return 'Lun-Vie: $monday';
    }
    return 'Hoy: $todaySchedule';
  }

  // Obtener horarios detallados (para mostrar todos los días)
  List<String> get detailedSchedule {
    final days = [
      'Luns',
      'Martes',
      'Mércores',
      'Xoves',
      'Venres',
      'Sábado',
      'Domingo',
    ];
    final schedules = [
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday,
    ];

    List<String> result = [];
    for (int i = 0; i < days.length; i++) {
      final schedule = schedules[i] ?? 'Cerrado';
      result.add('${days[i]}: $schedule');
    }
    return result;
  }
}

// Modelo para promociones de restaurantes
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

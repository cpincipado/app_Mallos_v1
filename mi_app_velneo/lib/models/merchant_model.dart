// lib/models/merchant_model.dart
class MerchantModel {
  final String id;
  final String name;
  final String address;
  final String? description;
  final String? imageUrl;
  final String? phone;
  final String? email;
  final String? website;
  final String? instagram;
  final String? facebook;
  final String? whatsapp;
  final double? latitude;
  final double? longitude;
  final List<String> categories;
  final MerchantSchedule? schedule;
  final MerchantPromotion? promotion;

  const MerchantModel({
    required this.id,
    required this.name,
    required this.address,
    this.description,
    this.imageUrl,
    this.phone,
    this.email,
    this.website,
    this.instagram,
    this.facebook,
    this.whatsapp,
    this.latitude,
    this.longitude,
    this.categories = const [],
    this.schedule,
    this.promotion,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      whatsapp: json['whatsapp'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      categories: List<String>.from(json['categories'] ?? []),
      schedule: json['schedule'] != null
          ? MerchantSchedule.fromJson(json['schedule'])
          : null,
      promotion: json['promotion'] != null
          ? MerchantPromotion.fromJson(json['promotion'])
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
      'email': email,
      'website': website,
      'instagram': instagram,
      'facebook': facebook,
      'whatsapp': whatsapp,
      'latitude': latitude,
      'longitude': longitude,
      'categories': categories,
      'schedule': schedule?.toJson(),
      'promotion': promotion?.toJson(),
    };
  }

  // URL para Google Maps
  String get googleMapsUrl {
    if (latitude != null && longitude != null) {
      return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }
    final encodedAddress = Uri.encodeComponent(address);
    return 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
  }

  // Verificar si tiene datos de contacto
  bool get hasContactInfo {
    return phone != null || email != null || website != null;
  }

  // Verificar si tiene redes sociales
  bool get hasSocialMedia {
    return instagram != null || facebook != null;
  }

  // Verificar si tiene promociones
  bool get hasPromotion {
    return promotion != null;
  }
}

// Modelo para horarios
class MerchantSchedule {
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;
  final String? sunday;

  const MerchantSchedule({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory MerchantSchedule.fromJson(Map<String, dynamic> json) {
    return MerchantSchedule(
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

  // Obtener horario resumido (ej: "Lun-Vie 9:15-14:00")
  String get summarySchedule {
    if (monday == tuesday &&
        tuesday == wednesday &&
        wednesday == thursday &&
        thursday == friday &&
        monday != null) {
      return 'Lun-Vie $monday';
    }
    return todaySchedule;
  }
}

// Modelo para promociones
class MerchantPromotion {
  final String title;
  final String description;
  final String? terms;
  final int? pointsRequired;
  final String? discountPercentage;

  const MerchantPromotion({
    required this.title,
    required this.description,
    this.terms,
    this.pointsRequired,
    this.discountPercentage,
  });

  factory MerchantPromotion.fromJson(Map<String, dynamic> json) {
    return MerchantPromotion(
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

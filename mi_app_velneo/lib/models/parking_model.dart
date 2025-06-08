// lib/models/parking_model.dart
class ParkingModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final bool isAvailable;

  const ParkingModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.isAvailable = true,
  });

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    return ParkingModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'],
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'is_available': isAvailable,
    };
  }

  // URL para Google Maps
  String get googleMapsUrl {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  // URL alternativa con el nombre del lugar
  String get googleMapsUrlWithName {
    final encodedName = Uri.encodeComponent(name);
    return 'https://www.google.com/maps/search/?api=1&query=$encodedName';
  }
}

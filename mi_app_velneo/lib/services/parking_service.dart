// lib/services/parking_service.dart
import 'package:mi_app_velneo/models/parking_model.dart';

class ParkingService {
  // Datos mock que simulan la respuesta de API
  static List<ParkingModel> getMockParkings() {
    return [
      const ParkingModel(
        id: '1',
        name: 'PARKING GRATUITO EXPRESS',
        latitude: 43.3623, // A Coruña - Centro aproximado
        longitude: -8.4115,
        address: 'Distrito Mallos, A Coruña',
        isAvailable: true,
      ),
      const ParkingModel(
        id: '2',
        name: 'PARKING ESTACIÓN DE TREN',
        latitude: 43.3584, // Estación de tren A Coruña
        longitude: -8.4056,
        address: 'Estación de A Coruña-San Cristóbal',
        isAvailable: true,
      ),
      const ParkingModel(
        id: '3',
        name: 'PARKING LOS MALLOS',
        latitude: 43.3650, // Zona Los Mallos aproximado
        longitude: -8.4100,
        address: 'Los Mallos, A Coruña',
        isAvailable: true,
      ),
      const ParkingModel(
        id: '4',
        name: 'PARKING TR.ª MONFORTE',
        latitude: 43.3640, // Travesía Monforte aproximado
        longitude: -8.4080,
        address: 'Travesía Monforte, A Coruña',
        isAvailable: true,
      ),
    ];
  }

  // Obtener todos los parkings
  static Future<List<ParkingModel>> getAllParkings() async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockParkings();
  }

  // Obtener parking por ID
  static Future<ParkingModel?> getParkingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final parkings = getMockParkings();
    try {
      return parkings.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtener parkings disponibles
  static Future<List<ParkingModel>> getAvailableParkings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final parkings = getMockParkings();
    return parkings.where((item) => item.isAvailable).toList();
  }
}

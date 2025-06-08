// lib/services/merchant_service.dart
import 'package:mi_app_velneo/models/merchant_model.dart';

class MerchantService {
  // Datos mock que simulan la respuesta de API
  static List<MerchantModel> getMockMerchants() {
    return [
      const MerchantModel(
        id: '1',
        name: 'A Campiña Frutería',
        address: 'Avda. Arteixo, 97',
        description:
            'As froitas e verduras de primeira calidade. Alimentación. Produtos ecolóxicos e de proximidade. A túa fruteira de confianza.',
        imageUrl: 'assets/images/fruteria_campina.jpg',
        phone: '981123456',
        instagram: 'campina_fruteria',
        facebook: 'CampinaFruteria',
        latitude: 43.3623,
        longitude: -8.4115,
        categories: ['Alimentación'],
        schedule: MerchantSchedule(
          monday: '9:15-14:00, 17:30-20:00',
          tuesday: '9:15-14:00',
          wednesday: '9:15-14:00, 17:30-20:00',
          thursday: '9:15-14:00',
          friday: '9:15-14:00, 17:30-20:00',
          saturday: '9:30-14:30',
          sunday: null,
        ),
        promotion: MerchantPromotion(
          title: 'Canxea os teus puntos',
          description: '5 PUNTOS = 5% de desconto en compra superior a 30€',
          terms:
              'XUNTA PUNTOS NO NOSO ESTABLECEMENTO. Por cada 10 € que gastes, pídenos que carguemos 1 punto na túa tarxeta EU MALLOS para as túas próximas compras no barrio. Ofertas e descontos non acumulables.',
          pointsRequired: 5,
          discountPercentage: '5%',
        ),
      ),
      const MerchantModel(
        id: '2',
        name: 'Panadería Artesana',
        address: 'Rúa dos Mallos, 15',
        description:
            'Pan artesano elaborado diariamente con ingredientes naturales. Bollería casera y productos de pastelería.',
        imageUrl: 'assets/images/panaderia.jpg',
        phone: '981234567',
        website: 'https://panaderia-artesana.com',
        latitude: 43.3635,
        longitude: -8.4105,
        categories: ['Alimentación', 'Artesanía'],
        schedule: MerchantSchedule(
          monday: '7:00-14:00, 17:00-20:00',
          tuesday: '7:00-14:00, 17:00-20:00',
          wednesday: '7:00-14:00, 17:00-20:00',
          thursday: '7:00-14:00, 17:00-20:00',
          friday: '7:00-14:00, 17:00-20:00',
          saturday: '7:00-15:00',
          sunday: '8:00-14:00',
        ),
        promotion: MerchantPromotion(
          title: 'Desconto especial',
          description: '3 PUNTOS = 10% de desconto en bollería',
          pointsRequired: 3,
          discountPercentage: '10%',
        ),
      ),
      const MerchantModel(
        id: '3',
        name: 'Taller de Cerámica',
        address: 'Travesía Monforte, 8',
        description:
            'Cerámica artesanal hecha a mano. Talleres y cursos para todas las edades.',
        phone: '981345678',
        instagram: 'ceramica_mallos',
        latitude: 43.3640,
        longitude: -8.4080,
        categories: ['Artesanía', 'Antiguidades'],
        schedule: MerchantSchedule(
          monday: null,
          tuesday: '10:00-13:00, 16:00-19:00',
          wednesday: '10:00-13:00, 16:00-19:00',
          thursday: '10:00-13:00, 16:00-19:00',
          friday: '10:00-13:00, 16:00-19:00',
          saturday: '10:00-14:00',
          sunday: null,
        ),
      ),
      const MerchantModel(
        id: '4',
        name: 'Café Central',
        address: 'Plaza de los Mallos, 3',
        description:
            'Café de especialidad y desayunos caseros. Ambiente acogedor en el corazón del barrio.',
        phone: '981456789',
        website: 'https://cafecentral.es',
        facebook: 'CafeCentralMallos',
        whatsapp: '34981456789',
        latitude: 43.3628,
        longitude: -8.4095,
        categories: ['Alimentación'],
        schedule: MerchantSchedule(
          monday: '7:00-22:00',
          tuesday: '7:00-22:00',
          wednesday: '7:00-22:00',
          thursday: '7:00-22:00',
          friday: '7:00-23:00',
          saturday: '8:00-23:00',
          sunday: '9:00-21:00',
        ),
        promotion: MerchantPromotion(
          title: 'Café gratis',
          description: '10 PUNTOS = 1 café gratis',
          pointsRequired: 10,
        ),
      ),
      const MerchantModel(
        id: '5',
        name: 'Librería Lecturas',
        address: 'Calle Arteixo, 45',
        description:
            'Libros nuevos y de segunda mano. Papelería y material de oficina.',
        email: 'info@libreria-lecturas.com',
        website: 'https://libreria-lecturas.com',
        latitude: 43.3615,
        longitude: -8.4125,
        categories: ['Agasallos e complementos'],
        schedule: MerchantSchedule(
          monday: '9:30-13:30, 16:30-20:00',
          tuesday: '9:30-13:30, 16:30-20:00',
          wednesday: '9:30-13:30, 16:30-20:00',
          thursday: '9:30-13:30, 16:30-20:00',
          friday: '9:30-13:30, 16:30-20:00',
          saturday: '10:00-14:00',
          sunday: null,
        ),
      ),
    ];
  }

  // Obtener todas las categorías únicas
  static List<String> getAllCategories() {
    final merchants = getMockMerchants();
    final categories = <String>{};

    for (final merchant in merchants) {
      categories.addAll(merchant.categories);
    }

    return categories.toList()..sort();
  }

  // Obtener todos los comercios
  static Future<List<MerchantModel>> getAllMerchants() async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockMerchants();
  }

  // Obtener comercio por ID
  static Future<MerchantModel?> getMerchantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final merchants = getMockMerchants();
    try {
      return merchants.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Buscar comercios por texto
  static Future<List<MerchantModel>> searchMerchants(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) {
      return getMockMerchants();
    }

    final merchants = getMockMerchants();
    final queryLower = query.toLowerCase();

    return merchants.where((merchant) {
      return merchant.name.toLowerCase().contains(queryLower) ||
          merchant.address.toLowerCase().contains(queryLower) ||
          (merchant.description?.toLowerCase().contains(queryLower) ?? false) ||
          merchant.categories.any(
            (category) => category.toLowerCase().contains(queryLower),
          );
    }).toList();
  }

  // Filtrar comercios por categoría
  static Future<List<MerchantModel>> getMerchantsByCategory(
    String category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final merchants = getMockMerchants();
    return merchants
        .where((merchant) => merchant.categories.contains(category))
        .toList();
  }

  // Buscar y filtrar comercios
  static Future<List<MerchantModel>> searchAndFilterMerchants({
    String? query,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var merchants = getMockMerchants();

    // Filtrar por categoría
    if (category != null && category.isNotEmpty) {
      merchants = merchants
          .where((merchant) => merchant.categories.contains(category))
          .toList();
    }

    // Buscar por texto
    if (query != null && query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      merchants = merchants.where((merchant) {
        return merchant.name.toLowerCase().contains(queryLower) ||
            merchant.address.toLowerCase().contains(queryLower) ||
            (merchant.description?.toLowerCase().contains(queryLower) ??
                false) ||
            merchant.categories.any(
              (cat) => cat.toLowerCase().contains(queryLower),
            );
      }).toList();
    }

    return merchants;
  }

  static Future<void> registerSale({
    required String cardNumber,
    required double amount,
    required int pointsAdded,
    required int pointsSubtracted,
  }) async {}

  static bool validateCardNumber(String value) {
    // Simple validation: card number must be 16 digits
    return RegExp(r'^\d{16}$').hasMatch(value);
  }

  static Future getMerchantSales() async {}
}

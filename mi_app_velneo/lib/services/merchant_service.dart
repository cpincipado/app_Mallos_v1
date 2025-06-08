// lib/services/merchant_service.dart - ARREGLADO COMPLETAMENTE
import 'package:mi_app_velneo/models/merchant_model.dart';
import 'package:mi_app_velneo/models/sale_model.dart';

class MerchantService {
  // ID del comerciante logueado (temporal)
  static const String _currentMerchantId = 'merchant_001';

  // ✅ DATOS MOCK DEL PERFIL DEL COMERCIANTE
  static MerchantProfile getMockMerchantProfile() {
    return const MerchantProfile(
      id: _currentMerchantId,
      name: 'Aparcamiento Los Mallos',
      address: 'Ronda de Outeiro, s/n, Esq. Avda Mallos',
      phone: '981238164',
      email: 'parkimallos@yahoo.es',
      website: 'https://parkingmallos.com/',
      imageUrl: 'assets/images/aparcamiento_mallos.jpg',
      isActive: true,
      stats: MerchantStats(
        totalSales: 156,
        totalPoints: 89,
        totalAmount: 2847.50,
        thisMonthSales: 23,
        thisMonthAmount: 456.75,
      ),
    );
  }

  // ✅ DATOS MOCK DE VENTAS
  static List<SaleModel> getMockSales() {
    return [
      SaleModel(
        id: 'sale_001',
        cardNumber: '1234567890123456',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        amount: 25.50,
        pointsAdded: 3,
        pointsSubtracted: 0,
        merchantId: _currentMerchantId,
        merchantName: 'Aparcamiento Los Mallos',
      ),
      SaleModel(
        id: 'sale_002',
        cardNumber: '9876543210987654',
        date: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        amount: 12.00,
        pointsAdded: 1,
        pointsSubtracted: 0,
        merchantId: _currentMerchantId,
        merchantName: 'Aparcamiento Los Mallos',
      ),
      SaleModel(
        id: 'sale_003',
        cardNumber: '5555444433336666',
        date: DateTime.now().subtract(const Duration(days: 2)),
        amount: 8.75,
        pointsAdded: 0,
        pointsSubtracted: 2,
        merchantId: _currentMerchantId,
        merchantName: 'Aparcamiento Los Mallos',
      ),
      SaleModel(
        id: 'sale_004',
        cardNumber: '1111222233334444',
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: 15.25,
        pointsAdded: 2,
        pointsSubtracted: 0,
        merchantId: _currentMerchantId,
        merchantName: 'Aparcamiento Los Mallos',
      ),
      SaleModel(
        id: 'sale_005',
        cardNumber: '7777888899990000',
        date: DateTime.now().subtract(const Duration(days: 5)),
        amount: 45.00,
        pointsAdded: 0,
        pointsSubtracted: 5,
        merchantId: _currentMerchantId,
        merchantName: 'Aparcamiento Los Mallos',
      ),
    ];
  }

  // ✅ OBTENER PERFIL DEL COMERCIANTE
  static Future<MerchantProfile> getMerchantProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockMerchantProfile();
  }

  // ✅ OBTENER VENTAS DEL COMERCIANTE
  static Future<List<SaleModel>> getMerchantSales() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockSales();
  }

  // ✅ REGISTRAR NUEVA VENTA
  static Future<SaleModel> registerSale({
    required String cardNumber,
    required double amount,
    required int pointsAdded,
    required int pointsSubtracted,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final newSale = SaleModel(
      id: 'sale_${DateTime.now().millisecondsSinceEpoch}',
      cardNumber: cardNumber,
      date: DateTime.now(),
      amount: amount,
      pointsAdded: pointsAdded,
      pointsSubtracted: pointsSubtracted,
      merchantId: _currentMerchantId,
      merchantName: getMockMerchantProfile().name,
    );

    return newSale;
  }

  // ✅ VALIDAR NÚMERO DE TARJETA
  static bool validateCardNumber(String cardNumber) {
    if (cardNumber.isEmpty) return false;
    if (cardNumber.length < 8 || cardNumber.length > 16) return false;
    return RegExp(r'^[0-9]+$').hasMatch(cardNumber);
  }

  // ✅ DESACTIVAR CUENTA
  static Future<bool> deactivateAccount() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  // ✅ OBTENER ESTADÍSTICAS
  static Future<MerchantStats> getMerchantStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return getMockMerchantProfile().stats;
  }

  // ========================
  // COMERCIOS PARA CLIENTES (LO QUE YA TENÍAS)
  // ========================

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
      // ... resto de comercios
    ];
  }

  static List<String> getAllCategories() {
    final merchants = getMockMerchants();
    final categories = <String>{};
    for (final merchant in merchants) {
      categories.addAll(merchant.categories);
    }
    return categories.toList()..sort();
  }

  static Future<List<MerchantModel>> getAllMerchants() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockMerchants();
  }

  static Future<MerchantModel?> getMerchantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final merchants = getMockMerchants();
    try {
      return merchants.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<MerchantModel>> searchMerchants(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return getMockMerchants();

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

  static Future<List<MerchantModel>> getMerchantsByCategory(
    String category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final merchants = getMockMerchants();
    return merchants
        .where((merchant) => merchant.categories.contains(category))
        .toList();
  }

  static Future<List<MerchantModel>> searchAndFilterMerchants({
    String? query,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var merchants = getMockMerchants();

    if (category != null && category.isNotEmpty) {
      merchants = merchants
          .where((merchant) => merchant.categories.contains(category))
          .toList();
    }

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
}

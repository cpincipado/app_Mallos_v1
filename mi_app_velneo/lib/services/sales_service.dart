// lib/services/sales_service.dart
import 'package:mi_app_velneo/models/sale_model.dart';

class SalesService {
  // ID del comerciante logueado (temporal)
  static const String _currentMerchantId = 'merchant_001';

  // Datos mock del perfil del comerciante
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
        totalSales: 0,
        totalPoints: 0,
        totalAmount: 0.0,
        thisMonthSales: 0,
        thisMonthAmount: 0.0,
      ),
    );
  }

  // Datos mock de ventas
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
    ];
  }

  // Obtener perfil del comerciante logueado
  static Future<MerchantProfile> getMerchantProfile() async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockMerchantProfile();
  }

  // Obtener todas las ventas del comerciante
  static Future<List<SaleModel>> getMerchantSales() async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockSales();
  }

  // Registrar nueva venta
  static Future<SaleModel> registerSale({
    required String cardNumber,
    required double amount,
    required int pointsAdded,
    required int pointsSubtracted,
  }) async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 1000));

    // Simular creación de venta
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

  // Obtener estadísticas actualizadas
  static Future<MerchantStats> getMerchantStats() async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 300));

    final sales = getMockSales();
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);

    // Calcular estadísticas
    int totalSales = sales.length;
    int totalPoints = sales.fold(0, (sum, sale) => sum + sale.netPoints);
    double totalAmount = sales.fold(0.0, (sum, sale) => sum + sale.amount);

    // Ventas de este mes
    final thisMonthSales = sales
        .where((sale) => sale.date.isAfter(thisMonth))
        .toList();

    int thisMonthSalesCount = thisMonthSales.length;
    double thisMonthAmount = thisMonthSales.fold(
      0.0,
      (sum, sale) => sum + sale.amount,
    );

    return MerchantStats(
      totalSales: totalSales,
      totalPoints: totalPoints,
      totalAmount: totalAmount,
      thisMonthSales: thisMonthSalesCount,
      thisMonthAmount: thisMonthAmount,
    );
  }

  // Desactivar cuenta del comerciante
  static Future<bool> deactivateAccount() async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 1000));

    // Simular desactivación exitosa
    return true;
  }

  // Validar número de tarjeta EU MALLOS
  static bool validateCardNumber(String cardNumber) {
    // Validación básica: solo números y longitud
    if (cardNumber.isEmpty) return false;
    if (cardNumber.length < 8 || cardNumber.length > 16) return false;

    // Solo números
    return RegExp(r'^[0-9]+$').hasMatch(cardNumber);
  }

  // Obtener ventas filtradas por rango de fechas
  static Future<List<SaleModel>> getSalesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final sales = getMockSales();
    return sales.where((sale) {
      return sale.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          sale.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Buscar ventas por número de tarjeta
  static Future<List<SaleModel>> searchSalesByCard(String cardNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (cardNumber.isEmpty) return getMockSales();

    final sales = getMockSales();
    return sales.where((sale) => sale.cardNumber.contains(cardNumber)).toList();
  }
}

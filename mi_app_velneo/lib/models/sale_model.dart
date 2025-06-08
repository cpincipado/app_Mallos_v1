// lib/models/sale_model.dart
class SaleModel {
  final String id;
  final String cardNumber;
  final DateTime date;
  final double amount;
  final int pointsAdded;
  final int pointsSubtracted;
  final String merchantId;
  final String? merchantName;

  const SaleModel({
    required this.id,
    required this.cardNumber,
    required this.date,
    required this.amount,
    required this.pointsAdded,
    required this.pointsSubtracted,
    required this.merchantId,
    this.merchantName,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] ?? '',
      cardNumber: json['card_number'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      amount: (json['amount'] ?? 0).toDouble(),
      pointsAdded: json['points_added'] ?? 0,
      pointsSubtracted: json['points_subtracted'] ?? 0,
      merchantId: json['merchant_id'] ?? '',
      merchantName: json['merchant_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_number': cardNumber,
      'date': date.toIso8601String(),
      'amount': amount,
      'points_added': pointsAdded,
      'points_subtracted': pointsSubtracted,
      'merchant_id': merchantId,
      'merchant_name': merchantName,
    };
  }

  // Formatear fecha para mostrar
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Formatear hora para mostrar
  String get formattedTime {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Formatear fecha y hora completas
  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }

  // Formatear importe con símbolo de euro
  String get formattedAmount {
    return '${amount.toStringAsFixed(2)}€';
  }

  // Puntos netos (sumados - restados)
  int get netPoints {
    return pointsAdded - pointsSubtracted;
  }

  // Tarjeta enmascarada para mostrar (ej: ****1234)
  String get maskedCardNumber {
    if (cardNumber.length <= 4) return cardNumber;
    return '****${cardNumber.substring(cardNumber.length - 4)}';
  }
}

// Modelo para estadísticas del comerciante
class MerchantStats {
  final int totalSales;
  final int totalPoints;
  final double totalAmount;
  final int thisMonthSales;
  final double thisMonthAmount;

  const MerchantStats({
    required this.totalSales,
    required this.totalPoints,
    required this.totalAmount,
    required this.thisMonthSales,
    required this.thisMonthAmount,
  });

  factory MerchantStats.fromJson(Map<String, dynamic> json) {
    return MerchantStats(
      totalSales: json['total_sales'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      thisMonthSales: json['this_month_sales'] ?? 0,
      thisMonthAmount: (json['this_month_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sales': totalSales,
      'total_points': totalPoints,
      'total_amount': totalAmount,
      'this_month_sales': thisMonthSales,
      'this_month_amount': thisMonthAmount,
    };
  }

  // Formatear importe total
  String get formattedTotalAmount {
    return '${totalAmount.toStringAsFixed(2)}€';
  }

  // Formatear importe del mes
  String get formattedThisMonthAmount {
    return '${thisMonthAmount.toStringAsFixed(2)}€';
  }
}

// Modelo del perfil del comerciante logueado
class MerchantProfile {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final String? email;
  final String? website;
  final String? imageUrl;
  final bool isActive;
  final MerchantStats stats;

  const MerchantProfile({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.website,
    this.imageUrl,
    required this.isActive,
    required this.stats,
  });

  factory MerchantProfile.fromJson(Map<String, dynamic> json) {
    return MerchantProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? true,
      stats: MerchantStats.fromJson(json['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'image_url': imageUrl,
      'is_active': isActive,
      'stats': stats.toJson(),
    };
  }
}

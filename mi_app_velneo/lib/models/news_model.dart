// lib/models/news_model.dart - OPTIMIZADO FINAL SIN _cleanHtmlContent

import 'package:flutter/foundation.dart';

class NewsModel {
  final String id;
  final String title;
  final String content; // ✅ RAW HTML - se limpia en UI con HtmlTextFormatter
  final String? imageUrl;
  final DateTime publishDate;
  final String? category;
  final int? categoryId;
  final bool isHighlighted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.publishDate,
    this.category,
    this.categoryId,
    this.isHighlighted = false,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  /// ✅ LOGGING HELPER CONDICIONAL
  static void _log(String message) {
    if (kDebugMode) {
      print('NewsModel: $message');
    }
  }

  /// ✅ OPTIMIZADO: fromJsonMinimal SIN limpiar HTML
  factory NewsModel.fromJsonMinimal(Map<String, dynamic> json) {
    return NewsModel(
      id:
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: (json['name'] as String? ?? '').trim().isEmpty
          ? 'Sin título'
          : (json['name'] as String).trim(),
      content: '', // ✅ Vacío en datos mínimos
      imageUrl: json['cab'],
      publishDate: _parseDate(json['fch']) ?? DateTime.now(),
      category: null,
      categoryId: json['cat'] as int? ?? 0,
      isHighlighted: json['port'] == true || json['port'] == 1,
      createdAt: _parseDate(json['fch']),
      updatedAt: null,
      isActive: json['pue'] == 0 || json['pue'] == null,
    );
  }

  /// ✅ OPTIMIZADO: fromJsonComplete SIN limpiar HTML
  factory NewsModel.fromJsonComplete(Map<String, dynamic> json) {
    return NewsModel(
      id:
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: (json['name'] as String? ?? '').trim().isEmpty
          ? 'Sin título'
          : (json['name'] as String).trim(),
      content: json['dsc'] ?? '', // ✅ RAW HTML - NO limpiar aquí
      imageUrl: json['cab'],
      publishDate: _parseDate(json['fch']) ?? DateTime.now(),
      category: null,
      categoryId: json['cat'] as int? ?? 0,
      isHighlighted: json['port'] == true || json['port'] == 1,
      createdAt: _parseDate(json['fch']),
      updatedAt: null,
      isActive: json['pue'] == 0 || json['pue'] == null,
    );
  }

  /// ✅ fromJson estándar usa fromJsonComplete
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel.fromJsonComplete(json);
  }

  /// ✅ toJson mantiene HTML crudo
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'dsc': content, // ✅ RAW HTML sin modificar
      'cab': imageUrl,
      'fch': publishDate.toIso8601String(),
      'cat': category,
      'port': isHighlighted,
      'pue': isActive ? 0 : 1,
    };
  }

  /// ✅ PRIVATE: parseDate helper
  static DateTime? _parseDate(dynamic dateValue) {
    if (dateValue == null) return null;

    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        _log('Error parseando fecha: $dateValue');
        return null;
      }
    }

    return null;
  }

  /// ✅ CACHED: Formato de fecha español (evita recalcular)
  String? _cachedFormattedDate;
  String get formattedDate {
    if (_cachedFormattedDate != null) return _cachedFormattedDate!;

    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    _cachedFormattedDate =
        '${publishDate.day} de ${months[publishDate.month - 1]} de ${publishDate.year}';
    return _cachedFormattedDate!;
  }

  /// ✅ CACHED: Formato de fecha corto
  String? _cachedShortDate;
  String get shortFormattedDate {
    if (_cachedShortDate != null) return _cachedShortDate!;

    _cachedShortDate =
        '${publishDate.day.toString().padLeft(2, '0')}/'
        '${publishDate.month.toString().padLeft(2, '0')}'
        '/${publishDate.year}';
    return _cachedShortDate!;
  }

  /// ✅ OPTIMIZADO: contentSummary SIN limpiar HTML
  String get contentSummary {
    if (content.isEmpty) return 'Contenido no disponible';
    // ✅ NO limpiar HTML aquí - HtmlTextFormatter lo hace en UI
    return 'Toca para leer la noticia completa...';
  }

  /// ✅ CACHED: isRecent calculation
  bool? _cachedIsRecent;
  DateTime? _lastRecentCheck;
  bool get isRecent {
    final now = DateTime.now();

    // Cache por 1 hora
    if (_cachedIsRecent != null &&
        _lastRecentCheck != null &&
        now.difference(_lastRecentCheck!) < const Duration(hours: 1)) {
      return _cachedIsRecent!;
    }

    _cachedIsRecent = now.difference(publishDate).inDays <= 7;
    _lastRecentCheck = now;
    return _cachedIsRecent!;
  }

  /// ✅ CACHED: hasValidImage validation
  bool? _cachedHasValidImage;
  bool get hasValidImage {
    if (_cachedHasValidImage != null) return _cachedHasValidImage!;

    _cachedHasValidImage =
        imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('http') || imageUrl!.startsWith('assets/'));
    return _cachedHasValidImage!;
  }

  /// ✅ hasFullContent simple check
  bool get hasFullContent {
    return content.isNotEmpty;
  }

  /// ✅ CACHED: isValidForDisplay
  bool? _cachedIsValid;
  bool get isValidForDisplay {
    if (_cachedIsValid != null) return _cachedIsValid!;

    _cachedIsValid =
        title.isNotEmpty && title.trim().isNotEmpty && title != 'Sin título';
    return _cachedIsValid!;
  }

  /// ✅ copyWith method
  NewsModel copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    DateTime? publishDate,
    String? category,
    int? categoryId,
    bool? isHighlighted,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      publishDate: publishDate ?? this.publishDate,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'NewsModel(id: $id, title: $title, publishDate: $publishDate, highlighted: $isHighlighted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

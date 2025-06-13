// lib/models/news_model.dart - OPTIMIZADO CON DATOS MÍNIMOS Y SIN PRINTS
import 'package:flutter/foundation.dart';

class NewsModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime publishDate;
  final String? category;
  final bool isHighlighted; // Este es el campo "port" de tu API
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  const NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.publishDate,
    this.category,
    this.isHighlighted = false,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  /// ✅ LOGGING HELPER
  static void _log(String message) {
    if (kDebugMode) {
      print('NewsModel: $message');
    }
  }

  /// ✅ Crear NewsModel con DATOS MÍNIMOS para listados (sin content)
  factory NewsModel.fromJsonMinimal(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['name'] ?? 'Sin título',
      content: '', // ✅ NO CARGAR CONTENIDO EN LISTADOS
      imageUrl: json['cab'],
      publishDate: _parseDate(json['fch']) ?? DateTime.now(),
      category: _getCategoryName(json['cat']),
      isHighlighted: json['port'] == true || json['port'] == 1,
      createdAt: _parseDate(json['fch']),
      updatedAt: null,
      isActive: json['pue'] == 0 || json['pue'] == null,
    );
  }

  /// ✅ Crear NewsModel con DATOS COMPLETOS para detalles (con content)
  factory NewsModel.fromJsonComplete(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['name'] ?? 'Sin título',
      content: _cleanHtmlContent(json['dsc'] ?? ''), // ✅ SÍ CARGAR CONTENIDO EN DETALLE
      imageUrl: json['cab'],
      publishDate: _parseDate(json['fch']) ?? DateTime.now(),
      category: _getCategoryName(json['cat']),
      isHighlighted: json['port'] == true || json['port'] == 1,
      createdAt: _parseDate(json['fch']),
      updatedAt: null,
      isActive: json['pue'] == 0 || json['pue'] == null,
    );
  }

  /// ✅ MANTENER COMPATIBILIDAD - Usar método completo por defecto
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel.fromJsonComplete(json);
  }

  /// ✅ Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'dsc': content,
      'cab': imageUrl,
      'fch': publishDate.toIso8601String(),
      'cat': category,
      'port': isHighlighted,
      'pue': isActive ? 0 : 1,
    };
  }

  /// ✅ Limpiar contenido HTML pero mantener formato básico
  static String _cleanHtmlContent(String htmlContent) {
    if (htmlContent.isEmpty) return '';
    
    // ✅ MANTENER FORMATO BÁSICO: Solo limpiar caracteres HTML pero conservar estructura
    String cleaned = htmlContent
        .replaceAll('&nbsp;', ' ') // Reemplazar espacios
        .replaceAll('&amp;', '&') // Reemplazar &
        .replaceAll('&lt;', '<') // Reemplazar <
        .replaceAll('&gt;', '>') // Reemplazar >
        .replaceAll('&quot;', '"') // Reemplazar "
        .replaceAll('&#39;', "'") // Reemplazar '
        .replaceAll('&oacute;', 'ó') // Reemplazar ó
        .replaceAll('&aacute;', 'á') // Reemplazar á
        .replaceAll('&eacute;', 'é') // Reemplazar é
        .replaceAll('&iacute;', 'í') // Reemplazar í
        .replaceAll('&uacute;', 'ú') // Reemplazar ú
        .replaceAll('&ntilde;', 'ñ') // Reemplazar ñ
        .replaceAll('&Oacute;', 'Ó') // Reemplazar Ó
        .replaceAll('&Aacute;', 'Á') // Reemplazar Á
        .replaceAll('&Eacute;', 'É') // Reemplazar É
        .replaceAll('&Iacute;', 'Í') // Reemplazar Í
        .replaceAll('&Uacute;', 'Ú') // Reemplazar Ú
        .replaceAll('&Ntilde;', 'Ñ') // Reemplazar Ñ
        .replaceAll('&ordm;', 'º') // Reemplazar º
        .replaceAll('&ldquo;', '"') // Reemplazar "
        .replaceAll('&rdquo;', '"') // Reemplazar "
        .replaceAll('<!--StartFragment-->', '') // Eliminar comentarios
        .replaceAll('<!--EndFragment-->', '') // Eliminar comentarios
        // ✅ Convertir tags HTML a texto plano manteniendo estructura
        .replaceAll(RegExp(r'<p[^>]*>'), '\n\n') // Párrafos
        .replaceAll('</p>', '') // Cerrar párrafos
        .replaceAll('<br />', '\n') // Saltos de línea
        .replaceAll('<br>', '\n') // Saltos de línea
        .replaceAll(RegExp(r'<a [^>]*>'), '') // Enlaces (abrir)
        .replaceAll('</a>', '') // Enlaces (cerrar)
        .replaceAll(RegExp(r'<[^>]*>'), '') // Eliminar otros tags HTML
        .replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n') // Múltiples saltos a dobles
        .replaceAll(RegExp(r'^\s+'), '') // Espacios al inicio
        .trim();
    
    return cleaned;
  }

  /// ✅ Parsear fechas ISO de tu API
  static DateTime? _parseDate(dynamic dateValue) {
    if (dateValue == null) return null;
    
    if (dateValue is String) {
      try {
        // Tu API usa formato ISO: "2018-03-03T00:00:00.000Z"
        return DateTime.parse(dateValue);
      } catch (e) {
        _log('Error parseando fecha: $dateValue');
        return null;
      }
    }
    
    return null;
  }

  /// ✅ Convertir código de categoría a nombre
  static String? _getCategoryName(dynamic catCode) {
    if (catCode == null) return null;
    
    // Mapear códigos de categoría a nombres (ajustar según tu API)
    switch (catCode) {
      case 1:
        return 'Eventos';
      case 2:
        return 'Noticias';
      case 3:
        return 'Promociones';
      case 4:
        return 'Anuncios';
      default:
        return 'General';
    }
  }

  /// ✅ Formatear fecha para mostrar en español
  String get formattedDate {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];

    return '${publishDate.day} de ${months[publishDate.month - 1]} de ${publishDate.year}';
  }

  /// ✅ Formatear fecha corta
  String get shortFormattedDate {
    return '${publishDate.day.toString().padLeft(2, '0')}/'
           '${publishDate.month.toString().padLeft(2, '0')}'
           '/${publishDate.year}';
  }

  /// ✅ Obtener resumen del contenido (solo si hay contenido)
  String get contentSummary {
    if (content.isEmpty) return 'Contenido no disponible';
    if (content.length <= 150) return content;
    return '${content.substring(0, 150)}...';
  }

  /// ✅ Verificar si es una noticia reciente (últimos 7 días)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(publishDate);
    return difference.inDays <= 7;
  }

  /// ✅ Verificar si tiene imagen válida
  bool get hasValidImage {
    return imageUrl != null && 
           imageUrl!.isNotEmpty && 
           (imageUrl!.startsWith('http') || imageUrl!.startsWith('assets/'));
  }

  /// ✅ Verificar si tiene contenido completo
  bool get hasFullContent {
    return content.isNotEmpty;
  }

  /// ✅ Crear copia con cambios
  NewsModel copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    DateTime? publishDate,
    String? category,
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
      isHighlighted: isHighlighted ?? this.isHighlighted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'NewsModel(id: $id, title: $title, publishDate: $publishDate, port: $isHighlighted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
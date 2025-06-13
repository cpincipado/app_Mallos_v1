// lib/models/news_model.dart - ACTUALIZADO PARA TU API REAL
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

  /// Crear NewsModel desde JSON de tu API específica
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      // ID de tu API
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      
      // Título viene en "name"
      title: json['name'] ?? 'Sin título',
      
      // Contenido viene en "dsc" (con HTML)
      content: _cleanHtmlContent(json['dsc'] ?? ''),
      
      // Imagen viene en "cab" 
      imageUrl: json['cab'],
      
      // Fecha viene en "fch"
      publishDate: _parseDate(json['fch']) ?? DateTime.now(),
      
      // Categoría viene en "cat" (número)
      category: _getCategoryName(json['cat']),
      
      // Campo "port" indica si se muestra en home
      isHighlighted: json['port'] == true || json['port'] == 1,
      
      // Fechas adicionales
      createdAt: _parseDate(json['fch']),
      updatedAt: null,
      
      // Campo "pue" parece indicar estado (0 = activo?)
      isActive: json['pue'] == 0 || json['pue'] == null,
    );
  }

  /// Convertir a JSON
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

  /// Limpiar contenido HTML
  static String _cleanHtmlContent(String htmlContent) {
    if (htmlContent.isEmpty) return '';
    
    // Eliminar tags HTML básicos
    String cleaned = htmlContent
        .replaceAll(RegExp(r'<[^>]*>'), '') // Eliminar tags HTML
        .replaceAll('&nbsp;', ' ') // Reemplazar espacios
        .replaceAll('&amp;', '&') // Reemplazar &
        .replaceAll('&lt;', '<') // Reemplazar <
        .replaceAll('&gt;', '>') // Reemplazar >
        .replaceAll('&quot;', '"') // Reemplazar "
        .replaceAll('&#39;', "'") // Reemplazar '
        .replaceAll(RegExp(r'\s+'), ' ') // Múltiples espacios a uno
        .trim();
    
    return cleaned;
  }

  /// Parsear fechas ISO de tu API
  static DateTime? _parseDate(dynamic dateValue) {
    if (dateValue == null) return null;
    
    if (dateValue is String) {
      try {
        // Tu API usa formato ISO: "2018-03-03T00:00:00.000Z"
        return DateTime.parse(dateValue);
      } catch (e) {
        print('Error parseando fecha: $dateValue');
        return null;
      }
    }
    
    return null;
  }

  /// Convertir código de categoría a nombre
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

  /// Formatear fecha para mostrar en español
  String get formattedDate {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];

    return '${publishDate.day} de ${months[publishDate.month - 1]} de ${publishDate.year}';
  }

  /// Formatear fecha corta
  String get shortFormattedDate {
    return '${publishDate.day.toString().padLeft(2, '0')}/'
           '${publishDate.month.toString().padLeft(2, '0')}/'
           '${publishDate.year}';
  }

  /// Obtener resumen del contenido
  String get contentSummary {
    if (content.length <= 150) return content;
    return '${content.substring(0, 150)}...';
  }

  /// Verificar si es una noticia reciente (últimos 7 días)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(publishDate);
    return difference.inDays <= 7;
  }

  /// Verificar si tiene imagen válida
  bool get hasValidImage {
    return imageUrl != null && 
           imageUrl!.isNotEmpty && 
           (imageUrl!.startsWith('http') || imageUrl!.startsWith('assets/'));
  }

  /// Crear copia con cambios
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
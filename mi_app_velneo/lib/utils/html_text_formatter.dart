// lib/utils/html_text_formatter.dart - VERSIÓN GALLEGO CORREGIDA DEFINITIVA
import 'package:flutter/material.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

/// ✅ UTILITY CLASS para formatear texto HTML - VERSIÓN GALLEGO PERFECTA
/// Mantiene el formato gallego original y corrige las horas
class HtmlTextFormatter {
  HtmlTextFormatter._(); // Constructor privado - solo métodos estáticos

  /// ✅ LIMPIADOR HTML ULTRA ROBUSTO - VERSIÓN ANTI-CSS DEFINITIVA
  static String cleanHtml(String htmlContent) {
    if (htmlContent.isEmpty) return htmlContent;

    String cleaned = htmlContent;

    // ✅ 1. ELIMINAR DECLARACIONES Y COMENTARIOS HTML PRIMERO
    cleaned = cleaned.replaceAll('<!--StartFragment-->', '');
    cleaned = cleaned.replaceAll('<!--EndFragment-->', '');
    cleaned = cleaned.replaceAll(RegExp(r'<!--.*?-->', dotAll: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'<!DOCTYPE[^>]*>', dotAll: true), '');

    // ✅ 2. ELIMINAR BLOQUES CSS COMPLETOS Y HEADERS
    cleaned = cleaned.replaceAll(
      RegExp(r'<style[^>]*>.*?</style>', dotAll: true),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'<head[^>]*>.*?</head>', dotAll: true),
      '',
    );
    cleaned = cleaned.replaceAll(RegExp(r'<meta[^>]*>', dotAll: true), '');

    // ✅ 3. ELIMINAR ATRIBUTOS CSS INLINE COMPLETAMENTE
    cleaned = cleaned.replaceAll(RegExp(r'\s*style="[^"]*"'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s*class="[^"]*"'), '');

    // ✅ 4. ELIMINAR FRAGMENTOS CSS PROBLEMÁTICOS ESPECÍFICOS
    cleaned = cleaned.replaceAll(RegExp(r'p,\s*li\s*\{[^}]*\}'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\{[^}]*white-space[^}]*\}'), '');
    cleaned = cleaned.replaceAll(
      RegExp(r'white-space\s*:\s*pre-wrap\s*;?'),
      '',
    );
    cleaned = cleaned.replaceAll(RegExp(r'font-family\s*:[^;]+;?'), '');
    cleaned = cleaned.replaceAll(RegExp(r'font-size\s*:[^;]+;?'), '');
    cleaned = cleaned.replaceAll(RegExp(r'margin-[^:]*:[^;]+;?'), '');

    // ✅ 5. CONVERTIR TAGS HTML A TEXTO ANTES DE ELIMINARLOS
    // Párrafos y saltos de línea
    cleaned = cleaned.replaceAll(RegExp(r'<p[^>]*>'), '\n\n');
    cleaned = cleaned.replaceAll('</p>', '');
    cleaned = cleaned.replaceAll('<br />', '\n');
    cleaned = cleaned.replaceAll('<br>', '\n');
    cleaned = cleaned.replaceAll('<br/>', '\n');

    // Listas
    cleaned = cleaned.replaceAll(RegExp(r'<ul[^>]*>'), '\n');
    cleaned = cleaned.replaceAll('</ul>', '\n');
    cleaned = cleaned.replaceAll(RegExp(r'<ol[^>]*>'), '\n');
    cleaned = cleaned.replaceAll('</ol>', '\n');
    cleaned = cleaned.replaceAll(RegExp(r'<li[^>]*>'), '• ');
    cleaned = cleaned.replaceAll('</li>', '\n');

    // Encabezados
    cleaned = cleaned.replaceAll(RegExp(r'<h[1-6][^>]*>'), '\n\n');
    cleaned = cleaned.replaceAll(RegExp(r'</h[1-6]>'), '\n');

    // Divs y spans
    cleaned = cleaned.replaceAll(RegExp(r'<div[^>]*>'), '\n');
    cleaned = cleaned.replaceAll('</div>', '');
    cleaned = cleaned.replaceAll(RegExp(r'<span[^>]*>'), '');
    cleaned = cleaned.replaceAll('</span>', '');

    // Enlaces
    cleaned = cleaned.replaceAll(RegExp(r'<a [^>]*>'), '');
    cleaned = cleaned.replaceAll('</a>', '');

    // Tags de documento
    cleaned = cleaned.replaceAll(RegExp(r'<html[^>]*>'), '');
    cleaned = cleaned.replaceAll('</html>', '');
    cleaned = cleaned.replaceAll(RegExp(r'<body[^>]*>'), '');
    cleaned = cleaned.replaceAll('</body>', '');

    // ✅ 6. ELIMINAR CUALQUIER TAG HTML RESTANTE
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

    // ✅ 7. CONVERTIR ENTIDADES HTML
    cleaned = _convertHtmlEntities(cleaned);

    // ✅ 8. ELIMINAR FRAGMENTOS CSS RESIDUALES ULTRA ESPECÍFICO
    cleaned = cleaned.replaceAll(
      RegExp(r'\{[^}]*\}'),
      '',
    ); // Cualquier bloque {}
    cleaned = cleaned.replaceAll('p, li', ''); // Selectores CSS sueltos
    cleaned = cleaned.replaceAll(
      'white-space: pre-wrap;',
      '',
    ); // CSS específico
    cleaned = cleaned.replaceAll('white-space:pre-wrap;', ''); // Sin espacios
    cleaned = cleaned.replaceAll(
      'white-space: pre-wrap',
      '',
    ); // Sin punto y coma
    cleaned = cleaned.replaceAll('pre-wrap', ''); // Solo la palabra
    cleaned = cleaned.replaceAll('qrichtext', ''); // Metadata Qt

    // ✅ 9. LIMPIAR ESPACIOS Y SALTOS EXCESIVOS
    cleaned = _cleanWhitespace(cleaned);

    // ✅ 10. FILTRAR LÍNEAS PROBLEMÁTICAS
    cleaned = _filterProblematicLines(cleaned);

    // ✅ 11. SI QUEDA VACÍO O SOLO SÍMBOLOS, DEVOLVER MENSAJE ALTERNATIVO
    if (cleaned.isEmpty ||
        RegExp(r'^[\s\-•]*$').hasMatch(cleaned) ||
        cleaned.length < 3) {
      return 'Información disponible en el detalle';
    }

    return cleaned;
  }

  /// ✅ PREVIEW ESPECÍFICO PARA LISTADOS (más restrictivo)
  static String getPreview(String? htmlContent, {int maxLength = 120}) {
    if (htmlContent == null || htmlContent.isEmpty) {
      return 'Toca para ver más información...';
    }

    final cleaned = cleanHtml(htmlContent);

    // Si después de limpiar queda muy poco o nada útil
    if (cleaned.length < 20 ||
        cleaned == 'Información disponible en el detalle') {
      return 'Toca para ver descripción completa...';
    }

    // Tomar solo las primeras líneas que tengan contenido real
    final lines = cleaned.split('\n');
    final meaningfulLines = lines
        .where(
          (line) =>
              line.trim().isNotEmpty &&
              line.trim().length > 5 &&
              !line.trim().startsWith('•') &&
              !line.trim().contains('white-space') &&
              !line.trim().contains('pre-wrap'),
        )
        .take(2)
        .toList();

    if (meaningfulLines.isEmpty) {
      return 'Ver información completa...';
    }

    final preview = meaningfulLines.join(' ').trim();

    // Si el preview es demasiado corto, usar mensaje genérico
    if (preview.length < 30) {
      return 'Descubre más información. Toca para ver detalles...';
    }

    // Truncar si es muy largo
    if (preview.length > maxLength) {
      return '${preview.substring(0, maxLength).trim()}...';
    }

    return preview;
  }

  /// ✅ VERSIÓN PARA TÍTULOS (una sola línea, más restrictiva)
  static String getTitle(String? htmlContent, {int maxLength = 50}) {
    if (htmlContent == null || htmlContent.isEmpty) return '';

    final cleaned = cleanHtml(htmlContent);
    final firstLine = cleaned.split('\n').first.trim();

    if (firstLine.length > maxLength) {
      return '${firstLine.substring(0, maxLength).trim()}...';
    }

    return firstLine;
  }

  /// ✅ VERSIÓN ESPECÍFICA PARA HORARIOS - MANTIENE GALLEGO Y CORRIGE HORAS
  static String getSchedule(String? htmlContent) {
    if (htmlContent == null || htmlContent.isEmpty) {
      return 'Horarios non dispoñibles';
    }

    String cleaned = htmlContent;

    // ✅ 1. ELIMINAR DECLARACIONES HTML Y COMENTARIOS
    cleaned = cleaned.replaceAll('<!--StartFragment-->', '');
    cleaned = cleaned.replaceAll('<!--EndFragment-->', '');
    cleaned = cleaned.replaceAll(RegExp(r'<!--.*?-->', dotAll: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'<!DOCTYPE[^>]*>', dotAll: true), '');

    // ✅ 2. ELIMINAR METADATA Y HEADERS COMPLETOS
    cleaned = cleaned.replaceAll(
      RegExp(r'<head[^>]*>.*?</head>', dotAll: true),
      '',
    );
    cleaned = cleaned.replaceAll(RegExp(r'<meta[^>]*>', dotAll: true), '');

    // ✅ 3. ELIMINAR BLOQUES CSS COMPLETOS
    cleaned = cleaned.replaceAll(
      RegExp(r'<style[^>]*>.*?</style>', dotAll: true),
      '',
    );

    // ✅ 4. ELIMINAR ATRIBUTOS CSS INLINE
    cleaned = cleaned.replaceAll(RegExp(r'\s*style="[^"]*"'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s*class="[^"]*"'), '');

    // ✅ 5. ELIMINAR SELECTORES CSS ESPECÍFICOS PROBLEMÁTICOS
    cleaned = cleaned.replaceAll(RegExp(r'p,\s*li\s*\{[^}]*\}'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\{[^}]*white-space[^}]*\}'), '');
    cleaned = cleaned.replaceAll(
      RegExp(r'white-space\s*:\s*pre-wrap\s*;?'),
      '',
    );

    // ✅ 6. CONVERTIR TAGS HTML A TEXTO CONSERVANDO ESTRUCTURA
    cleaned = cleaned.replaceAll(RegExp(r'<p[^>]*>'), '');
    cleaned = cleaned.replaceAll('</p>', '\n');
    cleaned = cleaned.replaceAll('<br />', '\n');
    cleaned = cleaned.replaceAll('<br>', '\n');
    cleaned = cleaned.replaceAll('<br/>', '\n');

    // ✅ 7. ELIMINAR TAGS DE DOCUMENTO
    cleaned = cleaned.replaceAll(RegExp(r'<html[^>]*>'), '');
    cleaned = cleaned.replaceAll('</html>', '');
    cleaned = cleaned.replaceAll(RegExp(r'<body[^>]*>'), '');
    cleaned = cleaned.replaceAll('</body>', '');
    cleaned = cleaned.replaceAll(RegExp(r'<span[^>]*>'), '');
    cleaned = cleaned.replaceAll('</span>', '');
    cleaned = cleaned.replaceAll(RegExp(r'<div[^>]*>'), '');
    cleaned = cleaned.replaceAll('</div>', '');

    // ✅ 8. ELIMINAR CUALQUIER TAG RESTANTE
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

    // ✅ 9. CONVERTIR ENTIDADES HTML
    cleaned = _convertHtmlEntities(cleaned);

    // ✅ 10. ELIMINAR FRAGMENTOS CSS RESIDUALES ULTRA ESPECÍFICOS
    cleaned = cleaned.replaceAll(RegExp(r'\{[^}]*\}'), '');
    cleaned = cleaned.replaceAll('p, li', '');
    cleaned = cleaned.replaceAll('white-space: pre-wrap;', '');
    cleaned = cleaned.replaceAll('white-space:pre-wrap;', '');
    cleaned = cleaned.replaceAll('white-space: pre-wrap', '');
    cleaned = cleaned.replaceAll('white-space:pre-wrap', '');
    cleaned = cleaned.replaceAll('pre-wrap;', '');
    cleaned = cleaned.replaceAll('pre-wrap', '');
    cleaned = cleaned.replaceAll('qrichtext', '');
    cleaned = cleaned.replaceAll('font-family:', '');
    cleaned = cleaned.replaceAll('font-size:', '');
    cleaned = cleaned.replaceAll('margin-', '');

    // ✅ 11. LIMPIAR ESPACIOS PERO SER PERMISIVO CON CONTENIDO
    cleaned = cleaned
        .replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n') // Múltiples saltos
        .replaceAll(
          RegExp(r'^\s+', multiLine: true),
          '',
        ) // Espacios inicio línea
        .replaceAll(
          RegExp(r'\s+$', multiLine: true),
          '',
        ) // Espacios final línea
        .replaceAll(RegExp(r' {2,}'), ' ') // Múltiples espacios
        .trim();

    // ✅ 12. FILTRAR LÍNEAS PROBLEMÁTICAS ESPECÍFICAS
    final lines = cleaned.split('\n');
    final cleanedLines = lines.where((line) {
      final trimmedLine = line.trim();
      return trimmedLine.isNotEmpty &&
          trimmedLine != '-' &&
          !trimmedLine.contains('DOCTYPE') &&
          !trimmedLine.contains('qrichtext') &&
          !trimmedLine.contains('white-space') &&
          !trimmedLine.contains('pre-wrap') &&
          !trimmedLine.contains('font-family') &&
          !trimmedLine.contains('font-size') &&
          !trimmedLine.contains('margin-') &&
          !trimmedLine.contains('{') &&
          !trimmedLine.contains('}') &&
          !trimmedLine.startsWith('p,') &&
          trimmedLine.length > 1;
    }).toList();

    final result = cleanedLines.join('\n').trim();

    // ✅ 13. Si queda muy poco o contiene restos CSS, devolver mensaje
    if (result.isEmpty ||
        result.length < 5 ||
        result.contains('white-space') ||
        result.contains('pre-wrap')) {
      return 'Horarios non dispoñibles';
    }

    // ✅ 14. FORMATEAR HORARIOS GALLEGO - MANTENER FORMATO ORIGINAL
    return _formatGallegoSchedule(result);
  }

  /// ✅ FORMATTER ESPECÍFICO PARA HORARIOS GALLEGO
  static String _formatGallegoSchedule(String schedule) {
    String formatted = schedule;

    // ✅ CORREGIR FORMATO DE HORAS: 12.0016.00 -> 12:00-16:00
    formatted = formatted.replaceAllMapped(
      RegExp(r'(\d{1,2})\.00(\d{1,2})\.00'),
      (match) => '${match.group(1)}:00-${match.group(2)}:00',
    );

    // ✅ CORREGIR OTROS FORMATOS DE HORAS COMUNES
    formatted = formatted.replaceAllMapped(
      RegExp(r'(\d{1,2})\.(\d{2})(\d{1,2})\.(\d{2})'),
      (match) =>
          '${match.group(1)}:${match.group(2)}-${match.group(3)}:${match.group(4)}',
    );

    // ✅ CORREGIR FORMATO SIN SEPARADOR: 12.001600 -> 12:00-16:00
    formatted = formatted.replaceAllMapped(
      RegExp(r'(\d{1,2})\.00(\d{2})\.00'),
      (match) => '${match.group(1)}:00-${match.group(2)}:00',
    );

    // ✅ CORREGIR FORMATO: 19.0023.00 -> 19:00-23:00
    formatted = formatted.replaceAllMapped(
      RegExp(r'(\d{1,2})\.00(\d{2})\.00'),
      (match) => '${match.group(1)}:00-${match.group(2)}:00',
    );

    // ✅ MANTENER PALABRAS GALLEGAS INTACTAS (Luns, Martes, Mércores, etc.)
    // No hacer ningún cambio a las palabras gallegas

    return formatted;
  }

  // ✅ MÉTODOS PRIVADOS DE UTILIDAD

  static String _convertHtmlEntities(String text) {
    final Map<String, String> htmlEntities = {
      '&oacute;': 'ó',
      '&aacute;': 'á',
      '&eacute;': 'é',
      '&iacute;': 'í',
      '&uacute;': 'ú',
      '&ntilde;': 'ñ',
      '&Oacute;': 'Ó',
      '&Aacute;': 'Á',
      '&Eacute;': 'É',
      '&Iacute;': 'Í',
      '&Uacute;': 'Ú',
      '&Ntilde;': 'Ñ',
      '&amp;': '&',
      '&quot;': '"',
      '&#39;': "'",
      '&lt;': '<',
      '&gt;': '>',
      '&nbsp;': ' ',
      '&ordm;': 'º',
      '&ldquo;': '"',
      '&rdquo;': '"',
      '&lsquo;': "'",
      '&rsquo;': "'",
      '&ccedil;': 'ç',
      '&Ccedil;': 'Ç',
      '&agrave;': 'à',
      '&egrave;': 'è',
      '&igrave;': 'ì',
      '&ograve;': 'ò',
      '&ugrave;': 'ù',
      '&atilde;': 'ã',
      '&otilde;': 'õ',
      '&uuml;': 'ü',
      '&Uuml;': 'Ü',
      // ✅ ENTIDADES ESPECÍFICAS GALLEGO
      '&ecirc;': 'ê',
      '&ocirc;': 'ô',
      '&acirc;': 'â',
      '&icirc;': 'î',
      '&ucirc;': 'û',
    };

    String result = text;
    htmlEntities.forEach((entity, replacement) {
      result = result.replaceAll(entity, replacement);
    });
    return result;
  }

  static String _cleanWhitespace(String text) {
    return text
        .replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n') // Múltiples saltos
        .replaceAll(
          RegExp(r'^\s+', multiLine: true),
          '',
        ) // Espacios inicio línea
        .replaceAll(
          RegExp(r'\s+$', multiLine: true),
          '',
        ) // Espacios final línea
        .replaceAll(RegExp(r' {2,}'), ' ') // Múltiples espacios a uno
        .trim();
  }

  static String _filterProblematicLines(String text) {
    final lines = text.split('\n');
    final cleanedLines = lines.where((line) {
      final trimmedLine = line.trim();
      // Filtrar líneas que contengan restos de CSS o HTML - ULTRA ESPECÍFICO
      return trimmedLine.isNotEmpty &&
          !RegExp(r'^[{}();,\s\-:]*$').hasMatch(trimmedLine) &&
          !trimmedLine.startsWith('p,') &&
          !trimmedLine.contains('white-space') &&
          !trimmedLine.contains('pre-wrap') &&
          !trimmedLine.contains('qrichtext') &&
          !trimmedLine.contains('font-family') &&
          !trimmedLine.contains('font-size') &&
          !trimmedLine.contains('margin-') &&
          !trimmedLine.contains('{') &&
          !trimmedLine.contains('}') &&
          !trimmedLine.startsWith('font-') &&
          !trimmedLine.startsWith('margin-') &&
          !trimmedLine.contains('style=') &&
          !trimmedLine.contains('DOCTYPE') &&
          !trimmedLine.contains('<html>') &&
          !trimmedLine.contains('<head>') &&
          !trimmedLine.contains('<body>') &&
          !trimmedLine.contains('<meta') &&
          trimmedLine.length >
              1 && // Líneas muy cortas probablemente sean basura
          trimmedLine != '-'; // Eliminar guiones sueltos
    }).toList();

    return cleanedLines.join('\n').trim();
  }
}

/// ✅ WIDGET PARA MOSTRAR TEXTO HTML FORMATEADO - ULTRA ROBUSTO
/// Uso: CleanHtmlText(htmlContent: "...", style: TextStyle(...))
class CleanHtmlText extends StatelessWidget {
  final String? htmlContent;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final bool isPreview;
  final int previewMaxLength;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  const CleanHtmlText({
    super.key,
    required this.htmlContent,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.isPreview = false,
    this.previewMaxLength = 120,
    this.onTap,
    this.semanticsLabel,
  });

  /// ✅ Constructor específico para PREVIEW (listados)
  const CleanHtmlText.preview({
    super.key,
    required this.htmlContent,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.previewMaxLength = 120,
    this.onTap,
    this.semanticsLabel,
  }) : isPreview = true;

  /// ✅ Constructor específico para TÍTULO (una línea)
  const CleanHtmlText.title({
    super.key,
    required this.htmlContent,
    this.style,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.onTap,
    this.semanticsLabel,
  }) : isPreview = false,
       maxLines = 1,
       previewMaxLength = 50;

  @override
  Widget build(BuildContext context) {
    if (htmlContent == null || htmlContent!.isEmpty) {
      return const SizedBox.shrink();
    }

    final String cleanText = isPreview
        ? HtmlTextFormatter.getPreview(htmlContent, maxLength: previewMaxLength)
        : HtmlTextFormatter.cleanHtml(htmlContent!);

    Widget textWidget = Text(
      cleanText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
    );

    // Si hay onTap, envolver en GestureDetector
    if (onTap != null) {
      textWidget = GestureDetector(onTap: onTap, child: textWidget);
    }

    return textWidget;
  }
}

/// ✅ WIDGET ESPECÍFICO PARA DESCRIPCIÓN DE RESTAURANTE
/// Incluye lógica específica del dominio
class RestaurantDescriptionText extends StatelessWidget {
  final String? description;
  final bool isPreview;
  final VoidCallback? onTap;
  final TextStyle? style;
  final int? maxLines;

  const RestaurantDescriptionText({
    super.key,
    required this.description,
    this.isPreview = false,
    this.onTap,
    this.style,
    this.maxLines,
  });

  const RestaurantDescriptionText.preview({
    super.key,
    required this.description,
    required this.onTap,
    this.style,
  }) : isPreview = true,
       maxLines = 2;

  @override
  Widget build(BuildContext context) {
    if (description == null || description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return CleanHtmlText(
      htmlContent: description,
      style:
          style ??
          TextStyle(
            fontSize: ResponsiveHelper.getCaptionFontSize(context),
            color: Colors.grey.shade700,
            height: 1.3,
          ),
      isPreview: isPreview,
      maxLines: maxLines ?? (isPreview ? 2 : null),
      overflow: TextOverflow.ellipsis,
      onTap: onTap,
      semanticsLabel: isPreview
          ? 'Descripción del restaurante. Toca para ver completa.'
          : 'Descripción completa del restaurante',
    );
  }
}

/// ✅ WIDGET ESPECÍFICO PARA HORARIOS DE RESTAURANTE - GALLEGO CORREGIDO
/// Mantiene el formato gallego original y corrige las horas
class RestaurantScheduleText extends StatelessWidget {
  final String? schedule;
  final TextStyle? style;
  final int? maxLines;
  final bool isDetailed;

  const RestaurantScheduleText({
    super.key,
    required this.schedule,
    this.style,
    this.maxLines,
    this.isDetailed = false,
  });

  /// Constructor para horarios detallados
  const RestaurantScheduleText.detailed({
    super.key,
    required this.schedule,
    this.style,
  }) : maxLines = null,
       isDetailed = true;

  @override
  Widget build(BuildContext context) {
    if (schedule == null || schedule!.isEmpty) {
      return const SizedBox.shrink();
    }

    // ✅ USAR LIMPIEZA ESPECÍFICA PARA HORARIOS GALLEGO
    final cleanSchedule = HtmlTextFormatter.getSchedule(schedule);

    // Si no hay información útil, no mostrar nada
    if (cleanSchedule == 'Horarios non dispoñibles' ||
        cleanSchedule.isEmpty ||
        cleanSchedule.contains('white-space') ||
        cleanSchedule.contains('pre-wrap')) {
      return const SizedBox.shrink();
    }

    return Text(
      cleanSchedule,
      style:
          style ??
          TextStyle(
            fontSize: ResponsiveHelper.getCaptionFontSize(context),
            color: Colors.grey.shade600,
          ),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}

/// ✅ EXTENSIÓN ÚTIL PARA STRING - VERSIÓN GALLEGO
extension HtmlStringExtension on String {
  /// Limpia HTML de este string con máxima robustez
  String get cleanHtml => HtmlTextFormatter.cleanHtml(this);

  /// Obtiene preview ultra limpio de este string HTML
  String htmlPreview([int maxLength = 120]) =>
      HtmlTextFormatter.getPreview(this, maxLength: maxLength);

  /// Obtiene título ultra limpio de este string HTML
  String htmlTitle([int maxLength = 50]) =>
      HtmlTextFormatter.getTitle(this, maxLength: maxLength);

  /// Obtiene horario gallego limpio sin CSS de este string HTML
  String get cleanSchedule => HtmlTextFormatter.getSchedule(this);
}
